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
  context 'documents' do
    let(:engine_name) { 'documents' }
    let(:documents) do
      [
        { name: 'Super Lorenzo Bros', year: '1985' },
        { name: 'Pack-Man', year: '1980' },
        { name: 'Galaxxian', year: '1979' },
        { name: 'Audiovisual, the hedgehog', year: '1991' }
      ]
    end

    before do
      create_engine(engine_name)
    end

    after do
      delete_engines
    end

    def extract_from_key(key)
      ->(h) { h[key] }
    end

    it 'indexes and lists documents' do
      response = client.index_documents(engine_name, documents: documents)
      expect(response.status).to eq 200
      expect(response.body.count).to eq 4
      expect(response.body.map(&:keys)).to eq [['id', 'errors'], ['id', 'errors'], ['id', 'errors'], ['id', 'errors']]

      response = client.list_documents(engine_name)
      attempts = 0
      while response.body['results'].count < 1 && attempts < 20
        sleep 1
        attempts += 1
        response = client.list_documents(engine_name)
      end

      expect(response.status).to eq 200
      expect(response.body['results'].count).to eq 4
    end

    it 'retrieves documents by ID' do
      response = client.index_documents(engine_name, documents: documents)
      ids = response.body.map(&->(h) { h['id'] })

      attempts = 0
      while client.list_documents(engine_name).body['results'].count < 4 && attempts < 20
        sleep 1
        attempts += 1
      end

      response = client.documents(engine_name, document_ids: ids)

      expect(response.status).to eq 200
      expect(response.body.count).to eq 4
      expect(
        response.body.map(&extract_from_key('name')) - documents.map(&extract_from_key(:name))
      ).to be_empty
    end

    it 'searches for a document' do
      client.index_documents(engine_name, documents: documents)

      response = client.search(engine_name, body: { query: 'Pack-Man' })
      attempts = 0
      while response.body['results'].count < 1 && attempts < 20
        sleep 1
        attempts += 1
        response = client.search(engine_name, body: { query: 'Pack-Man' })
      end
      expect(response.status).to eq 200
      expect(response.body['meta']['engine']).to eq({ 'name' => engine_name, 'type' => 'default' })
      expect(response.body['results'].first['name']).to eq({ 'raw' => 'Pack-Man' })
      expect(response.body['results'].first['year']).to eq({ 'raw' => '1980' })
    end

    it 'deletes a document' do
      document = { name: 'Celda', year: 1986 }
      response = client.index_documents(engine_name, documents: document)
      expect(response.status).to eq 200

      id = response.body.first['id']

      response = client.delete_documents(engine_name, document_ids: [id])
      expect(response.status).to eq 200
      expect(response.body.first['deleted'])
    end

    it 'updates a document' do
      document = { name: 'Al*bert', year: 1983 }
      response = client.index_documents(engine_name, documents: document)
      expect(response.status).to eq 200

      id = response.body.first['id']

      response = client.put_documents(engine_name, documents: [{ id: id, year: 1982 }])
      expect(response.status).to eq 200
      expect(response.body).to eq [{ 'id' => id, 'errors' => [] }]
    end
  end
end
