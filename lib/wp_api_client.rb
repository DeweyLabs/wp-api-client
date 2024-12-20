require "ostruct"

require "wp_api_client/version"
require "wp_api_client/configuration"

require "wp_api_client/entities/base"

require "wp_api_client/entities/user"
require "wp_api_client/entities/post"
require "wp_api_client/entities/meta"
require "wp_api_client/entities/taxonomy"
require "wp_api_client/entities/term"
require "wp_api_client/entities/image"
require "wp_api_client/entities/error"
require "wp_api_client/entities/json"
require "wp_api_client/entities/types"

require "wp_api_client/client"
require "wp_api_client/concurrent_client"
require "wp_api_client/connection"
require "wp_api_client/collection"
require "wp_api_client/relationship"
require "wp_api_client/utils"

module WpApiClient
  class RelationNotDefined < StandardError; end

  class ErrorResponse < StandardError
    attr_reader :error
    attr_reader :status
    attr_reader :data

    def initialize(json)
      error_data = WpApiClient::Utils.deep_symbolize(json)
      @error = OpenStruct.new(error_data)
      @status = @error.data[:status]
      super(@error.message)
    end
  end
end
