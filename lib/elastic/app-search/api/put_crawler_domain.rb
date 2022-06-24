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
      # Generated from build hash 835a1a87f357f7b7cfd3453b5c5a937c47995772
      module Actions
        # Crawler - Update domain configuration
        # Updates crawler domain configuration for a given domain
        #
        # @param [String] engine_name Name of the engine (*Required*)
        # @param [Hash] arguments endpoint arguments
        # @option arguments [String] :domain_id Crawler Domain ID (*Required*)
        # @option arguments [Hash] :body
        # @option body [string] :name
        # @option body [Array<object>] :entry_points
        # @option body [Array<object>] :crawl_rules
        # @option body [Array<object>] :sitemaps
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/app-search/current/web-crawler-api-reference.html#web-crawler-apis-put-crawler-domain
        #
        def put_crawler_domain(engine_name, arguments = {})
          raise ArgumentError, "Required parameter 'engine_name' missing" unless engine_name
          raise ArgumentError, "Required parameter 'domain_id' missing" unless arguments[:domain_id]

          domain_id = arguments.delete(:domain_id)
          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}
          request(
            :put,
            "api/as/v1/engines/#{engine_name}/crawler/domains/#{domain_id}/",
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
