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
    # App Search client for Enterprise Search.
    #
    # @see https://www.elastic.co/guide/en/app-search/current/index.html
    module AppSearch
      # The Request module is included in the AppSearch Client to override
      # EnterpriseSearch client's authentication method with App's
      # authentication.
      module Request
        def setup_authentication_header
          "Bearer #{http_auth}"
        end
      end

      # The App Search Client
      # Extends EnterpriseSearch client but overrides authentication to use access token.
      class Client < Elastic::EnterpriseSearch::Client
        include Elastic::EnterpriseSearch::AppSearch::Actions
        include Elastic::EnterpriseSearch::AppSearch::Request
        include Elastic::EnterpriseSearch::Utils

        # Crete a new Elastic::EnterpriseSearch::AppSearch::Client client
        #
        # @param options [Hash] a hash of configuration options
        # @option options [String] :host_identifier A unique string that represents your account.
        # @option options [String] :api_key Part of the credentials
        def initialize(options = {})
          super(options)
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
