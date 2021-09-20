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

require_relative "#{__dir__}/app_search_helper.rb"

describe Elastic::EnterpriseSearch::AppSearch::Client do
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
      attempts = 0
      begin
        response = put_api_key(key_name, body)
      # Since we're creating the API key and trying to update it right away, we sometimes get a 404
      # if the transaction hasn't been confirmed. We give it a second and try again for a few times:
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
        attempts += 1
        if attempts > 5
          Logger.new($stdout).log('Attempted 6 times')
          raise e
        end

        sleep 1
        response = put_api_key(key_name, body)
      end
      expect(response.status).to eq 200
      expect(response.body['engines']).to eq [engine_name]
      client.delete_engine(engine_name)
      client.delete_api_key(api_key_name: key_name)
    end

    def put_api_key(key_name, body)
      client.put_api_key(api_key_name: key_name, body: body)
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
