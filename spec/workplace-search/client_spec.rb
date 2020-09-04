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
  let(:host) { 'https://localhost:8080' }

  context 'dependant on EnterpriseSearch' do
    let(:ent_client) { Elastic::EnterpriseSearch::Client.new(host: host) }
    let(:workplace_client) { ent_client.workplace_search }
    let(:access_token) { 'access_token' }

    it 'initializes a workplace search client' do
      expect(workplace_client).not_to be nil
      expect(workplace_client).to be_a(Elastic::EnterpriseSearch::WorkplaceSearch::Client)
      expect(workplace_client.host).to eq(host)
    end

    it 'sets up authentication during initialization' do
      ent_client = Elastic::EnterpriseSearch::Client.new(host: host)
      workplace_client = ent_client.workplace_search(access_token: access_token)
      expect(workplace_client.access_token).to eq access_token
    end

    it 'sets up authentication as a parameter' do
      workplace_client.access_token = access_token
      expect(workplace_client.access_token).to eq access_token
    end
  end

  context 'independent from EnterpriseSearch client' do
    let(:workplace_client) { Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(host: host) }
    let(:access_token) { 'access_token' }

    it 'initializes a workplace search client' do
      expect(workplace_client).not_to be nil
      expect(workplace_client).to be_a(Elastic::EnterpriseSearch::WorkplaceSearch::Client)
      expect(workplace_client.host).to eq(host)
    end

    it 'sets up authentication during initialization' do
      ent_client = Elastic::EnterpriseSearch::Client.new(host: host)
      workplace_client = ent_client.workplace_search(access_token: access_token)
      expect(workplace_client.access_token).to eq access_token
    end

    it 'sets up authentication as a parameter' do
      workplace_client.access_token = access_token
      expect(workplace_client.access_token).to eq access_token
    end
  end
end
