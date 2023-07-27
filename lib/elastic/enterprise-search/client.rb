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

require 'elastic/enterprise-search/request'
require 'elastic/enterprise-search/utils'
require 'elastic-transport'

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
          http_auth: options[:http_auth],
          transport: @transport
        )
      end

      def app_search(options = {})
        @app_search ||= Elastic::EnterpriseSearch::AppSearch::Client.new(
          host: host,
          http_auth: options[:http_auth],
          transport: @transport
        )
      end

      # Create a new Elastic::EnterpriseSearch::Client client
      #
      # @param options [Hash] a hash of configuration options that will override what is set on the Elastic::EnterpriseSearch class.
      # @option options [String] :host Enterprise Search host
      # @option options [Hash] :basic_auth a username and password for Basic Authentication
      # @option options [Numeric] :overall_timeout overall timeout for requests in seconds (default: 15s)
      # @option options [Numeric] :open_timeout the number of seconds Net::HTTP (default: 15s) will wait while opening a connection before raising a Timeout::Error
      # @option options [String] :proxy url of proxy to use, ex: "http://localhost:8888"
      # @option options [Boolean] :log Use the default logger (disabled by default)
      # @option arguments [Object] :logger An instance of a Logger-compatible object
      # @option arguments [Boolean] :trace Use the default tracer (disabled by default)
      # @option arguments [Object] :tracer An instance of a Logger-compatible object
      # @option arguments [Symbol] :adapter A specific adapter for Faraday (e.g. `:patron`)
      # @option enable_meta_header [Boolean] :enable_meta_header Enable sending the meta data header to Cloud.
      #                                                          (Default: true)
      def initialize(options = {})
        @options = options
        @transport = transport
      end

      def transport
        @options[:transport] ||
          Elastic::Transport::Client.new(
            host: host,
            log: log,
            logger: logger,
            request_timeout: overall_timeout,
            adapter: adapter,
            transport_options: {
              request: { open_timeout: open_timeout },
              headers: { user_agent: user_agent }
            },
            enable_meta_header: @options[:enable_meta_header] || true,
            trace: trace,
            tracer: tracer
          )
      end

      def open_timeout
        @options[:open_timeout] || DEFAULT_TIMEOUT
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

      def log
        @options[:log] || false
      end

      def logger
        @options[:logger]
      end

      def adapter
        @options[:adapter]
      end

      def tracer
        @options[:tracer]
      end

      def trace
        @options[:trace]
      end

      def host
        return DEFAULT_HOST unless @options[:host]

        raise URI::InvalidURIError unless @options[:host] =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

        @options[:host]
      end

      private

      def user_agent
        ua = "#{CLIENT_NAME}/#{CLIENT_VERSION}"
        meta = ["RUBY_VERSION: #{RUBY_VERSION}"]
        if RbConfig::CONFIG && RbConfig::CONFIG['host_os']
          meta << "#{RbConfig::CONFIG['host_os'].split('_').first[/[a-z]+/i].downcase} " \
                  "#{RbConfig::CONFIG['target_cpu']}"
        end
        meta << "elastic-transport: #{Elastic::Transport::VERSION}"
        "#{ua} (#{meta.join('; ')})"
      end
    end
  end
end
