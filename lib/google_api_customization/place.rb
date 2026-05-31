module GoogleApiCustomization
  
  attr_accessor :lat, :lng, :viewport, :name, :icon, :reference, :vicinity, :types, :id, :formatted_phone_number, :international_phone_number, :formatted_address, :address_components, :street_number, :street, :city, :region, :postal_code, :country, :rating, :url, :cid, :website, :reviews, :aspects, :zagat_selected, :zagat_reviewed, :photos, :review_summary, :nextpagetoken, :price_level, :opening_hours, :events, :utc_offset, :place_id

  class Place
    
    
    def self.find(place_id, api_key, sensor, options = {})
      language  = options.delete(:language)
      retry_options = options.delete(:retry_options) || {}
      extensions = options.delete(:review_summary) ? 'review_summary' : nil
      
      response = Request.place(
                                {
                                  :placeid => place_id,
                                  :sensor => sensor,
                                  :key => api_key,
                                  :language => language,
                                  :extensions => extensions,
                                  :retry_options => retry_options
                                }
      )
      
      self.new(response['result'], api_key, sensor)
    end    
    

    # Search for Spots with a pagetoken
    #
    # @return [Array<Spot>]
    # @param [String] pagetoken the token to find next results
    # @param [String] api_key the provided api key
    # @param [Boolean] sensor
    # @param [Hash] options
    def self.list_by_pagetoken(pagetoken, api_key, sensor, options = {})
      exclude = options.delete(:exclude) || []
      exclude = [exclude] unless exclude.is_a?(Array)

      options = {
          :pagetoken => pagetoken,
          :sensor => sensor,
          :key => api_key
      }

      request(:spots_by_pagetoken, false, exclude, options)
    end


    def self.list_by_query(query, api_key, sensor, options = {})
      if options.has_key?(:lat) && options.has_key?(:lng)
        with_location = true
      else
        with_location = false
      end

      if options.has_key?(:radius)
        with_radius = true
      else
        with_radius = false
      end

      query = query
      sensor = sensor
      multipage_request = !!options.delete(:multipage)
      location = Location.new(options.delete(:lat), options.delete(:lng)) if with_location
      radius = options.delete(:radius) if with_radius
      rankby = options.delete(:rankby)
      language = options.delete(:language)
      types = options.delete(:types)
      exclude = options.delete(:exclude) || []
      retry_options = options.delete(:retry_options) || {}

      exclude = [exclude] unless exclude.is_a?(Array)

      options = {
        :query => query,
        :sensor => sensor,
        :key => api_key,
        :rankby => rankby,
        :language => language,
        :retry_options => retry_options
      }

      options[:location] = location.format if with_location
      options[:radius] = radius if with_radius

      # Accept Types as a string or array
      if types
        types = (types.is_a?(Array) ? types.join('|') : types)
        options.merge!(:types => types)
      end

      request(:spots_by_query, multipage_request, exclude, options)
    end

    def self.list_by_nearby(lat, lng, radius, api_key, sensor, options = {})
      multipage_request = !!options.delete(:multipage)
      location = Location.new(lat, lng)
      rankby = options.delete(:rankby)
      language = options.delete(:language)
      types = options.delete(:types)
      exclude = options.delete(:exclude) || []
      retry_options = options.delete(:retry_options) || {}

      exclude = [exclude] unless exclude.is_a?(Array)

      options = {
        :location => location.format,
        :radius   => radius,
        :sensor   => sensor,
        :key      => api_key,
        :rankby   => rankby,
        :language => language,
        :retry_options => retry_options
      }

      if types
        types = (types.is_a?(Array) ? types.join('|') : types)
        options.merge!(:types => types)
      end

      request(:spots_by_nearby, multipage_request, exclude, options)
    end

    def self.request(method, multipage_request, exclude, options)
      results = []

      self.multi_pages_request(method, multipage_request, options) do |result|
        # Some places returned by Google do not have a 'types' property. If the user specified 'types', then
        # this is a non-issue because those places will not be returned. However, if the user did not specify
        # 'types', then we do not want to filter out places with a missing 'types' property from the results set.
        results << self.new(result, options[:key], options[:sensor]) if result['types'].nil? || (result['types'] & exclude) == []
      end

      results
    end

    
    
    def initialize(json_result_object, api_key, sensor)
      @reference                  = json_result_object['reference']
      @place_id                   = json_result_object['place_id']
      @vicinity                   = json_result_object['vicinity']
      @lat                        = json_result_object['geometry']['location']['lat']
      @lng                        = json_result_object['geometry']['location']['lng']
      @viewport                   = json_result_object['geometry']['viewport']
      @name                       = json_result_object['name']
      @icon                       = json_result_object['icon']
      @types                      = json_result_object['types']
      @id                         = json_result_object['id']
      @formatted_phone_number     = json_result_object['formatted_phone_number']
      @international_phone_number = json_result_object['international_phone_number']
      @formatted_address          = json_result_object['formatted_address']
      @address_components         = json_result_object['address_components']
      @street_number              = address_component(:street_number, 'short_name')
      @street                     = address_component(:route, 'long_name')
      @city                       = address_component(:locality, 'long_name')
      @region                     = address_component(:administrative_area_level_1, 'long_name')
      @postal_code                = address_component(:postal_code, 'long_name')
      @country                    = address_component(:country, 'long_name')
      @rating                     = json_result_object['rating']
      @price_level                = json_result_object['price_level']
      @opening_hours              = json_result_object['opening_hours']
      @url                        = json_result_object['url']
      @cid                        = json_result_object['url'].to_i
      @website                    = json_result_object['website']
      @zagat_reviewed             = json_result_object['zagat_reviewed']
      @zagat_selected             = json_result_object['zagat_selected']
      @aspects                    = aspects_component(json_result_object['aspects'])
      @review_summary             = json_result_object['review_summary']
      @photos                     = photos_component(json_result_object['photos'], api_key, sensor)
      @reviews                    = reviews_component(json_result_object['reviews'])
      @nextpagetoken              = json_result_object['nextpagetoken']
      @events                     = events_component(json_result_object['events'])
      @utc_offset                 = json_result_object['utc_offset']
    end
    
    def [] (key)
      send(key)
    end

    
    
    
    def address_component(address_component_type, address_component_length)
      if component = address_components_of_type(address_component_type)
        component.first[address_component_length] unless component.first.nil?
      end
    end
    
    def address_components_of_type(type)
      @address_components.select{ |c| c['types'].include?(type.to_s) } unless @address_components.nil?
    end
    
    def reviews_component(json_reviews)
      if json_reviews
        json_reviews.map { |r|
          Review.new(
              r['rating'],
              r['type'],
              r['author_name'],
              r['author_url'],
              r['text'],
              r['time'].to_i
          )
        }
      else []
      end
    end
    
    def aspects_component(json_aspects)
      json_aspects.to_a.map{ |r| { :type => r['type'], :rating => r['rating'] } }
    end

    def photos_component(json_photos, api_key, sensor)
      if json_photos
        json_photos.map{ |p| 
          Photo.new(
            p['width'], 
            p['height'],
            p['photo_reference'],
            p['html_attributions'], 
            api_key, 
            sensor
          )
        }
      else []
      end
    end

    def events_component(json_events)
      json_events.to_a.map{ |r| {:event_id => r['event_id'], :summary => r['summary'], :url => r['url'], :start_time => r['start_time']} }
    end
    
  end
end