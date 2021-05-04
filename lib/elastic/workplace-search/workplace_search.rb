# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# frozen_string_literal: true

module Elastic
  module EnterpriseSearch
    # Workplace Search client for Enterprise Search.
    module WorkplaceSearch
      # The Request module is included in the WorkplaceSearch Client to override
      # EnterpriseSearch client's authentication method with Workplace's
      # authentication.
      module Request
        def setup_authentication_header
          case http_auth
          when Hash
            basic_auth_header
          when String
            "Bearer #{http_auth}"
          end
        end
      end

      # The Workplace Search Client
      # Extends EnterpriseSearch client but overrides authentication to use access token.
      class Client < Elastic::EnterpriseSearch::Client
        include Elastic::EnterpriseSearch::WorkplaceSearch::Actions
        include Elastic::EnterpriseSearch::WorkplaceSearch::Request
        include Elastic::EnterpriseSearch::Utils

        # Create a new Elastic::EnterpriseSearch::WorkplaceSearch::Client client
        #
        # @param options [Hash] a hash of configuration options
        # @option options [String] :access_token the access token for workplace search
        # @option options [String] :endpoint the endpoint Workplace Search
        def initialize(options = {})
          super(options)
        end

        def http_auth
          @options[:http_auth]
        end

        def http_auth=(access_token)
          @options[:http_auth] = access_token
        end

        def authorization_url(client_id, redirect_uri)
          [
            host,
            '/ws/oauth/authorize?',
            'response_type=code&',
            "client_id=#{client_id}&",
            "redirect_uri=#{CGI.escape(redirect_uri)}"
          ].join
        end

        def request_access_token(client_id, client_secret, authorization_code, redirect_uri)
          response = request(
            :post,
            '/ws/oauth/token',
            {
              grant_type: 'authorization_code',
              client_id: client_id,
              client_secret: client_secret,
              redirect_uri: redirect_uri,
              code: authorization_code
            }
          )
          response.body['access_token']
        end
      end
    end
  end
end
