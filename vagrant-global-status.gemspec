# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vagrant-global-status/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Andrew Thompson"]
  gem.email         = ["athompson@constantcontact.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vagrant-global-status"
  gem.require_paths = ["lib"]
  gem.version       = Vagrant::Global::Status::VERSION

  gem.add_dependency 'rake'
  gem.add_dependency 'systemu'
end
