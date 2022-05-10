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
        # Credentials - Create an API key
        # Creates an App Search API key
        #
        # @param [Hash] arguments endpoint arguments
        # @option arguments [Hash] :body (Required: name, type)
        # @option body [string] :id
        # @option body [string] :name
        # @option body [string] :type
        # @option body [boolean] :access_all_engines
        # @option body :engines
        # @option body [boolean] :write
        # @option body [boolean] :read
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/app-search/current/credentials.html#credentials-create
        #
        def create_api_key(arguments = {})
          raise ArgumentError, "Required parameter 'body (name,type)' missing" unless arguments[:body]

          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}
          request(
            :post,
            'api/as/v1/credentials/',
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
