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
        # ExternalIdentities - Updates an external identity
        # Updates an external identity
        #
        # @param [String] content_source_id Unique ID for a Custom API source, provided upon creation of a Custom API Source (*Required*)
        # @param [Hash] arguments endpoint arguments
        # @option arguments [String] :external_user_id Unique identifier of an external user, such as username or email address. (*Required*)
        # @option arguments [Hash] :body (Required: external_user_id)
        # @option body [string] :external_user_id
        # @option body [["array", "null"]] :external_user_properties A list of external user properties, where each property is an object with an attribute_name and attribute_value.
        # @option body [["array", "null"]] :permissions A list of user permissions.
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/workplace-search/current/workplace-search-external-identities-api.html#update-external-identity
        #
        def put_external_identity(content_source_id, arguments = {})
          raise ArgumentError, "Required parameter 'content_source_id' missing" unless content_source_id
          raise ArgumentError, "Required parameter 'external_user_id' missing" unless arguments[:external_user_id]
          raise ArgumentError, "Required parameter 'body (external_user_id)' missing" unless arguments[:body]

          external_user_id = arguments.delete(:external_user_id)
          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}
          request(
            :put,
            "api/ws/v1/sources/#{content_source_id}/external_identities/#{external_user_id}/",
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
