require "open-uri"
require "ostruct"

module WpApiClient
  module Entities
    class Base
      attr_reader :resource, :client_instance

      def self.build(resource, client_instance)
        raise StandardError.new("Resource is nil") if resource.nil?
        type = WpApiClient::Entities::Types.find { |type| type.represents?(resource) }
        type.new(resource, client_instance)
      end

      def initialize(resource, client_instance)
        unless resource.is_a? Hash or resource.is_a? OpenStruct
          raise ArgumentError.new("Tried to initialize a WP-API resource with something other than a Hash")
        end
        @resource = OpenStruct.new(resource)
        @client_instance = client_instance
      end

      def links
        resource["_links"]
      end

      def relations(relation, relation_to_return = nil)
        relationship = Relationship.new(@resource, relation)
        relations = relationship.get_relations(client_instance)
        if relation_to_return
          relations[relation_to_return]
        else
          relations
        end
      end

      def method_missing(method, *)
        @resource.send(method, *)
      end

      def respond_to_missing?(method, include_private = false)
        @resource.respond_to?(method, include_private) || super
      end
    end
  end
end
