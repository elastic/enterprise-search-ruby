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
        # Search - search across available sources with various query tuning options
        # Issue a Search Query
        #
        # @param query [String] A string or number used to find related documents
        # @param automatic_query_refinement [Boolean] set to false to not automatically refine the query by keywords
        # @param page [Object] paging controls for the result set
        # @param search_fields [Object] restrict the fulltext search to only specific fields
        # @param result_fields [Object] restrict the result fields for each item to the specified fields
        # @param filters []
        # @param sort []
        # @param facets [Object]
        # @param boosts [Object]
        #
        # @see https://www.elastic.co/guide/en/workplace-search/current/workplace-search-search-api.html
        #
        def search(parameters = {})
          request(
            :post,
            '/api/ws/v1/search',
            parameters
          )
        end
      end
    end
  end
end
