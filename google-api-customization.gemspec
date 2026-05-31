require_relative "lib/google_api_customization/version"

Gem::Specification.new do |spec|
  spec.name          = "google-api-customization"
  spec.version       = GoogleApiCustomization::VERSION
  spec.authors       = ["Abhishek Sharma"]
  spec.email         = ["abhsss96@gmail.com"]
  spec.summary       = "Ruby gem to expand usage of Google API with Rails"
  spec.description   = "A wrapper around the Google Places API supporting place lookup, text search, nearby search, photos, reviews, and autocomplete."
  spec.homepage      = "https://github.com/abhsss96/google-api-customization"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7"

  spec.files         = Dir["lib/**/*", "README.md", "*.gemspec"]
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", ">= 0.14"

  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "webmock", "~> 3.0"
end
