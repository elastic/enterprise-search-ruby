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
        # ExternalIdentities - Adds a new external identity
        # Adds a new external identity
        #
        # @param [String] content_source_id Unique ID for a Custom API source, provided upon creation of a Custom API Source (*Required*)
        # @param [Hash] arguments endpoint arguments
        # @option arguments [Hash] :body (Required: external_user_id, external_user_properties, permissions)
        # @option body [string] :external_user_id
        # @option body [Array<object>] :external_user_properties A list of external user properties, where each property is an object with an attribute_name and attribute_value.
        # @option body [Array<string>] :permissions A list of user permissions.
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/workplace-search/current/workplace-search-external-identities-api.html#add-external-identity
        #
        def create_external_identity(content_source_id, arguments = {})
          raise ArgumentError, "Required parameter 'content_source_id' missing" unless content_source_id

          unless arguments[:body]
            raise ArgumentError,
                  "Required parameter 'body (external_user_id,external_user_properties,permissions)' missing"
          end

          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}
          request(
            :post,
            "api/ws/v1/sources/#{content_source_id}/external_identities/",
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
