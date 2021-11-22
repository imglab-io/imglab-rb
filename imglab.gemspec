require_relative 'lib/imglab/version'

Gem::Specification.new do |spec|
  spec.name          = "imglab"
  spec.version       = Imglab::VERSION
  spec.authors       = ["imglab"]
  spec.email         = ["support@imglab.io"]

  spec.summary       = %q{Official imglab Ruby library.}
  spec.description   = %q{Official Ruby library to integrate with imglab services.}
  spec.homepage      = "https://github.com/imglab-io/imglab-rb"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/imglab-io/imglab-rb"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
