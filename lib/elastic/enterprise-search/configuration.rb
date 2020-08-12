# frozen_string_literal: true

require 'uri'
require 'elastic/workplace-search/version'

module Elastic
  module EnterpriseSearch
    # Configuratin module
    module Configuration
      # TODO: Endpoint for EE
      # DEFAULT_ENDPOINT = 'http://localhost:3002/api/ws/v1/'

      VALID_OPTIONS_KEYS = [:access_token, :endpoint].freeze

      attr_accessor(*VALID_OPTIONS_KEYS)

      def self.extended(base)
        base.reset
      end

      # Reset configuration to default values.
      def reset
        self.access_token = nil
        self.endpoint = DEFAULT_ENDPOINT
        self
      end

      # Yields the Elastic::WorkplaceSearch::Configuration module which can be used to set configuration options.
      #
      # @return self
      def configure
        yield self
        self
      end

      # Return a hash of the configured options.
      def options
        options = {}
        VALID_OPTIONS_KEYS.each { |k| options[k] = send(k) }
        options
      end

      # setter for endpoint that ensures it always ends in '/'
      def endpoint=(endpoint)
        @endpoint = if endpoint.end_with?('/')
                      endpoint
                    else
                      "#{endpoint}/"
                    end
      end
    end
  end
end
