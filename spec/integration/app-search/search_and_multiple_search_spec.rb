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
  let(:engine_name) { 'search' }
  let(:documents) do
    [
      { title: 'Animal Farm', author: 'George Orwell' },
      { title: '1984', author: 'George Orwell' },
      { title: 'Jungle Tales', author: 'Horacio Quiroga' },
      { title: 'Lenguas de diamante', author: 'Juana de Ibarbourou' },
      { title: 'Metamorphosis', author: 'Franz Kafka' },
      { title: 'The Handmaid\'s Tale', author: 'Margaret Atwood' }
    ]
  end

  before do
    create_engine(engine_name)
    client.index_documents(engine_name, documents: documents)
    sleep 1
  end

  after do
    delete_engines
  end

  context 'search' do
    it 'performs a single query search' do
      response = client.search(engine_name, query: 'Ibarbourou')
      expect(response.status).to eq 200
      expect(response.body).not_to be nil
      expect(response.body['results'].count).to be 1

      expect(response.body['results'].first['author']['raw']).to eq documents[3][:author]
      expect(response.body['results'].first['title']['raw']).to eq documents[3][:title]
    end
  end

  context 'multi query search' do
    it 'performs a multi query search' do
      response = client.multi_search(engine_name, body: { queries: [{ query: 'George' }, { query: 'Margaret' }] })
      expect(response.status).to eq 200
      expect(response.body.class).to be Array
      expect(response.body.count).to be 2
      expect(response.body[0]['results']).to_not be nil
      expect(response.body[1]['results']).to_not be nil
    end
  end
end
