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
        # ContentSources - Retrieves all content sources
        # Retrieves all content sources
        #
        # @param [Hash] arguments endpoint arguments
        # @option arguments [Integer] :current_page Which page of results to request
        # @option arguments [Integer] :page_size The number of results to return in a page
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/workplace-search/current/workplace-search-content-sources-api.html#list-content-sources-api
        #
        def list_content_sources(arguments = {})
          headers = arguments.delete(:headers) || {}
          request(
            :get,
            'api/ws/v1/sources/',
            arguments,
            nil,
            headers
          )
        end
      end
    end
  end
end
