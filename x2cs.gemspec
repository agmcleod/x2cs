Gem::Specification.new do |s|
  s.name = "x2cs"
  s.version = "1.0"
  s.platform = "ruby"
  s.authors = ["Aaron McLeod"]
  s.email = ["aaron.g.mcleod@gmail.com"]
  s.homepage = "http://github.com/agmcleod/x2c"
  s.summary = "A tool for converting XML data to CSV. Generally meant for entities with fields, as supposed to many nodes deep."
  s.description = ""
  s.files = Dir.glob("{spec,bin}/**/*") + %w{README.md .gitignore Gemfile xmlparse.rb}
  s.require_path = '.'
  s.add_development_dependency "rspec"
  s.bindir = 'bin'
  s.executables = ['x2cs']
  s.default_executable = 'x2cs'
end