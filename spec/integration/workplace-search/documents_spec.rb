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
  after do
    delete_content_sources
  end

  let(:documents) do
    [
      {
        'id' => '4e696e74656e646f203634',
        'url' => 'https://www.elastic.co/blog/introducing-quick-start-guides-getting-started-with-elastic-enterprise-search-for-free',
        'title' => 'Getting started with Elastic Enterprise Search for free',
        'body' => 'this is a test'
      },
      {
        'id' => '47616d6520426f7920436f6c6f72',
        'url' => 'https://www.elastic.co/workplace-search',
        'title' => 'One-stop answer shop for the virtual workplace',
        'body' => 'this is also a test'
      }
    ]
  end

  context 'Documents' do
    let(:content_source_id) do
      client.create_content_source(body: { name: 'test' }).body['id']
    end

    it 'indexes' do
      response = client.index_documents(content_source_id, documents: documents)
      expect(response.status).to eq 200
    end

    it 'deletes' do
      response = client.delete_documents(content_source_id, document_ids: documents.map { |doc| doc['id'] })
      expect(response.status).to eq 200
    end
  end

  context 'Documents in Content Sources' do
    let(:content_source_id) { client.create_content_source(body: { name: 'books' }).body['id'] }
    let(:document_id) { client.index_documents(content_source_id, documents: documents).body['results'].first['id'] }

    it 'Gets a document in a content source' do
      response = client.document(content_source_id, document_id: document_id)
      expect(response.status).to eq 200
      expect(response.body['id']).to eq document_id
    end

    it 'Deletes all documents in a content source' do
      response = client.delete_all_documents(content_source_id)
      expect(response.status).to eq 200
    end

    it 'Deletes documents by query' do
      content_source_id = client.create_content_source(body: { name: 'asimov' }).body['id']
      documents = [
        { title: 'Foundation', year: 1951 },
        { title: 'Foundation and Empire', year: 1952 },
        { title: 'Second Foundation', year: 1953 }
      ]
      response = client.index_documents(content_source_id, documents: documents)

      expect(response.status).to eq 200
      expect(response.body['results'].count).to eq 3

      # Give time to index the documents so we can delete them:
      sleep 2

      response = client.delete_documents_by_query(content_source_id, query: 'Foundation')
      expect(response.status).to eq 200
      expect(response.body).to eq({ 'total' => 3, 'deleted' => 3, 'failures' => [] })
    end

    it 'Lists documents' do
      content_source_id = client.create_content_source(body: { name: 'quiroga' }).body['id']
      documents = [
        { title: 'Stories of Love, Madness and Death', year: 1917 },
        { title: 'Drifting', year: 1937 },
        { title: 'The Beheaded Hen', year: 1925 }
      ]
      client.index_documents(content_source_id, documents: documents)
      # Give time to index the documents
      sleep 2

      response = client.list_documents(content_source_id)
      expect(response.status).to eq 200
      expect(response.body['results'].count).to eq 3
      expect(response.body['results'].map { |a| a['year'] }).to eq ['1917', '1937', '1925']
    end
  end
end
