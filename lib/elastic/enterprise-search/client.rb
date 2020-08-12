# frozen_string_literal: true

require 'set'
# TODO: CONFIG require 'elastic/enterprise-search/configuration'
require 'elastic/enterprise-search/request'
require 'elastic/enterprise-search/utils'

module Elastic
  module EnterpriseSearch
    # API client for the {Elastic Enterprise Search API}[https://www.elastic.co/enterprise-search].
    class Client
      DEFAULT_TIMEOUT = 15

      include Elastic::EnterpriseSearch::Request
      include Elastic::EnterpriseSearch::Actions

      # TODO: Options
      def workplace_search
        @workplace_search ||= Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(
          endpoint: endpoint
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
      # @option options [Hash] :basic_auth a username and password for Basic Authentication
      # @option options [Numeric] :overall_timeout overall timeout for requests in seconds (default: 15s)
      # @option options [Numeric] :open_timeout the number of seconds Net::HTTP (default: 15s) will wait while opening a connection before raising a Timeout::Error
      # @option options [String] :proxy url of proxy to use, ex: "http://localhost:8888"
      def initialize(options = {})
        @options = options
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

      def endpoint
        @options[:endpoint] || DEFAULT_ENDPOINT
      end
    end
  end
end
