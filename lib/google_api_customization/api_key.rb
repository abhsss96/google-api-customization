module GoogleApiCustomization
  
  class ApiKey
    
    attr_reader :api_key

    attr_reader :options
    attr_reader :sensor
    
    def initialize(api_key = @api_key, sensor = false, options = {})
      api_key ? @api_key = api_key : @api_key = GoogleApiCustomization.api_key
      @sensor = sensor
      @options = options
    end
    
    def place_detail(place_id, options = {})
      Place.find(place_id, @api_key, @sensor, @options.merge(options))
    end
  end   
 
end
