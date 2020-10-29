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
        # Engine - Creates a new engine
        #
        # @param arguments [Hash] endpoint arguments
        # @option name [String] Engine name (*Required*)
        # @option language [String] Engine language (null for universal)
        # @option type [String] Engine type
        # @option source_engines [Array] Sources engines list
        # @option body - The request body
        #
        #
        # @see https://www.elastic.co/guide/en/app-search/current/engines.html#engines-create
        #
        def create_engine(arguments = {})
          raise ArgumentError, "Required parameter 'name' missing" unless arguments[:name]

          body = arguments.delete(:body) || {}

          request(
            :post,
            'api/as/v1/engines/',
            arguments,
            body
          )
        end
      end
    end
  end
end
