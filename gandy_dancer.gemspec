$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'gandy_dancer/version'

Gem::Specification.new do |s|
  s.name        = 'gandy_dancer'
  s.version     = GandyDancer::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Alexey Kuznetsov']
  s.email       = ['me@kuznetsoff.io']
  s.homepage    = 'https://github.com/semenovdl/gandy_dancer'
  s.summary     = 'Rails application generator'
  s.description = 'GandyDancer generate rails application'
  s.license     = 'MIT'

  s.add_dependency('rake', '~> 11.1', '>= 11.1.2')
  s.add_dependency('thor', '~> 0.19.1')

  s.files         = `git ls-files -- lib/*`.split("\n") + %w(History.txt License.txt README.md)
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
