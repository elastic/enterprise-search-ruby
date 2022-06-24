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
      # Generated from build hash 835a1a87f357f7b7cfd3453b5c5a937c47995772
      module Actions
        # Synonyms - Create a batch of synonym sets
        # Create batched synonym sets
        #
        # @param [Hash] arguments endpoint arguments
        # @option arguments [Hash] :body *Required*
        # @option body :synonyms
        # @option body :synonym_sets
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/workplace-search/current/workplace-synonyms-api.html#create-synonyms
        #
        def create_batch_synonym_sets(arguments = {})
          raise ArgumentError, "Required parameter 'body' missing" unless arguments[:body]

          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}
          request(
            :post,
            'api/ws/v1/synonyms/',
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
