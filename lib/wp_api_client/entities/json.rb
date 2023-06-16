module WpApiClient
  module Entities
    class Json < Base
      alias :json :resource

      def self.represents?(json)
        json.is_a? Hash
      end
    end
  end
end