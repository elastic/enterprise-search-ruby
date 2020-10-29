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
        # Click - Send data about clicked results
        #
        # @param engine_name [String]  (*Required*)
        # @param arguments [Hash] endpoint arguments
        # @option query_text [String] Search query text (*Required*)
        # @option document_id [] The ID of the document that was clicked on (*Required*)
        # @option request_id [String] The request ID returned in the meta tag of a search API response
        # @option tags [Array] Array of strings representing additional information you wish to track with the clickthrough
        # @option body - The request body
        #
        #
        # @see https://www.elastic.co/guide/en/app-search/current/clickthrough.html
        #
        def log_clickthrough(engine_name, arguments = {})
          raise ArgumentError, "Required parameter 'query_text' missing" unless arguments[:query_text]
          raise ArgumentError, "Required parameter 'document_id' missing" unless arguments[:document_id]
          raise ArgumentError, "Required parameter 'engine_name' missing" unless engine_name

          body = arguments.delete(:body) || {}

          request(
            :post,
            "api/as/v1/engines/#{engine_name}/click/",
            arguments,
            body
          )
        end
      end
    end
  end
end
