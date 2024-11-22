module WpApiClient
  module Entities
    class User < Base
      alias_method :user, :resource

      def self.represents?(json)
        json.dig("_links", "collection") and json["_links"]["collection"].first["href"] =~ /wp\/v2\/users/
      end
    end
  end
end
