require "spec_helper"

RSpec.describe GoogleApiCustomization::Review do
  subject(:review) do
    described_class.new(4, "overall", "Alice", "http://example.com", "Great place!", 1_700_000_000)
  end

  it "stores all attributes" do
    expect(review.rating).to eq(4)
    expect(review.type).to eq("overall")
    expect(review.author_name).to eq("Alice")
    expect(review.author_url).to eq("http://example.com")
    expect(review.text).to eq("Great place!")
    expect(review.time).to eq(1_700_000_000)
  end
end
