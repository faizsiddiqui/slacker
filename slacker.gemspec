# frozen_string_literal: true

require_relative "lib/slacker/version"

Gem::Specification.new do |spec|
  spec.name = "slacker"
  spec.version = Slacker::VERSION
  spec.authors = ["Faiz Siddiqui"]
  spec.email = ["faiz.siddiqui@coupa.com"]

  spec.summary = "Rudimentary configuration management tool"
  spec.description = "Rudimentary configuration management tool"
  spec.homepage = "https://github.com/faizsiddiqui"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["github_repo"] = "ssh://github.com/faizsiddiqui/slacker"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = ["slacker"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "net-ssh"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
