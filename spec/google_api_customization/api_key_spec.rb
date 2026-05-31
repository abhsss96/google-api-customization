require "spec_helper"

RSpec.describe GoogleApiCustomization::ApiKey do
  describe "#initialize" do
    it "uses the provided api key" do
      api_key = described_class.new("my_key")
      expect(api_key.api_key).to eq("my_key")
    end

    it "falls back to the globally configured api key" do
      GoogleApiCustomization.api_key = "global_key"
      api_key = described_class.new(nil)
      expect(api_key.api_key).to eq("global_key")
      GoogleApiCustomization.api_key = nil
    end

    it "defaults sensor to false" do
      api_key = described_class.new("my_key")
      expect(api_key.sensor).to be false
    end
  end
end
