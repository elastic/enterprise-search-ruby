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
  context 'Synonym sets' do
    after do
      delete_content_sources
    end

    let(:body) do
      {
        synonym_sets: [
          { 'synonyms' => ['house', 'home', 'abode'] },
          { 'synonyms' => ['cat', 'feline', 'kitty'] },
          { 'synonyms' => ['mouses', 'mice'] }
        ]
      }
    end

    it 'creates and deletes a batch synonym set' do
      response = client.create_batch_synonym_sets(body: body)

      expect(response.status).to eq 200
      expect(response.body['has_errors']).to eq false
      expect(response.body['synonym_sets'].count).to eq 3

      response.body['synonym_sets'].map { |s| client.delete_synonym_set(synonym_set_id: s['id']) }
    end

    it 'lists synonym sets' do
      client.create_batch_synonym_sets(body: body)
      response = client.list_synonym_sets

      expect(response.status).to eq 200
      expect(response.body['results'].count).to eq 3

      response.body['results'].map { |syn| client.delete_synonym_set(synonym_set_id: syn['id']) }
    end

    it 'gets a single synonym set' do
      id = client.create_batch_synonym_sets(
        body: {
          synonym_sets: [
            { 'synonyms' => ['house', 'home', 'abode'] }
          ]
        }
      ).body['synonym_sets'].first['id']

      response = client.synonym_set(synonym_set_id: id)
      expect(response.status).to eq 200
      expect(response.body['id']).to eq id
      expect(response.body['synonyms']).to eq ['house', 'home', 'abode']
      client.delete_synonym_set(synonym_set_id: id)
    end

    it 'updates a synonym set' do
      response = client.create_batch_synonym_sets(
        body: {
          synonym_sets: [
            { 'synonyms' => ['mouses', 'mice'] }
          ]
        }
      )
      id = response.body['synonym_sets'].first['id']
      body = { synonyms: ['mouses', 'mice', 'luch'] }

      response = client.put_synonym_set(synonym_set_id: id, body: body)

      expect(response.status).to eq 200
      expect(response.body).to eq({ 'id' => id, 'synonyms' => ['mouses', 'mice', 'luch'] })
      client.delete_synonym_set(synonym_set_id: id)
    end
  end
end
