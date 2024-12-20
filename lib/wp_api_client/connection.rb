require "faraday"
require "faraday-http-cache"
require "faraday/follow_redirects"

module WpApiClient
  class Connection
    attr_accessor :headers
    attr_reader :concurrent

    def initialize(configuration)
      @configuration = configuration
      @queue = []
      @conn = Faraday.new(url: configuration.endpoint) do |f|
        # Disabled OAuth for now since Faraday Middleware is deprecated
        # if configuration.oauth_credentials
        #   f.use FaradayMiddleware::OAuth, configuration.oauth_credentials
        # end

        if configuration.basic_auth
          f.request :authorization, :basic, configuration.basic_auth[:username], configuration.basic_auth[:password]
        end

        if configuration.debug
          f.response :logger
          f.use :instrumentation
        end

        if configuration.cache
          f.use :http_cache, store: configuration.cache, shared_cache: false
        end

        if configuration.proxy
          f.proxy configuration.proxy
        end

        f.use Faraday::Response::RaiseError
        f.response :raise_error
        f.response :json, content_type: /\bjson$/
        f.response :follow_redirects, limit: 0
      end
    end

    # translate requests into wp-api urls
    def get(url, params = {})
      @conn.get url, parse_params(params)
    end

    # requests come in as url/params pairs
    def get_concurrently(requests)
      responses = []
      @conn.in_parallel do
        requests.map do |r|
          responses << get(r[0], r[1])
        end
      end
      responses
    end

    private

    def parse_params(params)
      params = @configuration.request_params.merge(params)
      # if _embed is present at all it will have the effect of embedding —
      # even if it's set to "false"
      if params[:_embed] == false
        params.delete(:_embed)
      end
      params
    end
  end
end
