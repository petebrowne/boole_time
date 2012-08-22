# -*- encoding: utf-8 -*-
require File.expand_path('../lib/boole_time/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Pete Browne']
  gem.email         = ['me@petebrowne.com']
  gem.description   = %q{ActiveRecord plugin for creating a boolean virtual attribute from
a datetime column.}
  gem.summary       = %q{ActiveRecord plugin for creating a boolean virtual attribute and scopes from
a date or datetime column.}
  gem.homepage      = 'http://github.com/petebrowne/boole_time'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'boole_time'
  gem.require_paths = ['lib']
  gem.version       = BooleTime::VERSION

  gem.add_dependency             'activerecord', '~> 3.2'
  gem.add_development_dependency 'rspec',        '~> 2.11'
  gem.add_development_dependency 'timecop',      '~> 0.4'
  gem.add_development_dependency 'sqlite3',      '~> 1.3'
end
