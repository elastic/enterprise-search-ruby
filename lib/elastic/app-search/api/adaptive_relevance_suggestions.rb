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
        # AdaptiveRelevanceSuggestions - Retrieve adaptive relevance
        # Retrieve adaptive relevance for a single query
        #
        # @param engine_name [String] Name of the engine (*Required*)
        # @param arguments [Hash] endpoint arguments
        # @option arguments [String] :search_suggestion_query Query to obtain suggestions (*Required*)
        # @option arguments [Hash] :body
        # @option body :page
        # @option body :filters
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/app-search/current/adaptive-relevance-api-reference.html#adaptive-relevance-api-get-engine-adaptive-relevance-suggestions-query
        #
        def adaptive_relevance_suggestions(engine_name, arguments = {})
          raise ArgumentError, "Required parameter 'engine_name' missing" unless engine_name
          raise ArgumentError, "Required parameter 'search_suggestion_query' missing" unless arguments[:search_suggestion_query]

          search_suggestion_query = arguments[:search_suggestion_query]
          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}

          request(
            :post,
            "api/as/v0/engines/#{engine_name}/adaptive_relevance/suggestions/#{search_suggestion_query}/",
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
