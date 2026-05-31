module GoogleApiCustomization
  class Request
    attr_accessor :response
    attr_reader :options

    include ::HTTParty
    format :json
        
    
    PLACES_URL                  =          "https://maps.googleapis.com/maps/api/place/details/json"

    RADAR_SEARCH_URL            =          "https://maps.googleapis.com/maps/api/place/radarsearch/json"

    TEXT_SEARCH_URL             =          "https://maps.googleapis.com/maps/api/place/textsearch/json"

    NEARBY_SEARCH_URL           =          "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

    PHOTO_URL                   =          "https://maps.googleapis.com/maps/api/place/photo"

    PAGETOKEN_URL               =          "https://maps.googleapis.com/maps/api/place/search/json"

    AUTOCOMPLETE_URL            =          "https://maps.googleapis.com/maps/api/place/autocomplete/json"

    def self.place(options = {})
      request = new(PLACES_URL, options)
      request.parsed_response
    end

    def self.nearby_search(options = {})
      request = new(NEARBY_SEARCH_URL, options)
      request.parsed_response
    end

    def self.text_search(options = {})
      request = new(TEXT_SEARCH_URL, options)
      request.parsed_response
    end

    def self.autocomplete(options = {})
      request = new(AUTOCOMPLETE_URL, options)
      request.parsed_response
    end
    
    def initialize(url, options, follow_redirects = true)
      retry_options = options.delete(:retry_options) || {}

      retry_options[:status] ||= []
      retry_options[:max]    ||= 0
      retry_options[:delay]  ||= 5

      retry_options[:status] = [retry_options[:status]] unless retry_options[:status].is_a?(Array)
      @response = self.class.get(url, :query => options, :follow_redirects => follow_redirects)

      # puts @response.request.last_uri.to_s

      return unless retry_options[:max] > 0 && retry_options[:status].include?(@response.parsed_response['status'])

      retry_request = proc do
        for i in (1..retry_options[:max])
          sleep(retry_options[:delay])

          @response = self.class.get(url, :query => options, :follow_redirects => follow_redirects)

          break unless retry_options[:status].include?(@response.parsed_response['status'])
        end
      end

      if retry_options[:timeout]
        begin
          Timeout::timeout(retry_options[:timeout]) do
            retry_request.call
          end
        rescue Timeout::Error
          raise RetryTimeoutError.new(@response)
        end
      else
        retry_request.call

        raise RetryError.new(@response) if retry_options[:status].include?(@response.parsed_response['status'])
      end
    end


    def parsed_response
    
      return @response.headers["location"] if @response.code >= 300 and @response.code < 400
      case @response.parsed_response['status']
      when 'OK', 'ZERO_RESULTS'
        @response.parsed_response
      when 'OVER_QUERY_LIMIT'
        raise OverQueryLimitError.new(@response)
      when 'REQUEST_DENIED'
        raise RequestDeniedError.new(@response)
      when 'INVALID_REQUEST'
        raise InvalidRequestError.new(@response)
      when 'UNKNOWN_ERROR'
        raise UnknownError.new(@response)
      when 'NOT_FOUND'
        raise NotFoundError.new(@response)
      end
    
    end 
      
  end
  
  
  
end