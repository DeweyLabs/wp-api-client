module WpApiClient
  module Utils
    def self.deep_symbolize(obj)
      case obj
      when Hash
        obj.each_with_object({}) { |(k, v), memo| memo[k.to_sym] = deep_symbolize(v) }
      when Array
        obj.map { |v| deep_symbolize(v) }
      else
        obj
      end
    end
  end
end
