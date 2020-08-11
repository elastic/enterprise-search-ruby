# frozen_string_literal: true

require 'net/https'
require 'json'
require 'elastic/enterprise-search/exceptions'
require 'openssl'

module Elastic
  module EnterpriseSearch
    CLIENT_NAME = 'elastic-enteprise-search-ruby'
    CLIENT_VERSION = Elastic::EnterpriseSearch::VERSION

    # Module included in Elastic::Enterprise::Client for http requests.
    module Request
      def get(path, params = {})
        request(:get, path, params)
      end

      def post(path, params = {})
        request(:post, path, params)
      end

      def put(path, params = {})
        request(:put, path, params)
      end

      def delete(path, params = {})
        request(:delete, path, params)
      end

      # Construct and send a request to the API.
      #
      # @raise [Timeout::Error] when the timeout expires
      def request(method, path, params = {})
        # TODO: Timeout.timeout(overall_timeout) do
        # TODO: Set up endpoint per service:
        uri = URI.parse("#{endpoint}#{path}")
        request = build_request(method, uri, params)
        http = build_http(uri)

        response = http.request(request)
        handle_errors(response)
        JSON.parse(response.body) if response.body && response.body.strip != ''
        #end
      end

      private

      def build_http(uri)
        # TODO: Commented out before replacing with transport
        # http = if proxy
        #          setup_proxy(uri)
        #        else
        #          Net::HTTP.new(uri.host, uri.port)
        #        end
        # http.open_timeout = open_timeout
        # http.read_timeout = overall_timeout
        http = Net::HTTP.new(uri.host, uri.port)
        setup_ssl(http) if uri.scheme == 'https'
        http
      end

      # rubocop:disable Metrics/MethodLength
      def handle_errors(response)
        case response
        when Net::HTTPSuccess
          response
        when Net::HTTPUnauthorized
          raise Elastic::EnterpriseSearch::InvalidCredentials
        when Net::HTTPNotFound
          raise Elastic::EnterpriseSearch::NonExistentRecord
        when Net::HTTPBadRequest
          raise Elastic::EnterpriseSearch::BadRequest, "#{response.code} #{response.body}"
        when Net::HTTPForbidden
          raise Elastic::EnterpriseSearch::Forbidden
        else
          raise Elastic::EnterpriseSearch::UnexpectedHTTPException, "#{response.code} #{response.body}"
        end
      end
      # rubocop:enable Metrics/MethodLength

      def build_request(method, uri, params)
        klass = method_klass(method)
        case method
        when :get, :delete
          uri.query = URI.encode_www_form(params) if params && !params.empty?
          req = klass.new(uri.request_uri)
        when :post, :put
          req = klass.new(uri.request_uri)
          req.body = JSON.generate(params) unless params.empty?
        end
        setup_headers(req)
      end

      def method_klass(method)
        case method
        when :get
          Net::HTTP::Get
        when :post
          Net::HTTP::Post
        when :put
          Net::HTTP::Put
        when :delete
          Net::HTTP::Delete
        end
      end

      def setup_headers(req)
        req['User-Agent'] = request_user_agent
        req['Content-Type'] = 'application/json'
        setup_authentication_header(req)
        req
      end

      # TODO: Test Basic Auth
      # This method needs to be defined in each child client
      def setup_authentication_header(request)
        request.basic_auth "#{http_auth[:user]} #{http_auth[:password]}"
        request
      end

      def request_user_agent
        ua = "#{CLIENT_NAME}/#{CLIENT_VERSION}"
        meta = ["RUBY_VERSION: #{RUBY_VERSION}"]
        if RbConfig::CONFIG && RbConfig::CONFIG['host_os']
          meta << "#{RbConfig::CONFIG['host_os'].split('_').first[/[a-z]+/i].downcase} " \
                  "#{RbConfig::CONFIG['target_cpu']}"
        end
        "#{ua} (#{meta.join('; ')})"
      end

      def setup_proxy(uri)
        proxy_parts = URI.parse(proxy)
        Net::HTTP.new(uri.host, uri.port, proxy_parts.host, proxy_parts.port, proxy_parts.user, proxy_parts.password)
      end

      def setup_ssl(http)
        http.use_ssl = true
        # st_ssl_verify_none provides a means to disable SSL verification for debugging purposes. An example
        # is Charles, which uses a self-signed certificate in order to inspect https traffic. This will
        # not be part of this client's public API, this is more of a development enablement option
        http.verify_mode = ENV['st_ssl_verify_none'] == 'true' ? OpenSSL::SSL::VERIFY_NONE : OpenSSL::SSL::VERIFY_PEER
        http.ca_file = File.realpath(File.join(File.dirname(__FILE__), '..', '..', 'data', 'ca-bundle.crt'))
        http.ssl_timeout = open_timeout
      end
    end
  end
end
