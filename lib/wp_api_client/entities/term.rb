module WpApiClient
  module Entities
    class Term < Base
      alias_method :term, :resource

      def self.represents?(json)
        json.dig("_links", "about") and json["_links"]["about"].first["href"] =~ /wp\/v2\/taxonomies/
      end

      def taxonomy
        client_instance.client.get(links["about"].first["href"])
      end

      def posts(post_type = nil)
        relations("http://api.w.org/v2/post_type", post_type)
      end
    end
  end
end
