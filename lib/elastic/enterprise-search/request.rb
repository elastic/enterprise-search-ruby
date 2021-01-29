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

# frozen_string_literal: true

require 'net/https'
require 'json'
require 'elastic/enterprise-search/exceptions'
require 'base64'

module Elastic
  module EnterpriseSearch
    CLIENT_NAME = 'elastic-enteprise-search-ruby'
    CLIENT_VERSION = Elastic::EnterpriseSearch::VERSION

    # Module included in Elastic::Enterprise::Client for http requests.
    module Request
      def get(path, params = {}, headers = {})
        request(:get, path, params, headers)
      end

      def post(path, params = {}, body = {}, headers = {})
        request(:post, path, params, body, headers)
      end

      def put(path, params = {}, body = {}, headers = {})
        request(:put, path, params, body, headers)
      end

      def delete(path, params = {}, headers = {})
        request(:delete, path, params, headers)
      end

      # Construct and send a request to the API.
      #
      # @raise [Timeout::Error] when the timeout expires
      def request(method, path, params = {}, body = {}, headers = {})
        meta_headers = { authorization: setup_authentication_header, user_agent: request_user_agent }
        headers = if headers.nil? || !headers.is_a?(Hash)
                    meta_headers
                  else
                    headers.merge(meta_headers)
                  end
        @transport.perform_request(method.to_s.upcase, path, params, body, headers)
      end

      def setup_authentication_header
        credentials = Base64.strict_encode64("#{http_auth[:user]}:#{http_auth[:password]}")
        "Basic #{credentials}"
      end

      private

      def request_user_agent
        ua = "#{CLIENT_NAME}/#{CLIENT_VERSION}"
        meta = ["RUBY_VERSION: #{RUBY_VERSION}"]
        if RbConfig::CONFIG && RbConfig::CONFIG['host_os']
          meta << "#{RbConfig::CONFIG['host_os'].split('_').first[/[a-z]+/i].downcase} " \
                  "#{RbConfig::CONFIG['target_cpu']}"
        end
        meta << "elasticsearch-transport: #{Elasticsearch::Transport::VERSION}"
        "#{ua} (#{meta.join('; ')})"
      end
    end
  end
end
