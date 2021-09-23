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
        # @param engine_name [String] Name of the engine (*Required*)
        # @param arguments [Hash] endpoint arguments
        # @option arguments [Date] :from_date Filter date from (*Required*)
        # @option arguments [Date] :to_date Filter date to (*Required*)
        # @option arguments [Hash] :body
        # @option body [String] :query You can search over the full_request_path of an API Log event. Use this to specify a particular endpoint, like analytics, search, curations and so on.
        # @option body [String] :sort_direction Would you like to have your results ascending, oldest to newest, or descending, newest to oldest? Accepts asc or desc. Defaults to ascending.
        # @option body [Integer] :page current for current page, total_pages for the net number of pages, total_results for the overall number of results, size for the amount of results per page.
        # @option body :filters
        # @option filters [String] :status Filter based on a particular status code: 400, 401, 403, 429, 200
        # @option filters [String] :method Filter based on a particular HTTP method: GET, POST, PUT, PATCH, DELETE
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/app-search/current/api-logs.html
        #
        def api_logs(engine_name, arguments = {})
          raise ArgumentError, "Required parameter 'engine_name' missing" unless engine_name
          raise ArgumentError, "Required parameter 'from_date' missing" unless arguments[:from_date]
          raise ArgumentError, "Required parameter 'to_date' missing" unless arguments[:to_date]

          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}
          arguments['filters[date][from]'] = date_to_rfc3339(arguments.delete(:from_date))
          arguments['filters[date][to]'] = date_to_rfc3339(arguments.delete(:to_date))

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
