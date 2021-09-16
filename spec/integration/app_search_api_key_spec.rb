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
  let(:host) { ENV['ELASTIC_ENTERPRISE_HOST'] || 'http://localhost:3002' }
  let(:http_auth) do
    {
      user: ENV['ELASTIC_ENTERPRISE_USER'] || 'enterprise_search',
      password: ENV['ELASTIC_ENTERPRISE_PASSWORD'] || 'changeme'
    }
  end
  let(:client) do
    Elastic::EnterpriseSearch::AppSearch::Client.new(host: host, http_auth: http_auth)
  end

  context 'API Key' do
    it 'creates and deletes an API key' do
      name = 'created-key'
      body = { name: name, type: 'private', read: true, write: true, access_all_engines: true }
      response = client.create_api_key(body: body)

      expect(response.status).to eq 200
      expect(response.body.keys).to include('id')
      expect(response.body.keys).to include('key')
      expect(response.body).to include('name' => name)
      expect(response.body).to include('type' => 'private')
      expect(response.body).to include('read' => true)
      expect(response.body).to include('write' => true)
      expect(response.body).to include('access_all_engines' => true)

      response = client.delete_api_key(api_key_name: name)

      expect(response.status).to eq 200
      expect(response.body).to eq({ 'deleted' => true })
    end

    it 'gets the details of an API key' do
      name = 'details-key'
      body = { name: name, type: 'private', read: true, write: true, access_all_engines: true }
      client.create_api_key(body: body)

      response = client.api_key(api_key_name: name)

      expect(response.status).to eq 200
      expect(response.body.keys).to include('id')
      expect(response.body.keys).to include('key')
      expect(response.body).to include('name' => name)
      expect(response.body).to include('type' => 'private')
      expect(response.body).to include('read' => true)
      expect(response.body).to include('write' => true)
      expect(response.body).to include('access_all_engines' => true)
      expect(response.body)

      client.delete_api_key(api_key_name: name)
    end

    it 'updates an API key' do
      key_name = 'updates-key'
      engine_name = 'update-engine'
      body = { name: key_name, type: 'private', read: true, write: true, access_all_engines: true }
      client.create_api_key(body: body)
      client.create_engine(name: engine_name)

      body = { name: key_name, type: 'private', read: true, write: true, engines: [engine_name] }
      response = client.put_api_key(api_key_name: key_name, body: body)
      expect(response.status).to eq 200
      expect(response.body['engines']).to eq [engine_name]
      client.delete_engine(engine_name)
      client.delete_api_key(api_key_name: key_name)
    end

    it 'lists API keys' do
      body = { name: 'api-key-1', type: 'private', read: true, write: true, access_all_engines: true }
      client.create_api_key(body: body)
      body = { name: 'api-key-2', type: 'private', read: true, write: true, access_all_engines: true }
      client.create_api_key(body: body)

      response = client.list_api_keys
      expect(response.status).to eq 200
      expect(response.body['results'].select { |r| ['api-key-1', 'api-key-2'].include? r['name'] }.count).to be 2
      expect(response.body['results'].count).to be >= 2
      client.delete_api_key(api_key_name: 'api-key-1')
      client.delete_api_key(api_key_name: 'api-key-2')
    end
  end
end
