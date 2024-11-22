RSpec.describe WpApiClient::Entities::Error do
  let(:error_json) { {"code" => "rest_forbidden", "message" => "You don't have permission to do this.", "data" => {"status" => 403}} }

  describe "an API access error", vcr: {cassette_name: "single_post"} do
    it "throws an exception" do
      expect {
        WpApiClient::Entities::Error.new(error_json)
      }.to raise_error(WpApiClient::ErrorResponse)
    end

    it "recognises the error JSON exception" do
      expect(WpApiClient::Entities::Error.represents?(error_json)).to be_truthy
    end
  end
end
