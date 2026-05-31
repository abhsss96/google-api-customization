require "spec_helper"

RSpec.describe GoogleApiCustomization::Request do
  let(:api_key) { "test_api_key" }
  let(:place_id) { "ChIJN1t_tDeuEmsRUsoyG83frY4" }

  describe ".place" do
    context "when the API returns OK" do
      before do
        stub_request(:get, GoogleApiCustomization::Request::PLACES_URL)
          .with(query: hash_including({}))
          .to_return(
            status: 200,
            body: { "status" => "OK", "result" => {} }.to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "returns the parsed response" do
        result = described_class.place(placeid: place_id, key: api_key, sensor: false)
        expect(result["status"]).to eq("OK")
      end
    end

    context "when the API returns ZERO_RESULTS" do
      before do
        stub_request(:get, GoogleApiCustomization::Request::PLACES_URL)
          .with(query: hash_including({}))
          .to_return(
            status: 200,
            body: { "status" => "ZERO_RESULTS", "results" => [] }.to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "returns the parsed response without raising" do
        result = described_class.place(placeid: place_id, key: api_key, sensor: false)
        expect(result["status"]).to eq("ZERO_RESULTS")
      end
    end

    context "when the API returns OVER_QUERY_LIMIT" do
      before do
        stub_request(:get, GoogleApiCustomization::Request::PLACES_URL)
          .with(query: hash_including({}))
          .to_return(
            status: 200,
            body: { "status" => "OVER_QUERY_LIMIT" }.to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "raises OverQueryLimitError" do
        expect {
          described_class.place(placeid: place_id, key: api_key, sensor: false)
        }.to raise_error(GoogleApiCustomization::OverQueryLimitError)
      end
    end

    context "when the API returns REQUEST_DENIED" do
      before do
        stub_request(:get, GoogleApiCustomization::Request::PLACES_URL)
          .with(query: hash_including({}))
          .to_return(
            status: 200,
            body: { "status" => "REQUEST_DENIED" }.to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "raises RequestDeniedError" do
        expect {
          described_class.place(placeid: place_id, key: api_key, sensor: false)
        }.to raise_error(GoogleApiCustomization::RequestDeniedError)
      end
    end

    context "when the API returns NOT_FOUND" do
      before do
        stub_request(:get, GoogleApiCustomization::Request::PLACES_URL)
          .with(query: hash_including({}))
          .to_return(
            status: 200,
            body: { "status" => "NOT_FOUND" }.to_json,
            headers: { "Content-Type" => "application/json" }
          )
      end

      it "raises NotFoundError" do
        expect {
          described_class.place(placeid: place_id, key: api_key, sensor: false)
        }.to raise_error(GoogleApiCustomization::NotFoundError)
      end
    end
  end

  describe "RADAR_SEARCH_URL constant" do
    it "is defined only once (no duplicate constant warning)" do
      constants = described_class.constants.select { |c| c == :RADAR_SEARCH_URL }
      expect(constants.length).to eq(1)
    end
  end

  describe ".nearby_search" do
    before do
      stub_request(:get, GoogleApiCustomization::Request::NEARBY_SEARCH_URL)
        .with(query: hash_including({}))
        .to_return(
          status: 200,
          body: { "status" => "OK", "results" => [] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "makes a request to NEARBY_SEARCH_URL and returns the parsed response" do
      result = described_class.nearby_search(location: "37.7749,-122.4194", radius: 500, key: api_key, sensor: false)
      expect(result["status"]).to eq("OK")
    end
  end

  describe ".text_search" do
    before do
      stub_request(:get, GoogleApiCustomization::Request::TEXT_SEARCH_URL)
        .with(query: hash_including({}))
        .to_return(
          status: 200,
          body: { "status" => "OK", "results" => [] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "makes a request to TEXT_SEARCH_URL and returns the parsed response" do
      result = described_class.text_search(query: "restaurants in Sydney", key: api_key, sensor: false)
      expect(result["status"]).to eq("OK")
    end
  end

  describe ".autocomplete" do
    before do
      stub_request(:get, GoogleApiCustomization::Request::AUTOCOMPLETE_URL)
        .with(query: hash_including({}))
        .to_return(
          status: 200,
          body: { "status" => "OK", "predictions" => [] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "makes a request to AUTOCOMPLETE_URL and returns the parsed response" do
      result = described_class.autocomplete(input: "Sydney", key: api_key, sensor: false)
      expect(result["status"]).to eq("OK")
    end
  end
end
