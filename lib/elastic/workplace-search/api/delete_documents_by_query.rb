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
        # Documents - Deletes documents by query in a custom content source
        # Deletes documents by query in a custom content source
        #
        # @param [String] content_source_id Unique ID for a Custom API source, provided upon creation of a Custom API Source (*Required*)
        # @param [Hash] arguments endpoint arguments
        # @option arguments [Hash] :body
        # @option body [Hash] :filters
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/workplace-search/current/workplace-search-custom-sources-api.html#delete-documents-by-query
        #
        def delete_documents_by_query(content_source_id, arguments = {})
          raise ArgumentError, "Required parameter 'content_source_id' missing" unless content_source_id

          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}
          request(
            :delete,
            "api/ws/v1/sources/#{content_source_id}/documents/",
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
