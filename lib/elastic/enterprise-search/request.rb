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
require 'elastic/api/response'
require 'elastic/enterprise-search/exceptions'
require 'base64'

module Elastic
  module EnterpriseSearch
    CLIENT_NAME = 'elastic-enterprise-search-ruby'
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
      def request(method, path, params = {}, body = {}, headers = {})
        meta_headers = { authorization: decide_authorization(params) }
        headers = if !headers.is_a?(Hash)
                    meta_headers
                  else
                    headers.merge(meta_headers)
                  end
        Elastic::API::Response.new(
          @transport.perform_request(method.to_s.upcase, path, params, body, headers)
        )
      end

      def setup_authentication_header
        if instance_of? Elastic::EnterpriseSearch::Client
          basic_auth_header
        else
          case http_auth
          when Hash
            basic_auth_header
          when String
            "Bearer #{http_auth}"
          end
        end
      end

      def basic_auth_header
        credentials = Base64.strict_encode64("#{http_auth[:user]}:#{http_auth[:password]}")
        "Basic #{credentials}"
      end

      private

      def decide_authorization(params)
        if params[:grant_type] == 'authorization_code'
          "Bearer #{params[:code]}"
        elsif params[:access_token]
          "Bearer #{params.delete(:access_token)}"
        else
          setup_authentication_header
        end
      end
    end
  end
end
