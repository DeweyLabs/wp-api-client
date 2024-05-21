module WpApiClient
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset
    @configuration = Configuration.new
  end

  class Configuration
    attr_accessor :endpoint
    attr_accessor :embed
    attr_accessor :oauth_credentials
    attr_accessor :debug
    attr_accessor :cache
    attr_reader :basic_auth
    attr_accessor :proxy

    def initialize
      @endpoint = "http://localhost:8080/wp-json/wp/v2"
      @embed = true
    end

    def basic_auth=(hash)
      @basic_auth = if hash.nil?
        nil
      else
        # Symbolizes one level of keys
        hash.each_with_object({}) do |(key, value), result|
          symbol_key = key.to_sym
          result[symbol_key] = value
        end
      end
    end

    def define_mapping(relation, type)
      WpApiClient::Relationship.define(relation, type)
    end

    def request_params
      params = {}
      if @embed
        params[:_embed] = true
      end
      params
    end
  end
end
