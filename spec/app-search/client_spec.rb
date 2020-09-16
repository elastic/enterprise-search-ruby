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

describe Elastic::EnterpriseSearch::AppSearch::Client do
  let(:host) { 'https://localhost:8080' }
  let(:api_key) { 'api_key' }

  context 'dependant on EnterpriseSearch' do
    let(:ent_client) { Elastic::EnterpriseSearch::Client.new(host: host) }
    let(:app_client) { ent_client.app_search }

    it 'initializes an app search client' do
      expect(app_client).not_to be nil
      expect(app_client).to be_a(Elastic::EnterpriseSearch::AppSearch::Client)
      expect(app_client.host).to eq(host)
    end

    it 'sets up authentication during initialization' do
      ent_client = Elastic::EnterpriseSearch::Client.new(host: host)
      app_client = ent_client.app_search(api_key: api_key)
      expect(app_client.api_key).to eq api_key
    end

    it 'sets up authentication as a parameter' do
      app_client.api_key = api_key
      expect(app_client.api_key).to eq api_key
    end
  end

  context 'independent from EnterpriseSearch client' do
    let(:app_client) { Elastic::EnterpriseSearch::AppSearch::Client.new(host: host) }

    it 'initializes a workplace search client' do
      expect(app_client).not_to be nil
      expect(app_client).to be_a(Elastic::EnterpriseSearch::AppSearch::Client)
      expect(app_client.host).to eq(host)
    end

    it 'sets up authentication during initialization' do
      ent_client = Elastic::EnterpriseSearch::Client.new(host: host)
      app_client = ent_client.app_search(api_key: api_key)
      expect(app_client.api_key).to eq api_key
    end

    it 'sets up authentication as a parameter' do
      app_client.api_key = api_key
      expect(app_client.api_key).to eq api_key
    end
  end
end
