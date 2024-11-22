RSpec.describe WpApiClient::Connection do
  # describe "fetching posts concurrently", vcr: {cassette_name: "concurrency", record: :new_episodes} do
  #   it "allows simultaneous fetching of posts" do
  #     pending "parallel faraday adapter to replace typhoeus"
  #     resp = @api.concurrently do |api|
  #       api.get("posts/1")
  #       api.get("posts", page: 2)
  #     end
  #     expect(resp.first.title).to eq "Hello world!"
  #     expect(resp.last.first.title).to eq "Post 90"
  #   end
  # end

  describe "handling HTTP errors", vcr: false do
    let(:configuration) do
      config = WpApiClient::Configuration.new
      config.endpoint = "https://example.com/wp-json/wp/v2"
      config
    end
    let(:connection) { described_class.new(configuration) }

    context "when following redirects" do
      before do
        stub_request(:get, "https://example.com/wp-json/wp/v2/posts")
          .with(query: {"_embed" => "true"})
          .to_return(
            status: 301,
            headers: {"Location" => "https://new-example.com/wp-json/wp/v2/posts?_embed=true"}
          )
      end

      it "raises an error" do
        expect {
          connection.get("posts")
        }.to raise_error(Faraday::FollowRedirects::RedirectLimitReached)
      end
    end

    context "when receiving other connection errors" do
      before do
        stub_request(:get, "https://example.com/wp-json/wp/v2/posts")
          .with(query: {"_embed" => "true"})
          .to_return(status: 502)
      end

      it "raises a connection error with status information" do
        expect {
          connection.get("posts")
        }.to raise_error(Faraday::ServerError) do |error|
          expect(error.response[:status]).to eq(502)
        end
      end
    end
  end
end
