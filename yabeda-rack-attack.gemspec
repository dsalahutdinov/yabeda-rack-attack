# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yabeda/rack/attack/version'

Gem::Specification.new do |spec|
  spec.name          = 'yabeda-rack-attack'
  spec.version       = Yabeda::Rack::Attack::VERSION
  spec.authors       = ['Dmitry Salahutdinov']
  spec.email         = ['dsalahutdinov@gmail.com']

  spec.summary       = 'Monitoring for rack-attack rules matching'
  spec.description   = 'Extends Yabeda metrics to collect rack-attack metrics'
  spec.homepage      = 'https://github.com/yabeda-rb/yabeda-rack-attack'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/yabeda-rb/yabeda-rack-attack'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rack-attack'
  spec.add_dependency 'yabeda'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.15'
end
