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
  context 'Engines' do
    let(:engine_name) { 'test-create-engines' }

    after do
      delete_engines
    end

    it 'creates a new engine' do
      response = client.create_engine(name: engine_name)

      expect(response.status).to eq 200
      expect(response.body).to eq(
        {
          'name' => engine_name,
          'type' => 'default',
          'language' => nil,
          'document_count' => 0
        }
      )
    end

    it 'lists engines' do
      client.create_engine(name: 'engine1')
      client.create_engine(name: 'engine2')

      response = client.list_engines
      expect(response.status).to eq 200

      expect(response.body.dig('meta', 'page', 'total_results')).to eq 2
      expect(response.body['results']).to include(
        { 'name' => 'engine1', 'type' => 'default', 'language' => nil, 'document_count' => 0 }
      )
      expect(response.body['results']).to include(
        { 'name' => 'engine2', 'type' => 'default', 'language' => nil, 'document_count' => 0 }
      )
    end

    it 'retrieves an engine by name' do
      engine_name = 'retrieve-engine'
      client.create_engine(name: engine_name)
      response = client.engine(engine_name)
      expect(response.status).to eq 200
      expect(response.body).to eq(
        { 'name' => engine_name, 'type' => 'default', 'language' => nil, 'document_count' => 0 }
      )
    end

    it 'deletes an engine' do
      engine_name = 'delete-engine'
      client.create_engine(name: engine_name)
      response = client.delete_engine(engine_name)
      expect(response.status).to eq 200
      expect(response.body).to eq({ 'deleted' => true })
    end
  end
end
