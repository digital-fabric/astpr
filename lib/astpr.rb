# frozen_string_literal: true

require 'parser/current'

module ASTPR
  class Converter
    attr_reader :code, :filename

    def initialize(code, filename)
      @code = code
      @filename = filename
      @root = RubyVM::AbstractSyntaxTree.of(code, keep_script_lines: true)
      @source = @root.source
      @first_lineno = @root.first_lineno
      @buffer = Parser::Source::Buffer.new(filename, @first_lineno, source: @source)
      p code_source: @source
    end

    def convert
      convert_node(@root)
    end

    def convert_node(node)
      method_name = :"convert_#{node.type.downcase}"
      send(method_name, node)
    end

    def convert_scope(node)
      p scope: node
      p children: node.children
      child = node.children[2]
      convert_node(child)
      # p children: node.children
      # node
    end
  
    def convert_str(node)
      p str_children: node.children
      parser_node(:str, [node.children.first], node)
    end
  
    def parser_node(type, children, source_node)
      Parser::AST::Node.new(type, children, location: convert_location(source_node))
    end
  
    def convert_location(node)
      start_pos   = location_to_pos(node.first_lineno, node.first_column)
      stop_pos    = location_to_pos(node.last_lineno, node.last_column) - 1
      start_range = parser_range(start_pos, start_pos + 1)
      stop_range  = parser_range(stop_pos, stop_pos + 1)
      expr_range  = parser_range(start_pos, stop_pos + 1)
      Parser::Source::Map::Collection.new(start_range, stop_range, expr_range)
    end

    def parser_range(start_pos, stop_pos)
      Parser::Source::Range.new(@buffer, start_pos, stop_pos)
    end

    def location_to_pos(lineno, column)
      @lines ||= @source.lines
      @line_start_idxs ||= calculate_line_start_idxs(@lines)
      p start_idxs: @line_start_idxs
      @line_start_idxs[lineno - @first_lineno] + (column - 1)
    end

    def calculate_line_start_idxs(lines)
      count = 0
      lines.each_with_object([]) do |l, a|
        a << count
        count += l.size
      end
    end
  end

  def self.parse(code, filename)
    Converter.new(code, filename).convert
  end

end
