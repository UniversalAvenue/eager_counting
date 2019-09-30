$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'eager_counting/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'eager_counting'
  s.version     = EagerCounting::VERSION
  s.authors     = ["Tim 'S.D.Eagle' Zeitz"]
  s.email       = ['dev.tim.zeitz@gmail.com']

  s.homepage    = 'https://github.com/UniversalAvenue/eager_counting'
  s.summary     = 'Avoid ActiveRecord N+1 Queries caused by `count` calls!'
  s.description = <<-EOF
    Eager Counting allows you to easily perform complex association grouped count queries.
  EOF
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE.txt', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'activerecord', '>= 4.2', '< 7'
  s.add_dependency 'activesupport', '>= 4.2', '< 7'

  s.add_development_dependency 'rails', '>= 4.2'
  s.add_development_dependency 'sqlite3', '~> 1.3'
  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'rake', '~> 10.0'
end
