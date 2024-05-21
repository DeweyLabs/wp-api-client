require "webmock/rspec"

RSpec.describe WpApiClient::Configuration do
  let(:instance) { WpApiClient::Instance.new }

  describe "#configure" do
    it "can set the endpoint URL for the API connection" do
      VCR.turned_off do
        imaginary_api_location = "http://example.com/wp-json/wp/v2"

        # get an example API response and mock it

        ::WebMock.stub_request(:get,
          imaginary_api_location + "/custom_post_type?_embed=true").to_return(
            body: example_response,
            headers: {"Content-Type" => "application/json"}
          )

        # Configure the API client to point somewhere else
        instance.configure do |api_client|
          api_client.endpoint = imaginary_api_location
        end
        instance.client.get("custom_post_type")
      end
    end

    it "can specify whether or not to request embedded resources" do
      VCR.turned_off do
        instance.configure do |api_client|
          api_client.embed = false
        end

        # get an example API response and mock it
        ::WebMock.stub_request(:get,
          instance.configuration.endpoint + "/posts/1").to_return(
            body: example_response,
            headers: {"Content-Type" => "application/json"}
          )

        instance.client.get("posts/1")
      end
    end

    it "can set up basic auth credentials", vcr: {cassette_name: :basic_auth} do
      instance.configure do |api_client|
        api_client.basic_auth = {username: "foo", password: "bar"}
      end

      expect {
        instance.client.get("posts/1")
      }.not_to raise_error
    end

    it "ensures that basic auth credentials are symbolized", vcr: {cassette_name: :basic_auth} do
      instance.configure do |api_client|
        api_client.basic_auth = {"username" => "foo", "password" => "bar"}
      end

      expect_any_instance_of(Faraday::Connection).to receive(:request).with(:authorization, :basic, "foo", "bar")

      expect {
        instance.client.get("posts/1")
      }.not_to raise_error
    end

    it "can set up OAuth credentials", vcr: {cassette_name: :oauth_test} do
      oauth_credentials = get_test_oauth_credentials

      instance.configure do |api_client|
        api_client.oauth_credentials = oauth_credentials
      end

      instance.client.get("posts/1")
    end

    it "can set up link relationships", vcr: {cassette_name: :single_post} do
      instance.configure do |api_client|
        api_client.define_mapping("http://my.own/mapping", :post)
      end

      post = instance.client.get("posts/1")
      expect { post.relations("http://my.own/mapping") }.not_to raise_error
    end

    it "exposes a #proxy configuration option" do
      instance.configure do |api_client|
        api_client.proxy = "http://localhost:8080"
      end

      expect(instance.configuration.proxy).to eq "http://localhost:8080"
    end
  end

  private

  def example_response
    YAML.load_file(WPAPICLIENT_VCR_PATH + "/custom_post_type_collection.yml")["http_interactions"][0]["response"]["body"]["string"]
  end
end
