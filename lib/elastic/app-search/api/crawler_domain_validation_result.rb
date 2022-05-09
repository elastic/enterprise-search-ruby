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
        # Crawler - Validate Domain with Crawler
        # Performs a number of checks on a given domain name to make sure it is ready to be crawled and ingested into App Search.
        #
        # @param [Hash] arguments endpoint arguments
        # @option arguments [string] :body
        # @option body [string] :url *Required*
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/app-search/current/web-crawler-api-reference.html#web-crawler-apis-post-crawler-validate-domain
        #
        def crawler_domain_validation_result(arguments = {})
          body = arguments.delete(:body) || {}

          headers = arguments.delete(:headers) || {}
          request(
            :post,
            'api/as/v1/crawler/validate_url/',
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
