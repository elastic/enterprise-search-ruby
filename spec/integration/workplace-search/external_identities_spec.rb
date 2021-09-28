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

require_relative "#{__dir__}/workplace_search_helper.rb"

describe Elastic::EnterpriseSearch::WorkplaceSearch::Client do
  context 'External Identities' do
    let(:content_source_id) { client.create_content_source(name: 'my_content').body['id'] }
    let(:user) { 'elastic_user' }
    let(:source_user_id) { 'example@elastic.co' }
    let(:body) do
      { user: user, source_user_id: source_user_id }
    end

    context 'Creates' do
      let(:source_user_id) { 'test@elastic.co' }
      let(:user) { 'test' }

      it 'creates an external identity' do
        response = client.create_external_identity(content_source_id, body: body)

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'source_user_id' => source_user_id, 'user' => user })

        client.delete_external_identity(content_source_id, user: user)
      end

      it 'creates and retrieves' do
        client.create_external_identity(content_source_id, body: body)
        response = client.external_identity(content_source_id, user: user)

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'source_user_id' => source_user_id, 'user' => user })
        client.delete_external_identity(content_source_id, user: user)
      end
    end

    context 'Lists' do
      let(:user) { 'lists_test' }

      it 'lists external identities' do
        client.create_external_identity(content_source_id, body: body)
        response = client.list_external_identities(content_source_id)

        expect(response.status).to eq 200
        expect(response.body['results']).to eq([{ 'source_user_id' => source_user_id, 'user' => user }])
        client.delete_external_identity(content_source_id, user: user)
      end
    end

    context 'Updates' do
      before do
        client.create_external_identity(content_source_id, body: body)
      end

      it 'updates an external identity' do
        body = { source_user_id: 'example2@elastic.co' }
        response = client.put_external_identity(content_source_id, user: user, body: body)

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'source_user_id' => 'example2@elastic.co', 'user' => user })
      end
    end

    context 'Deletes' do
      before do
        client.create_external_identity(content_source_id, body: body)
      end

      it 'deletes an external identity' do
        response = client.delete_external_identity(content_source_id, user: user)
        expect(response.status).to eq 200
        expect(response.body).to eq 'ok'
      end
    end
  end
end
