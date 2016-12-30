# -*- encoding: utf-8 -*-
require File.expand_path('../lib/vatsim_online/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Svilen Vassilev"]
  gem.email         = ["svilen@rubystudio.net"]
  gem.description   = %q{Selectively pulls and parses Vatsim online stations data. Essentially it's a 'who's online' library, capable of displaying online ATC and/or pilots for given airports, areas or globally. Stations are returned as objects, exposing a rich set of attributes. Vatsim data is pulled on preset intervals and cached locally to avoid flooding the servers.}
  gem.summary       = %q{Selectively pulls and parses Vatsim online stations data. Essentially it's a 'who's online' library, capable of displaying online ATC and/or pilots for given airports, areas or globally. Stations are returned as objects, exposing a rich set of attributes. Vatsim data is pulled on preset intervals and cached locally to avoid flooding the servers.}
  gem.homepage      = "https://github.com/tarakanbg/vatsim_online"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "vatsim_online"
  gem.require_paths = ["lib"]
  gem.version       = VatsimOnline::VERSION
  gem.license       = 'MIT'

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "guard"
  gem.add_development_dependency "libnotify"
  gem.add_development_dependency "rb-inotify"
  gem.add_development_dependency "guard-rspec"
  gem.add_dependency "curb"
  gem.add_dependency "time_diff", "~> 0.3.0"
  gem.add_dependency "gcmapper", "~> 0.4.0"
end
