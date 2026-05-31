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
end
