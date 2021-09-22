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
  context 'Curations' do
    let(:engine_name) { 'books' }

    before do
      client.create_engine(name: engine_name)
      documents = [
        { title: 'Jungle Tales', author: 'Horacio Quiroga' },
        { title: 'The Jungle Book', author: 'Rudyard Kipling' }
      ]
      response = client.index_documents(engine_name, documents: documents)

      @promoted = response.body.first
      @hidden = response.body.last
    end
    after do
      client.delete_engine(engine_name)
      sleep 1
    end

    it 'creates a new curation' do
      response = create_curation(engine_name, 'jungle', @promoted['id'], @hidden['id'])
      expect(response.status).to eq 200
      expect(response.body['id']).to match(/cur-[0-9a-f]+/)

      response = client.search(engine_name, query: 'jungle')
      expect(response.status).to eq 200
      expect(response.body['results'].count).to eq 1
      expect(response.body['results'].first['title']['raw']).to eq 'Jungle Tales'
    end

    it 'retrieves a curation by id' do
      id = create_curation(engine_name, 'book', @promoted['id'], @hidden['id']).body['id']

      response = client.curation(engine_name, curation_id: id)

      expect(response.status).to eq 200
      expect(response.body['id']).to match(/cur-[0-9a-f]+/)
      expect(response.body['queries']).to eq ['book']
      expect(response.body['promoted']).to eq [@promoted['id']]
      expect(response.body['hidden']).to eq [@hidden['id']]
    end

    def create_curation(name, query, promoted_id, hidden_id)
      response = client.create_curation(
        name,
        queries: [query],
        promoted: [promoted_id],
        hidden: [hidden_id]
      )
      # Give the server a second
      sleep 1
      response
    end

    it 'updates an existing curation' do
      id = create_curation(engine_name, 'jungle', @promoted['id'], @hidden['id']).body['id']

      response = client.put_curation(
        engine_name,
        curation_id: id,
        queries: ['jungle'],
        promoted: [@hidden['id']],
        hidden: [@promoted['id']]
      )

      expect(response.status).to eq 200
      expect(response.body['id']).to match(/cur-[0-9a-f]+/)

      response = @client.search(engine_name, query: 'jungle')
      expect(response.status).to eq 200
      expect(response.body['results'].count).to eq 1
      expect(response.body['results'].first['title']['raw']).to eq 'The Jungle Book'
    end

    it 'lists curations' do
      create_curation(engine_name, 'jungle', @promoted['id'], @hidden['id']).body['id']
      create_curation(engine_name, 'book', @promoted['id'], @hidden['id']).body['id']
      create_curation(engine_name, 'tales', @promoted['id'], @hidden['id']).body['id']

      response = client.list_curations(engine_name)

      expect(response.status).to eq 200
      expect(response.body['results'].count).to eq 3
      curation = response.body['results'].first
      expect(curation['id']).to match(/cur-[0-9a-f]+/)
    end

    it 'deletes a  curation' do
      id = create_curation(engine_name, 'jungle', @promoted['id'], @hidden['id']).body['id']
      response = client.delete_curation(engine_name, curation_id: id)

      expect(response.status).to eq 200
      expect(response.body).to eq({ 'deleted' => true })
    end
  end
end
