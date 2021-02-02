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
  let(:engine_name) { 'new-meta-engine' }

  # TODO: Once we stop using VCR, we need to do create / list / destroy engines

  context 'meta engines' do
    it 'creates a meta engine' do
      VCR.use_cassette('app_search/create_meta_engine') do
        body = {
          name: engine_name,
          type: 'meta',
          source_engines: ['books', 'videogames']
        }
        response = @client.create_engine(name: engine_name, body: body)

        expect(response.status).to eq 200
        expect(response.body['name']).to eq('new-meta-engine')
        expect(response.body['type']).to eq('meta')
        expect(response.body['source_engines'].sort).to eq(['books', 'videogames'])
        expect(response.body['document_count']).to be > 1
      end
    end

    it 'adds a new source engine to a meta engine' do
      VCR.use_cassette('app_search/add_meta_engine_source') do
        # Create new source engine to add:
        @client.create_engine(name: 'comicbooks')

        response = @client.add_meta_engine_source(engine_name, source_engines: ['comicbooks'])

        expect(response.status).to eq 200
        expect(response.body['name']).to eq('new-meta-engine')
        expect(response.body['type']).to eq('meta')
        expect(response.body['source_engines'].sort).to eq(['books', 'comicbooks', 'videogames'])
        expect(response.body['document_count']).to be > 1
      end
    end

    it 'removes a source engine from a meta engine' do
      VCR.use_cassette('app_search/delete_meta_engine_source') do
        response = @client.delete_meta_engine_source(engine_name, source_engines: ['videogames'])

        expect(response.status).to eq 200
        expect(response.body['name']).to eq('new-meta-engine')
        expect(response.body['type']).to eq('meta')
        expect(response.body['source_engines'].sort).to eq(['books', 'comicbooks'])
        expect(response.body['document_count']).to be > 1
      end
    end
  end
end
