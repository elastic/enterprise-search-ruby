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
  let(:engine_name) { 'videogames' }

  # TODO: Once we stop using VCR, we need to do create / list / destroy engines

  context 'documents' do
    it 'indexes and lists documents' do
      VCR.use_cassette('app_search/index_documents') do
        documents = [
          { name: 'Super Lorenzo Bros', year: 1985 },
          { name: 'Pack-Man', year: 1980 },
          { name: 'Galaxxian', year: 1979 },
          { name: 'Audiovisual, the hedgehog', year: '1991' }
        ]
        response = @client.index_documents(engine_name, body: documents)
        expect(response.status).to eq 200
        expect(response.body.count).to eq 4
        expect(response.body.map(&:keys)).to eq [['id', 'errors'], ['id', 'errors'], ['id', 'errors'], ['id', 'errors']]
      end

      VCR.use_cassette('app_search/list_documents') do
        response = @client.list_documents(engine_name)

        expect(response.status).to eq 200
        expect(response.body['results'].count).to eq 4
      end
    end

    it 'searches for a document' do
      VCR.use_cassette('app_search/search') do
        response = @client.search(engine_name, body: { query: 'Pack-Man' })
        expect(response.status).to eq 200
        expect(response.body['meta']['engine']).to eq({ 'name' => 'videogames', 'type' => 'default' })
        expect(response.body['results'].first['name']).to eq({ 'raw' => 'Pack-Man' })
        expect(response.body['results'].first['year']).to eq({ 'raw' => '1980' })
      end
    end

    it 'deletes a document' do
      VCR.use_cassette('app_search/index_and_delete_document') do
        document = { name: 'Princess Zelda', year: 1986 }
        response = @client.index_documents(engine_name, body: document)
        expect(response.status).to eq 200

        id = response.body.first['id']

        response = @client.delete_documents(engine_name, body: [id])
        expect(response.status).to eq 200
        expect(response.body.first['deleted'])
      end
    end

    it 'updates a document' do
      VCR.use_cassette('app_search/create_and_update_document') do
        document = { name: '', year: 1986 }
        response = @client.index_documents(engine_name, body: document)
        expect(response.status).to eq 200

        id = response.body.first['id']

        response = @client.put_documents(engine_name, body: [{ id: id, year: 1987 }])
        expect(response.status).to eq 200
        expect(response.body).to eq [{ 'id' => 'doc-5fa2d4e1389ab975965be3e3', 'errors' => [] }]
      end
    end
  end
end
