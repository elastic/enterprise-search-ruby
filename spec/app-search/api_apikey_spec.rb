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

require_relative './api_spec_helper'

describe Elastic::EnterpriseSearch::AppSearch::Client do
  context 'API Key' do
    let(:name) { 'my-api-key' }

    it 'creates an API key' do
      VCR.use_cassette('app_search/create_api_key') do
        body = {
          name: name,
          type: 'private',
          read: true,
          write: true,
          access_all_engines: true
        }
        response = @client.create_api_key(body: body)

        expect(response.status).to eq 200
        expect(response.body.keys).to include('id')
        expect(response.body.keys).to include('key')
        expect(response.body).to include('name' => name)
        expect(response.body).to include('type' => 'private')
        expect(response.body).to include('read' => true)
        expect(response.body).to include('write' => true)
        expect(response.body).to include('access_all_engines' => true)
      end
    end

    it 'gets the details of an API key' do
      VCR.use_cassette('app_search/get_api_key') do
        response = @client.api_key(api_key_name: name)

        expect(response.status).to eq 200
        expect(response.body.keys).to include('id')
        expect(response.body.keys).to include('key')
        expect(response.body).to include('name' => name)
        expect(response.body).to include('type' => 'private')
        expect(response.body).to include('read' => true)
        expect(response.body).to include('write' => true)
        expect(response.body).to include('access_all_engines' => true)
        expect(response.body)
      end
    end

    it 'lists API keys' do
      VCR.use_cassette('app_search/list_api_keys') do
        response = @client.list_api_keys

        expect(response.status).to eq 200
        expect(response.body['results'].count).to be > 1
      end
    end

    it 'updates an API key' do
      VCR.use_cassette('app_search/put_api_key') do
        body = { name: name, type: 'private', read: true, write: true, engines: ['test'] }
        response = @client.put_api_key(api_key_name: name, body: body)

        expect(response.status).to eq 200
        expect(response.body['engines']).to eq ['test']
      end
    end

    it 'deletes an API key' do
      VCR.use_cassette('app_search/delete_api_key') do
        response = @client.delete_api_key(api_key_name: name)

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'deleted' => true })
      end
    end
  end
end
