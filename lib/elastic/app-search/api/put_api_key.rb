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
        # Credentials - Update an API key
        # Updates an API key
        #
        # @param arguments [Hash] endpoint arguments
        # @option arguments [String] :api_key_name Name of an API key (*Required*)
        # @option arguments [Hash] :body Details of an API key (Required: name, type)
        # @option body [String] :id
        # @option body [String] :name  (*Required)
        # @option body [String] :type  (*Required)
        # @option body [Boolean] :access_all_engines
        # @option body :engines
        # @option body [Boolean] :write
        # @option body [Boolean] :read
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/app-search/current/credentials.html#credentials-update
        #
        def put_api_key(arguments = {})
          raise ArgumentError, "Required parameter 'api_key_name' missing" unless arguments[:api_key_name]

          api_key_name = arguments[:api_key_name]
          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}

          request(
            :put,
            "api/as/v1/credentials/#{api_key_name}/",
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
