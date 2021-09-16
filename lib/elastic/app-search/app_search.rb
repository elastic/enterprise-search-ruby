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

require 'jwt'

module Elastic
  module EnterpriseSearch
    # App Search client for Enterprise Search.
    #
    # @see https://www.elastic.co/guide/en/app-search/current/index.html
    module AppSearch
      # The App Search Client
      # Extends EnterpriseSearch client but overrides authentication to use access token.
      class Client < Elastic::EnterpriseSearch::Client
        include Elastic::EnterpriseSearch::AppSearch::Actions

        # Create a new Elastic::EnterpriseSearch::AppSearch::Client client
        #
        # @param options [Hash] a hash of configuration options
        # @option options [String] :host_identifier A unique string that represents your account.
        # @option options [String] :api_key Part of the credentials
        def initialize(options = {})
          super(options)
        end

        SIGNED_KEY_ALGORITHM = 'HS256'

        class << self
          # Build a JWT for authentication
          #
          # @param [String] api_key the API Key to sign the request with
          # @param [String] api_key_name the unique name for the API Key
          # @option options see the {App Search API}[https://www.elastic.co/guide/en/app-search/current/authentication.html#authentication-signed] for supported search options.
          #
          # @return [String] the JWT to use for authentication
          def create_signed_search_key(api_key, api_key_name, options = {})
            payload = Elastic::EnterpriseSearch::Utils.symbolize_keys(options).merge(api_key_name: api_key_name)
            JWT.encode(payload, api_key, SIGNED_KEY_ALGORITHM)
          end
        end

        def http_auth
          @options[:http_auth]
        end

        def http_auth=(api_key)
          @options[:http_auth] = api_key
        end

        def date_to_rfc3339(date)
          DateTime.parse(date.to_s).rfc3339
        end
      end
    end
  end
end
