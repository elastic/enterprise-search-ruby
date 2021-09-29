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
        # ContentSources - Create a content source
        # Create a custom content source
        #
        # @param arguments [Hash] endpoint arguments
        # @option arguments [Hash] :body Definition to create a Workplace Search Content Source (Required: name)
        # @option body [String] :name The human readable display name for this Content Source. (*Required)
        # @option body :schema The schema that each document in this Content Source will adhere to.
        # @option body :display The display details which governs which fields will be displayed, and in what order, in the search results.
        # @option body [Boolean] :is_searchable Whether or not this Content Source will be searchable on the search page.
        # @option body :indexing
        # @option body :facets
        # @option body :automatic_query_refinement
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/workplace-search/current/workplace-search-content-sources-api.html#create-content-source-api
        #
        def create_content_source(arguments = {})
          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}

          request(
            :post,
            'api/ws/v1/sources/',
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
