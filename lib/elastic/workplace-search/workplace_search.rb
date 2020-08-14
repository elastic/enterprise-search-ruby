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
        def setup_authentication_header(req)
          req['Authorization'] = "Bearer #{access_token}"
          req
        end
      end

      # The Workplace Search Client
      # Extends EnterpriseSearch client but overrides authentication to use access token.
      class Client < Elastic::EnterpriseSearch::Client
        include Elastic::EnterpriseSearch::WorkplaceSearch::Actions
        include Elastic::EnterpriseSearch::WorkplaceSearch::Request
        include Elastic::EnterpriseSearch::Utils

        # Crete a new Elastic::EnterpriseSearch::WorkplaceSearch::Client client
        #
        # @param options [Hash] a hash of configuration options
        # @option options [String] :access_token the access token for workplace search
        # @option options [String] :endpoint the endpoint Workplace Search
        def initialize(options = {})
          @options = options
          @access_token = options.dig(:access_token)
        end

        attr_accessor :access_token
      end
    end
  end
end
