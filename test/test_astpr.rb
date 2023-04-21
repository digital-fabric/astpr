# frozen_string_literal: true

require 'bundler/setup'
require 'minitest/autorun'
require 'astpr'

module Minitest::Assertions
  def assert_identical_range(r1, r2)
    msg = message(msg) { "Expected #{r1.inspect} to equal #{r2.inspect}" }

    assert_equal r1.begin_pos, r2.begin_pos, msg
    assert_equal r1.end_pos, r2.end_pos, msg

    b1 = r1.source_buffer
    b2 = r2.source_buffer

    assert_equal b1.first_line, b2.first_line, msg
    assert_equal b1.name, b2.name, msg
  end

  def assert_identical_location(ast1, ast2)
    l1 = ast1.location
    l2 = ast2.location

    msg = message(msg) { "Expected #{l1.inspect} to equal #{l2.inspect}" }

    assert_equal l1.node, l2.node
    assert_identical_range l1.expression, l2.expression
    assert_identical_range l1.begin, l2.begin
    assert_identical_range l1.end, l2.end
  end
end

class BasicTest < MiniTest::Test
  def select_source(start, stop)
    p start: start
    p stop: stop
    lines = IO.read(__FILE__).lines[(start.first - 1)..(stop.first - 1)]
    lines[0] = lines[0][(start.last + 1)..-1]
    lines[lines.size - 1] = lines[lines.size - 1][-1..-1]
    lines.join
  end

  def parse_inline_code(code)
    ast_root = RubyVM::AbstractSyntaxTree.of(code, keep_script_lines: true)
    p ast_root_source: ast_root.source


    source = select_source([ast_root.first_lineno, ast_root.first_column], [ast_root.last_lineno, ast_root.last_column])
    p inline_source: source
    buffer = Parser::Source::Buffer.new(__FILE__, ast_root.first_lineno, source: source)
    # buffer = Parser::Source::Buffer.new(__FILE__, line_range.first, source: source)
    p buffer: buffer
    Parser::CurrentRuby.new.parse(buffer)
  end

  def test_foo
    lno = __LINE__ + 2
    code = proc {
      'foo'
    }

    parsed = parse_inline_code(code)
    p parsed: parsed
    p class: parsed.class
    p location: parsed.location
    p begin: parsed.location.begin

    converted = ASTPR.parse(code, __FILE__)
    assert_equal converted, parsed

    assert_identical_location(parsed, converted)
  end
end
