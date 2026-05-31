require "bundler/setup"
require "webmock/rspec"
require "google_api_customization"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
