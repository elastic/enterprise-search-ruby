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
        # ExternalIdentities - Retrieves all external identities
        # Retrieves all external identities
        #
        # @option content_source_key - Unique key for a Custom API source, provided upon creation of a Custom API Source (*Required*)

        #
        # @see https://www.elastic.co/guide/en/workplace-search/current/workplace-search-external-identities-api.html#list-external-identities
        #
        def list_all_external_identities(content_source_key, parameters = {})
          raise ArgumentError, "Required parameter 'content_source_key' missing" unless content_source_key

          request(
            :get,
            "/api/ws/v1/sources/#{content_source_key}/external_identities",
            parameters
          )
        end
      end
    end
  end
end
