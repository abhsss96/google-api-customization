require_relative "lib/google_api_customization/version"

Gem::Specification.new do |spec|
  spec.name          = "google-api-customization"
  spec.version       = GoogleApiCustomization::VERSION
  spec.authors       = ["Abhishek Sharma"]
  spec.email         = ["abhsss96@gmail.com"]
  spec.summary       = "Google Places API wrapper for Rails — place search, details, photos, reviews, autocomplete"
  spec.description   = <<~DESC
    google-api-customization is a Ruby wrapper around the Google Places API that
    makes it easy to integrate place discovery into Rails applications.

    Features:
    - Place detail lookup by place ID (name, address, phone, rating, hours, photos, reviews)
    - Text search for places by query string with optional location bias
    - Nearby search by coordinates and radius
    - Autocomplete for place names and addresses
    - Photo URL resolution
    - Full error handling (OverQueryLimitError, RequestDeniedError, NotFoundError, etc.)
    - Configurable retry logic with delay

    Built on HTTParty for HTTP and supports the legacy Google Places API endpoints.
  DESC
  spec.homepage      = "https://github.com/abhsss96/google-api-customization"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.7"

  spec.metadata = {
    "homepage_uri"    => "https://github.com/abhsss96/google-api-customization",
    "source_code_uri" => "https://github.com/abhsss96/google-api-customization",
    "bug_tracker_uri" => "https://github.com/abhsss96/google-api-customization/issues",
    "changelog_uri"   => "https://github.com/abhsss96/google-api-customization/releases",
    "tags"            => "google-places-api, google-maps, places-api, geolocation, autocomplete, place-search, poi, location-based-services, httparty, rails"
  }

  spec.files         = Dir["lib/**/*", "README.md", "*.gemspec"]
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", ">= 0.14"

  spec.add_development_dependency "rspec", "~> 3.12"
  spec.add_development_dependency "webmock", "~> 3.0"
end
