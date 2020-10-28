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

require 'spec_helper'
require_relative './../webmock_requires'

describe Elastic::EnterpriseSearch::Client do
  let(:host) { 'https://localhost:8080' }
  let(:http_auth) { { user: 'elasticenterprise', password: 'password' } }

  context 'initialization' do
    it 'sets up options' do
      client = Elastic::EnterpriseSearch::Client.new(
        host: host
      )
      expect(client.host).to eq host
    end

    it 'uses the default host' do
      client = Elastic::EnterpriseSearch::Client.new

      expect(client.host).to eq 'http://localhost:3002'
    end

    it 'raises an exception for invalid host' do
      expect do
        Elastic::EnterpriseSearch::Client.new(host: 'localhost')
      end.to raise_exception(URI::InvalidURIError)
    end
  end

  context 'logging' do
    require 'logger'
    # rubocop:disable all
    class FakeLogger < Logger
      def initialize; @strio = StringIO.new; super(@strio); end
      def messages; @strio.string; end
    end
    # rubocop:enable all

    let(:logger) { FakeLogger.new }

    it 'sets log' do
      client = Elastic::EnterpriseSearch::Client.new(log: true)

      expect(client.log)
    end

    it 'sets a logger' do
      client = Elastic::EnterpriseSearch::Client.new(logger: logger)
      stub_request(:get, 'http://localhost:3002/api/ent/v1/internal/health/')
      client.health
      expect(logger.messages).to include('INFO -- : GET http://localhost:3002/api/ent/v1/internal/health/')
    end
  end

  context 'basic authentication' do
    it 'sets up authentication on initialization' do
      client = Elastic::EnterpriseSearch::Client.new(
        http_auth: http_auth
      )
      expect(client.http_auth).to eq http_auth
    end

    it 'sets authentication after initialization' do
      http_auth = { user: 'test', password: 'testing' }
      client = Elastic::EnterpriseSearch::Client.new
      client.http_auth = http_auth
      expect(client.http_auth).to eq http_auth
    end
  end

  context 'workplace search instantiation from enterprise search' do
    let(:client) { Elastic::EnterpriseSearch::Client.new(host: host) }

    it 'instantiates workplace search with default endpoint' do
      expect(client.workplace_search.host).to eq host
    end
  end
end
