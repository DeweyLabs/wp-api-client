module WpApiClient
  module Entities
    class Error
      def initialize(json)
        raise WpApiClient::ErrorResponse.new(json)
      end

      def self.represents?(json)
        json.key?("code") and json.key?("message")
      end
    end
  end
end
