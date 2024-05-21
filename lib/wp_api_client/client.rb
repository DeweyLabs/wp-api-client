module WpApiClient
  class Client
    attr_reader :connection, :client_instance

    def initialize(connection, client_instance)
      @connection = connection
      @client_instance = client_instance
    end

    def get(url, params = {})
      if @concurrent_client
        @concurrent_client.get(api_path_from(url), params)
      else
        response = @connection.get(api_path_from(url), params)
        @headers = response.headers
        native_representation_of response.body
      end
    end

    def concurrently
      @concurrent_client ||= ConcurrentClient.new(@connection, client_instance)
      yield @concurrent_client
      result = @concurrent_client.run
      @concurrent_client = nil
      result
    end

    def configuration
      client_instance.configuration
    end

    private

    def api_path_from(url)
      url.split("wp/v2/").last
    end

    #  Take the API response and figure out what it is
    def native_representation_of(response_body)
      # Do we have a collection of objects?
      if response_body.is_a? Array
        WpApiClient::Collection.new(response_body, @headers, client_instance)
      else
        WpApiClient::Entities::Base.build(response_body, client_instance)
      end
    end
  end

  class Instance
    attr_reader :configuration

    def initialize
      @configuration = Configuration.new
    end

    def configure
      yield(@configuration)
    end

    def client
      @client ||= Client.new(Connection.new(@configuration), self)
    end
  end
end
