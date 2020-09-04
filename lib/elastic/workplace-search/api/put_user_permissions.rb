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
        # Permissions - Creates a new set of permissions or over-writes all existing permissions
        # Create a set of permissions or overwrite existing permissions
        #
        # @param content_source_key [String] Unique key for a Custom API source, provided upon creation of a Custom API Source (*Required*)
        # @param user [String] The username in context (*Required*)
        #
        # @see https://www.elastic.co/guide/en/workplace-search/current/workplace-search-document-permissions-api.html#add-all
        #
        def put_user_permissions(content_source_key, body = {}, parameters = {})
          raise ArgumentError, "Required parameter 'content_source_key' missing" unless content_source_key
          raise ArgumentError, "Required parameter 'user' missing" unless parameters[:user]

          request(
            :put,
            "api/ws/v1/sources/#{content_source_key}/permissions/#{user}/",
            parameters,
            body
          )
        end
      end
    end
  end
end
