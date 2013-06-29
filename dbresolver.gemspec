# -*- encoding: utf-8 -*-
lib = File.expand_path(File.dirname(__FILE__), 'lib/dbresolver')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "dbresolver"
  gem.version       = '0.0.1'
  gem.platform      = Gem::Platform::RUBY
  gem.authors       = ["Nicholas Guarino"]
  gem.email         = ["ndguarino@gmail.com"]
  gem.description   = %q{Database resolver for Rails 3}
  gem.summary       = %q{Database resolver for Rails 3}
  gem.homepage      = ""

  gem.add_dependency 'rails', ">= 3.0.7"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
