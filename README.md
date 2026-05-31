# google-api-customization

A Ruby gem that wraps the Google Places API for use in Rails applications. Supports place details, text search, nearby search, radar search, photos, reviews, and autocomplete.

## Installation

Add this line to your `Gemfile`:

```ruby
gem 'google-api-customization'
```

Then run:

```bash
bundle install
```

## Configuration

```ruby
GoogleApiCustomization.configuration do |config|
  config.api_key = "YOUR_GOOGLE_API_KEY"
end
```

## Usage

### Look up a place by ID

```ruby
place = GoogleApiCustomization::Place.find(place_id, api_key, sensor)

place.name               # => "Eiffel Tower"
place.formatted_address  # => "Champ de Mars, Paris, France"
place.lat                # => 48.8584
place.lng                # => 2.2945
place.rating             # => 4.7
place.website            # => "https://www.toureiffel.paris"
place.opening_hours      # => { ... }
```

### Text search

```ruby
places = GoogleApiCustomization::Place.list_by_query(
  "coffee shops",
  api_key,
  sensor,
  lat: 48.8584,
  lng: 2.2945,
  radius: 1000
)
```

### Photos

```ruby
place.photos.each do |photo|
  url = photo.fetch_url(400)  # maxwidth in pixels
end
```

### Reviews

```ruby
place.reviews.each do |review|
  puts "#{review.author_name}: #{review.text} (#{review.rating}/5)"
end
```

## Available Place Attributes

`name`, `place_id`, `lat`, `lng`, `formatted_address`, `formatted_phone_number`, `international_phone_number`, `website`, `rating`, `price_level`, `opening_hours`, `types`, `photos`, `reviews`, `url`, `vicinity`, `address_components`, `utc_offset`

## Dependencies

- [httparty](https://github.com/jnunemaker/httparty)
