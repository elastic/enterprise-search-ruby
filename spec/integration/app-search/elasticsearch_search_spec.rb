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
  context 'Elasticsearch Search' do
    let(:engine_name) { 'elasticsearch-books' }
    let(:documents) do
      [
        { title: 'Beasts Before Us', author: 'Elsa Panciroli' },
        { title: 'The Rise and Fall of the Dinosaurs', author: 'Steve Brusatte' },
        { title: 'Raptor Red', author: 'Robert T. Bakker' },
        { title: 'The Earth: A biography of life', author: 'Dr. Elsa Panciroli' }
      ]
    end
    let(:api_key_name) { 'my-api-key' }

    before do
      # Use API Key in client, save a backup to restore original auth:
      @old_client = @client.dup
      api_key_body = { name: api_key_name, type: 'private', read: true, write: true, access_all_engines: true }
      response = client.create_api_key(body: api_key_body)
      @client.http_auth = response.body['key']
      create_engine(engine_name)
      client.index_documents(engine_name, documents: documents)
      sleep 1
    end

    after do
      # Restore original client:
      @client = @old_client
      delete_engines
      client.delete_api_key(api_key_name: api_key_name)
    end

    it 'performs an ES search' do
      es_request = { query: { bool: { must: { term: { author: 'panciroli' } } } } }
      response = client.search_es_search(engine_name, body: es_request)
      expect(response.status).to eq 200
      expect(response.body['hits']['hits'].count).to eq 2
      expect do
        response.body['hits']['hits'].map do |a|
          a['_source']['author']
        end == ['Elsa Panciroli', 'Dr. Elsa Panciroli']
      end
    end

    it 'performs an ES search with query parameters' do
      es_request = { query: { bool: { must: { term: { author: 'panciroli' } } } } }
      response = client.search_es_search(engine_name, body: es_request, sort: "{ 'author': 'desc' }")
      expect(response.status).to eq 200
      expect(response.body['hits']['hits'].count).to eq 2
      expect do
        response.body['hits']['hits'].map do |a|
          a['_source']['author']
        end == ['Dr. Elsa Panciroli', 'Elsa Panciroli']
      end
    end
  end
end
