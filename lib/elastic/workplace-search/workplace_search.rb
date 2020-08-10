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
        DEFAULT_ENDPOINT = 'http://localhost:8080/'.freeze

        LOAD_PATH = File.dirname(__FILE__) + '/api/*.rb'
        Dir[LOAD_PATH].sort.each do |file|
          require file
        end
        include Elastic::EnterpriseSearch::WorkplaceSearch::Actions
        include Elastic::EnterpriseSearch::WorkplaceSearch::Request

        # TODO: Refactor this into Utils
        def endpoint=(endpoint)
          @endpoint = if endpoint.end_with?('/')
                        endpoint
                      else
                        "#{endpoint}/"
                      end
        end

        def initialize(access_token = nil, endpoint = nil)
          @access_token = access_token
          @endpoint = endpoint || DEFAULT_ENDPOINT
        end

        attr_accessor :access_token
      end
    end
  end
end
