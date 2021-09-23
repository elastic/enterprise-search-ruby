# frozen_string_literal: true

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

module Elastic
  module EnterpriseSearch
    module AppSearch
      module Actions
        # Click - Tracks results that were clicked after a query
        # Tracks results that were clicked after a query
        #
        # @param engine_name [String] Name of the engine (*Required*)
        # @param arguments [Hash] endpoint arguments
        # @option arguments :body Search request parameters
        # @option body [String] :query Search query text (*Required*)
        # @option body [String] :document_id The id of the document that was clicked on (*Required*)
        # @option body [String] :request_id The request id returned in the meta tag of a search API response
        # @option body [Array] :tags Array of strings representing additional information you wish to track with the clickthrough. You may submit up to 16 tags, and each may be up to 64 characters in length.
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/app-search/current/clickthrough.html
        #
        def log_clickthrough(engine_name, arguments = {})
          raise ArgumentError, "Required parameter 'engine_name' missing" unless engine_name

          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}

          request(
            :post,
            "api/as/v1/engines/#{engine_name}/click/",
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
