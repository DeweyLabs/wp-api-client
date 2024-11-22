lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "wp_api_client/version"

Gem::Specification.new do |spec|
  spec.name = "wp-api-client"
  spec.version = WpApiClient::VERSION
  spec.authors = ["Duncan Brown"]
  spec.email = ["duncanjbrown@gmail.com"]

  spec.summary = "A read-only client for the WordPress REST API (v2)."
  spec.homepage = "https://github.com/duncanjbrown/wp-api-client"
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 2.7"
  spec.add_dependency "faraday-http-cache", "~> 2.5"
  spec.add_dependency "faraday-follow_redirects", "~> 0.3.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "debug"
end
