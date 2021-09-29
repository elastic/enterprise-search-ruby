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
    module Actions
      # Read-Only - Update the read-only flag's state
      # Update the read-only flag's state
      #
      # @param arguments [Hash] endpoint arguments
      # @option arguments [Hash] :body  (Required: enabled)
      # @option body [Boolean] :enabled  (*Required)
      # @option arguments [Hash] :headers optional HTTP headers to send with the request
      #
      # @see https://www.elastic.co/guide/en/enterprise-search/current/read-only-api.html#setting-read-only-state
      #
      def put_read_only(arguments = {})
        body = arguments.delete(:body) || {}
        headers = arguments.delete(:headers) || {}

        request(
          :put,
          'api/ent/v1/internal/read_only_mode/',
          arguments,
          body,
          headers
        )
      end
    end
  end
end
