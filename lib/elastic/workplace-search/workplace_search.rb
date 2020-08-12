# frozen_string_literal: true

module Elastic
  module EnterpriseSearch
    # Workplace Search client for Enterprise Search.
    module WorkplaceSearch
      # The Request module is included in the WorkplaceSearch Client to override
      # EnterpriseSearch client's authentication method with Workplace's
      # authentication.
      module Request
        def setup_authentication_header(req)
          req['Authorization'] = "Bearer #{access_token}"
          req
        end
      end

      class Client < Elastic::EnterpriseSearch::Client
        # Extends EnterpriseSearch client but overrides authentication to use
        # access token.
        DEFAULT_ENDPOINT = 'http://localhost:8080/'

        include Elastic::EnterpriseSearch::WorkplaceSearch::Actions
        include Elastic::EnterpriseSearch::WorkplaceSearch::Request

        # TODO: Refactor this into Utils
        def endpoint=(endpoint)
          @options[:endpoint] = if endpoint.end_with?('/')
                                  endpoint
                                else
                                  "#{endpoint}/"
                                end
        end

        # Crete a new Elastic::EnterpriseSearch::WorkplaceSearch::Client client
        #
        # @param options [Hash] a hash of configuration options
        # @option options [String] :access_token the access token for workplace search
        # @option options [String] :endpoint the endpoint Workplace Search
        def initialize(options = {})
          @options = options
          @access_token = options.dig(:access_token)
        end

        def endpoint
          @options[:endpoint] || DEFAULT_ENDPOINT
        end

        attr_accessor :access_token
      end
    end
  end
end
