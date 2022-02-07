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

describe Elastic::EnterpriseSearch::WorkplaceSearch::Client do
  let(:host) { 'http://localhost:3002' }
  let(:access_token) { 'access_token' }

  context 'dependant on EnterpriseSearch' do
    let(:ent_client) { Elastic::EnterpriseSearch::Client.new(host: host) }
    let(:workplace_client) { ent_client.workplace_search }

    it 'initializes a workplace search client' do
      expect(workplace_client).not_to be nil
      expect(workplace_client).to be_a(Elastic::EnterpriseSearch::WorkplaceSearch::Client)
      expect(workplace_client.host).to eq(host)
    end

    it 'sets up authentication during initialization' do
      ent_client = Elastic::EnterpriseSearch::Client.new(host: host)
      workplace_client = ent_client.workplace_search(http_auth: access_token)
      expect(workplace_client.http_auth).to eq access_token
    end

    it 'sets up authentication as a parameter' do
      workplace_client.http_auth = access_token
      expect(workplace_client.http_auth).to eq access_token
    end
  end

  context 'independent from EnterpriseSearch client' do
    let(:workplace_client) { Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(host: host) }

    it 'initializes a workplace search client' do
      expect(workplace_client).not_to be nil
      expect(workplace_client).to be_a(Elastic::EnterpriseSearch::WorkplaceSearch::Client)
      expect(workplace_client.host).to eq(host)
    end

    it 'sets up authentication during initialization' do
      ent_client = Elastic::EnterpriseSearch::Client.new(host: host)
      workplace_client = ent_client.workplace_search(http_auth: access_token)
      expect(workplace_client.http_auth).to eq access_token
    end

    it 'sets up authentication as a parameter' do
      workplace_client.http_auth = access_token
      expect(workplace_client.http_auth).to eq access_token
    end
  end

  context 'Authentication' do
    let(:client) { Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(http_auth: http_auth) }

    context 'when using an API token' do
      let(:http_auth) { 'api_token' }

      it 'initializes a workplace search client' do
        expect(client.http_auth).to eq http_auth
        expect(client.setup_authentication_header).to eq "Bearer #{http_auth}"
      end
    end

    context 'when using basic auth' do
      let(:http_auth) { { user: 'elastic', password: 'password' } }

      it 'initializes a workplace search client' do
        expect(client.http_auth).to eq http_auth
        expect(client.setup_authentication_header).to eq 'Basic ZWxhc3RpYzpwYXNzd29yZA=='
      end
    end
  end

  context 'OAuth' do
    let(:client) { Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(host: host) }

    it 'generates an authorization url' do
      authorization_url = 'http://localhost:3002/ws/oauth/authorize?response_type=code&client_id=client_id&redirect_uri=https%3A%2F%2Flocalhost%3A3002'
      expect(client.authorization_url('client_id', 'https://localhost:3002')).to eq authorization_url
    end
  end

  context 'adapters' do
    let(:client) { described_class.new }
    let(:adapter) { client.transport.transport.connections.all.first.connection.builder.adapter }

    context 'when no adapter is specified' do
      it 'uses Faraday NetHttp' do
        expect(adapter).to eq Faraday::Adapter::NetHttp
      end
    end

    context 'when the adapter is patron' do
      let(:client) { described_class.new(adapter: :patron) }

      it 'uses Faraday with the adapter' do
        expect(adapter).to eq Faraday::Adapter::Patron
      end
    end

    unless defined?(JRUBY_VERSION)
      context 'when the adapter is typhoeus' do
        let(:client) { described_class.new(adapter: :patron) }

        it 'uses Faraday with the adapter' do
          expect(adapter).to eq Faraday::Adapter::Patron
        end
      end
    end
  end
end
