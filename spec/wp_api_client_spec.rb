describe WpApiClient do
  it "has a version number" do
    expect(WpApiClient::VERSION).not_to be nil
  end

  describe WpApiClient::Instance do
    it "creates isolated instances" do
      instance_a = WpApiClient::Instance.new
      instance_b = WpApiClient::Instance.new

      base_uri_a = "https://www.first_wordpress.org/wp-json/wp/v2"
      base_uri_b = "https://www.second_wordpress.org/wp-json/wp/v2"

      instance_a.configure do |config|
        config.endpoint = base_uri_a
        config.basic_auth = {username: "user_a", password: "pass_a"}
      end

      instance_b.configure do |config|
        config.endpoint = base_uri_b
        config.basic_auth = {username: "user_b", password: "pass_b"}
      end

      client_a = instance_a.client
      client_b = instance_b.client

      endpoint_a = client_a.configuration.endpoint
      endpoint_b = client_b.configuration.endpoint

      expect(endpoint_a).to eq(base_uri_a)
      expect(endpoint_b).to eq(base_uri_b)
    end
  end
end
