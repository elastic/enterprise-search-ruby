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
  let(:engine_name) { 'synonyms' }

  before do
    create_engine(engine_name)
  end

  after do
    delete_engines
  end

  context 'Synonyms' do
    it 'creates a synonym set' do
      response = client.create_synonym_set(engine_name, body: { synonyms: ['joypad', 'gamepad'] })

      expect(response.status).to eq 200
      expect(response.body['synonyms'].sort).to eq ['gamepad', 'joypad']
      expect(response.body['id'])
    end

    it 'lists synonym sets' do
      client.create_synonym_set(engine_name, body: { synonyms: ['joypad', 'gamepad'] })
      response = client.list_synonym_sets(engine_name)

      expect(response.status).to eq 200
      expect(response.body['results'].count).to be > 0
      expect(response.body['results'].first['synonyms'].sort).to eq ['gamepad', 'joypad']
    end

    it 'retrieves a synonym set by ID' do
      id = client.create_synonym_set(engine_name, body: { synonyms: ['joypad', 'gamepad'] }).body['id']
      response = client.synonym_set(engine_name, synonym_set_id: id)

      expect(response.status).to eq 200
      expect(response.body).to eq({ 'id' => id, 'synonyms' => ['joypad', 'gamepad'] })
    end

    it 'updates a synonym set' do
      id = client.create_synonym_set(engine_name, body: { synonyms: ['joypad', 'gamepad'] }).body['id']
      response = client.put_synonym_set(
        engine_name,
        synonym_set_id: id,
        body: { synonyms: ['gamepad', 'controller'] }
      )

      expect(response.status).to eq 200
      expect(response.body).to eq({ 'id' => id, 'synonyms' => ['gamepad', 'controller'] })
    end

    it 'deletes a synonym set' do
      id = client.create_synonym_set(engine_name, body: { synonyms: ['joypad', 'gamepad'] }).body['id']
      response = @client.delete_synonym_set(engine_name, synonym_set_id: id)

      expect(response.status).to eq 200
      expect(response.body).to eq({ 'deleted' => true })
    end
  end
end
