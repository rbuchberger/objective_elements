# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'objective_elements/version'

Gem::Specification.new do |spec|
  spec.name          = 'objective_elements'
  spec.version       = ObjectiveElements::VERSION
  spec.authors       = ['Robert Buchberger']
  spec.email         = ['robert@buchberger.cc']

  spec.summary       = 'Build HTML with simple ruby.'
  spec.homepage      = 'https://github.com/rbuchberger/objective_elements'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.0'

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'bug_tracker_uri' => "#{spec.homepage}/issues",
    'changelog_uri' => "#{spec.homepage}/blob/master/CHANGELOG.md",
    'rubygems_mfa_required' => 'true'
  }

  # Specify which files should be added to the gem when it is released.  The
  # `git ls-files -z` loads the files in the RubyGem that have been added into
  # git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
