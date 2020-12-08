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
  let(:host) { ENV['ELASTIC_ENTERPRISE_HOST'] || 'http://localhost:3002' }
  let(:access_token) { ENV['ELASTIC_WORKPLACE_TOKEN'] || 'access_token' }
  let(:content_source_key) { ENV['ELASTIC_WORKPLACE_SOURCE_KEY'] || 'content_source_key' }
  let(:client) do
    Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(
      host: host,
      http_auth: access_token
    )
  end

  context 'external identities' do
    let(:user) { 'elastic_user' }
    let(:source_user_id) { 'example@elastic.co' }

    it 'creates an external identity' do
      VCR.use_cassette('workplace_search/create_external_identity') do
        body = { user: user, source_user_id: source_user_id }
        response = client.create_external_identity(content_source_key, body: body)

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'source_user_id' => source_user_id, 'user' => user })
      end
    end

    it 'retrieves an external identity' do
      VCR.use_cassette('workplace_search/retrieve_external_identity') do
        response = client.external_identity(content_source_key, user: user)

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'source_user_id' => source_user_id, 'user' => user })
      end
    end

    it 'lists external identities' do
      VCR.use_cassette('workplace_search/list_external_identities') do
        response = client.list_external_identities(content_source_key)

        expect(response.status).to eq 200
        expect(response.body['results']).to eq([{ 'source_user_id' => source_user_id, 'user' => user }])
      end
    end

    it 'updates an external identity' do
      VCR.use_cassette('workplace_search/put_external_identity') do
        body = { source_user_id: 'example2@elastic.co' }
        response = client.put_external_identity(content_source_key, user: user, body: body)

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'source_user_id' => 'example2@elastic.co', 'user' => user })
      end
    end

    it 'deletes an external identity' do
      VCR.use_cassette('workplace_search/delete_external_identity') do
        response = client.delete_external_identity(content_source_key, user: user)

        expect(response.status).to eq 200
        expect(response.body).to eq 'ok'
      end
    end
  end
end
