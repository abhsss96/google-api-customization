require "httparty"
require_relative "google_api_customization/version"
require_relative "google_api_customization/errors"
require_relative "google_api_customization/request"
require_relative "google_api_customization/place"
require_relative "google_api_customization/api_key"
require_relative "google_api_customization/photo"
require_relative "google_api_customization/review"

module GoogleApiCustomization
  class << self
    attr_accessor :api_key

    def configuration
      yield self
    end
  end
end

