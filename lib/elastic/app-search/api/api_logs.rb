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
    module AppSearch
      module Actions
        # APILogs - Retrieve API logs
        # The API Log displays API request and response data at the Engine level
        #
        # @param [String] engine_name Name of the engine (*Required*)
        # @param [Hash] arguments endpoint arguments
        # @option arguments [Hash] :body (Required: filters)
        # @option body :filters
        # @option body :page
        # @option body [string] :query
        # @option body :sort_direction
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/app-search/current/api-logs.html
        #
        def api_logs(engine_name, arguments = {})
          raise ArgumentError, "Required parameter 'engine_name' missing" unless engine_name
          raise ArgumentError, "Required parameter 'body (filters)' missing" unless arguments[:body]

          body = arguments.delete(:body) || {}

          headers = arguments.delete(:headers) || {}
          request(
            :post,
            "api/as/v1/engines/#{engine_name}/logs/api/",
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
