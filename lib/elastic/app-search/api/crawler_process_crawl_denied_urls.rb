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
        # Crawler - View denied urls for Process Crawl
        # Provides a sample list of urls identified for deletion by the given process crawl id.
        #
        # @param engine_name [String] Name of the engine (*Required*)
        # @param arguments [Hash] endpoint arguments
        # @option arguments [String] :process_crawl_id Process Crawl identifier (*Required*)
        # @option arguments [Hash] :body The request body
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/app-search/current/web-crawler-api-reference.html#web-crawler-apis-get-crawler-process-crawls-id-denied-urls
        #
        def crawler_process_crawl_denied_urls(engine_name, arguments = {})
          raise ArgumentError, "Required parameter 'engine_name' missing" unless engine_name
          raise ArgumentError, "Required parameter 'process_crawl_id' missing" unless arguments[:process_crawl_id]

          process_crawl_id = arguments[:process_crawl_id]
          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}

          request(
            :get,
            "api/as/v0/engines/#{engine_name}/crawler/process_crawls/#{process_crawl_id}/denied_urls/",
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
