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
        # ContentSources - Update a content source
        # Update a content source
        #
        # @param [String] content_source_id Unique ID for a Custom API source, provided upon creation of a Custom API Source (*Required*)
        # @param [Hash] arguments endpoint arguments
        # @option arguments [Hash] :body (Required: name, is_searchable)
        # @option body [string] :name The human readable display name for this Content Source.
        # @option body :schema The schema that each document in this Content Source will adhere to.
        # @option body :display The display details which governs which fields will be displayed, and in what order, in the search results.
        # @option body [boolean] :is_searchable Whether or not this Content Source will be searchable on the search page.
        # @option body :indexing
        # @option body :facets
        # @option body :automatic_query_refinement
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/workplace-search/current/workplace-search-content-sources-api.html#update-content-source-api
        #
        def put_content_source(content_source_id, arguments = {})
          raise ArgumentError, "Required parameter 'content_source_id' missing" unless content_source_id
          raise ArgumentError, "Required parameter 'body (name,is_searchable)' missing" unless arguments[:body]

          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}
          request(
            :put,
            "api/ws/v1/sources/#{content_source_id}/",
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
