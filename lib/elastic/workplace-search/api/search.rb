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
    module WorkplaceSearch
      module Actions
        # Search - Search across available sources with various query tuning options
        # Issue a Search Query
        #
        # @param [Hash] arguments endpoint arguments
        # @param [String] access_token OAuth Access Token (*Required*)
        # @option arguments [Hash] :body *Required*
        # @option body [string] :query A string or number used to find related documents
        # @option body [boolean] :automatic_query_refinement Set to false to not automatically refine the query by keywords
        # @option body [Hash] :page Paging controls for the result set
        # @option body [Hash] :search_fields Restrict the fulltext search to only specific fields
        # @option body [Hash] :result_fields Restrict the result fields for each item to the specified fields
        # @option body :filters
        # @option body :sort
        # @option body [Hash] :facets
        # @option body [Hash] :boosts
        # @option body :source_type Optional parameter to search standard, remote only, or all available sources
        # @option body [integer] :timeout Optional timeout in ms for searching remote sources
        # @option body [Array<string>] :content_sources Optional list of content source ids to only return results from
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/workplace-search/current/workplace-search-search-api.html
        #
        def search(arguments = {})
          raise ArgumentError, "Required parameter 'access_token' missing" unless arguments[:access_token]
          raise ArgumentError, "Required parameter 'body' missing" unless arguments[:body]

          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}
          request(
            :post,
            'api/ws/v1/search/',
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
