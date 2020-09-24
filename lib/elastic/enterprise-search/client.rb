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

# TODO: CONFIG require 'elastic/enterprise-search/configuration'
require 'elastic/enterprise-search/request'
require 'elastic/enterprise-search/utils'
require 'elasticsearch-transport'

module Elastic
  module EnterpriseSearch
    # API client for the {Elastic Enterprise Search API}[https://www.elastic.co/enterprise-search].
    # This is the main client from which the Workplace Search and App Search clients inherit.
    class Client
      DEFAULT_TIMEOUT = 15

      include Elastic::EnterpriseSearch::Request
      include Elastic::EnterpriseSearch::Actions
      include Elastic::EnterpriseSearch::Utils

      def workplace_search(options = {})
        @workplace_search ||= Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(
          host: host,
          access_token: options.dig(:access_token),
          transport: @transport
        )
      end

      def app_search(options = {})
        @app_search ||= Elastic::EnterpriseSearch::AppSearch::Client.new(
          host: host,
          http_auth: options.dig(:http_auth),
          transport: @transport
        )
      end

      # TODO: CONFIG and initializer revamp for Ent search and the rest and pass
      # in options so they can live with workplace-search and app-search options
      #
      # def self.configure(&block)
      #   Elastic::EnterpriseSearch.configure(&block)
      # end
      #
      # Create a new Elastic::EnterpriseSearch::Client client
      #
      # @param options [Hash] a hash of configuration options that will override what is set on the Elastic::EnterpriseSearch class.
      # @option options [String] :host Enterprise Search host
      # @option options [Hash] :basic_auth a username and password for Basic Authentication
      # @option options [Numeric] :overall_timeout overall timeout for requests in seconds (default: 15s)
      # @option options [Numeric] :open_timeout the number of seconds Net::HTTP (default: 15s) will wait while opening a connection before raising a Timeout::Error
      # @option options [String] :proxy url of proxy to use, ex: "http://localhost:8888"
      def initialize(options = {})
        @options = options
        @transport = @options[:transport] ||
                     Elasticsearch::Client.new(
                       host: host,
                       request_timeout: overall_timeout,
                       transport_options: {
                         request: { open_timeout: open_timeout }
                       }
                     )
      end

      def open_timeout
        @options[:open_timeout] || DEFAULT_TIMEOUT
      end

      def proxy
        @options[:proxy]
      end

      def overall_timeout
        (@options[:overall_timeout] || DEFAULT_TIMEOUT).to_f
      end

      def http_auth
        @options[:http_auth] || { user: 'elastic', password: 'changeme' }
      end

      def http_auth=(http_auth)
        @options[:http_auth] = http_auth
      end

      def host
        @options[:host] || DEFAULT_HOST
      end
    end
  end
end
