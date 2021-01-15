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
  context 'curations' do
    let(:engine_name) { 'books' }

    it 'creates a new curation' do
      VCR.use_cassette('app_search/create_curation') do
        response = @client.create_curation(
          engine_name,
          queries: ['jungle'],
          promoted: ['doc-600070f60e9e05e6b7037721'],
          hidden: ['doc-600070f60e9e05e6b7037729']
        )
        expect(response.status).to eq 200
        expect(response.body['id']).to match(/cur-[0-9a-f]+/)

        response = @client.search(engine_name, query: 'jungle')
        expect(response.status).to eq 200
        expect(response.body['results'].count).to eq 1
        expect(response.body['results'].first['title']['raw']).to eq 'Jungle Tales'
      end
    end

    it 'retrieves a curation by id' do
      VCR.use_cassette('app_search/get_curation') do
        response = @client.curation(engine_name, curation_id: 'cur-600202fa0e9e05e6b7037753')

        expect(response.status).to eq 200
        expect(response.body['id']).to match(/cur-[0-9a-f]+/)
        expect(response.body['queries']).to eq ['jungle']
        expect(response.body['promoted']).to eq ['doc-600070f60e9e05e6b7037721']
        expect(response.body['hidden']).to eq ['doc-600070f60e9e05e6b7037729']
      end
    end

    it 'updates an existing curation' do
      VCR.use_cassette('app_search/put_curation') do
        response = @client.put_curation(
          engine_name,
          curation_id: 'cur-600202fa0e9e05e6b7037753',
          queries: ['jungle'],
          promoted: ['doc-600070f60e9e05e6b7037729'],
          hidden: ['doc-600070f60e9e05e6b7037721']
        )

        expect(response.status).to eq 200
        expect(response.body['id']).to match(/cur-[0-9a-f]+/)

        response = @client.search(engine_name, query: 'jungle')
        expect(response.status).to eq 200
        expect(response.body['results'].count).to eq 1
        expect(response.body['results'].first['title']['raw']).to eq 'The Jungle Book'
      end
    end

    it 'lists curations' do
      VCR.use_cassette('app_search/list_curations') do
        response = @client.list_curations(engine_name)

        expect(response.status).to eq 200
        expect(response.body['results'].count).to eq 1
        curation = response.body['results'].first
        expect(curation['id']).to match(/cur-[0-9a-f]+/)
        expect(curation['queries']).to eq ['jungle']
      end
    end

    it 'deletes a curation' do
      VCR.use_cassette('app_search/delete_curation') do
        response = @client.delete_curation(engine_name, curation_id: 'cur-6002097c0e9e053992037769')

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'deleted' => true })
      end
    end
  end
end
