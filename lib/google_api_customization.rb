require 'debugger'
require 'rubygems'
require 'httparty'

%w(request place api_key photo review).each do |file|
  require File.join(File.dirname(__FILE__), 'google_api_customization', file)
end


module GoogleApiCustomization
  
  class << self

    attr_accessor :api_key

    def configuration
      
      yield self
      
    end

  end

end