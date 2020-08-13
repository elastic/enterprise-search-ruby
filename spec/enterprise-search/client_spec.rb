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

# rubocop:disable Metrics/BlockLength
describe Elastic::EnterpriseSearch::Client do
  let(:endpoint) { 'https://localhost:8080' }
  let(:http_auth) { { user: 'elasticenterprise', password: 'password' } }

  context 'initialization' do
    it 'sets up options' do
      client = Elastic::EnterpriseSearch::Client.new(
        endpoint: endpoint
      )
      expect(client.endpoint).to eq endpoint
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
    let(:client) { Elastic::EnterpriseSearch::Client.new(endpoint: endpoint) }

    it 'instantiates workplace search with default endpoint' do
      expect(client.workplace_search.endpoint).to eq endpoint
    end
  end
end
# rubocop:enable Metrics/BlockLength
