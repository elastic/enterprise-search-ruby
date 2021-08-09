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
    module WorkplaceSearch
      module Actions
        # Analytics - Capture click and feedback analytic events
        # Capture Analytic events for click and feedback
        #
        # @param arguments [Hash] endpoint arguments
        # @option arguments [String] :access_token OAuth Access Token (*Required*)
        # @option arguments [Hash] :body Workplace Search analytics event (Required: type, query_id, page, content_source_id, document_id, rank)
        # @option body [String] :type  (*Required)
        # @option body [String] :query_id query identifier for the event (*Required)
        # @option body [Integer] :page page number of the document in the query result set (*Required)
        # @option body [String] :content_source_id content source identifier for the event document (*Required)
        # @option body [String] :document_id document identifier for the event (*Required)
        # @option body [Integer] :rank rank of the document in the overall result set (*Required)
        # @option body [String] :event the target identifier for a click event
        # @option body [Integer] :score the feedback score, constrained to the values -1 or 1
        # @option arguments [Hash] :headers optional HTTP headers to send with the request
        #
        # @see https://www.elastic.co/guide/en/workplace-search/current/workplace-search-analytics-api.html
        #
        def create_analytics_event(arguments = {})
          raise ArgumentError, "Required parameter 'access_token' missing" unless arguments[:access_token]

          body = arguments.delete(:body) || {}
          headers = arguments.delete(:headers) || {}

          request(
            :post,
            'api/ws/v1/analytics/event/',
            arguments,
            body,
            headers
          )
        end
      end
    end
  end
end
