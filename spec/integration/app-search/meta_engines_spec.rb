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
  context 'Meta Engines' do
    let(:engine_name) { 'new-meta-engine' }
    let(:create_meta_engine) do
      body = {
        name: engine_name,
        type: 'meta',
        source_engines: ['books', 'videogames']
      }
      client.create_engine(name: engine_name, body: body)
    end

    before do
      client.create_engine(name: 'books')
      client.create_engine(name: 'videogames')
    end

    after do
      delete_engines
    end

    it 'creates a meta engine' do
      response = create_meta_engine
      expect(response.status).to eq 200
      expect(response.body['name']).to eq(engine_name)
      expect(response.body['type']).to eq('meta')
      expect(response.body['source_engines'].sort).to eq(['books', 'videogames'])
    end

    it 'adds a new source engine to a meta engine' do
      create_meta_engine
      # Create new source engine to add:
      client.create_engine(name: 'add-source')
      response = client.add_meta_engine_source(engine_name, source_engines: ['add-source'])

      expect(response.status).to eq 200
      expect(response.body['name']).to eq(engine_name)
      expect(response.body['type']).to eq('meta')
      expect(response.body['source_engines'].sort).to eq(['add-source', 'books', 'videogames'])
    end

    it 'removes a source engine from a meta engine' do
      create_meta_engine
      client.create_engine(name: 'remove-source')
      client.add_meta_engine_source(engine_name, source_engines: ['remove-source'])
      response = client.delete_meta_engine_source(engine_name, source_engines: ['remove-source'])

      expect(response.status).to eq 200
      expect(response.body['name']).to eq(engine_name)
      expect(response.body['type']).to eq('meta')
      expect(response.body['source_engines'].sort).to eq(['books', 'videogames'])
    end
  end
end
