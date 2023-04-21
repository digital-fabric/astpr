require_relative './lib/astpr/version'

Gem::Specification.new do |s|
  s.name        = 'astpr'
  s.version     = ASTPR::VERSION
  s.licenses    = ['MIT']
  s.summary     = 'ASTPR: Ruby VM AST to parser AST converter'
  s.author      = 'Sharon Rosner'
  s.email       = 'sharon@noteflakes.com'
  s.files       = `git ls-files README.md CHANGELOG.md lib`.split
  s.homepage    = 'http://github.com/digital-fabric/astpr'
  s.metadata    = {
    "source_code_uri" => "https://github.com/digital-fabric/astpr",
    "documentation_uri" => "https://www.rubydoc.info/gems/astpr",
    "homepage_uri" => "https://github.com/digital-fabric/astpr",
    "changelog_uri" => "https://github.com/digital-fabric/astpr/blob/master/CHANGELOG.md"
  }

  s.rdoc_options = ["--title", "ASTPR", "--main", "README.md"]
  s.extra_rdoc_files = ["README.md"]
  s.require_paths = ["lib"]
  s.required_ruby_version = '>= 3.1'

  s.add_runtime_dependency      'parser', '~>3.2.2.0'
  s.add_development_dependency  'minitest', '~>5.18'
end
