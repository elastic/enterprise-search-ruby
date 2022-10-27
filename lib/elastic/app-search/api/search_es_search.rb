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
        # ElasticsearchSearch - Run a search
        # Execute the provided Elasticsearch search query against an App Search Engine
        #
        # @param [String] engine_name Name of the engine (*Required*)
        # @param [Hash] arguments endpoint arguments
        # @option arguments [Hash] :body Query parameters to be passed to Elasticsearch _search API
        # @option arguments [Object] :es_search_query_params Query parameters to be passed to Elasticsearch _search API
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        # @option headers [String] :X-Enterprise-Search-Analytics The search query associated with this request when recording search analytics
        # @option headers [String] :X-Enterprise-Search-Analytics-Tags Analytics tags to be applied with this search request
        #
        # @see https://www.elastic.co/guide/en/app-search/current/elasticsearch-search-api-reference.html
        #
        def search_es_search(engine_name, arguments = {})
          raise ArgumentError, "Required parameter 'engine_name' missing" unless engine_name

          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}
          request(
            :post,
            "api/as/v1/engines/#{engine_name}/elasticsearch/_search/",
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
