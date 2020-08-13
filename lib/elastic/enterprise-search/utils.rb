# frozen_string_literal: true

module Elastic
  module EnterpriseSearch
    # Util functions
    module Utils
      DEFAULT_ENDPOINT = 'http://localhost:8080/'

      def stringify_keys(hash)
        output = {}
        hash.each do |key, value|
          output[key.to_s] = value
        end
        output
      end

      def endpoint=(endpoint)
        @options[:endpoint] = if endpoint.end_with?('/')
                                endpoint
                              else
                                "#{endpoint}/"
                              end
      end
    end
  end
end
