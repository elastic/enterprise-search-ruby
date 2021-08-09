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

require 'spec_helper'

describe Elastic::EnterpriseSearch::WorkplaceSearch::Client do
  let(:host) { ENV['ELASTIC_ENTERPRISE_HOST'] || 'http://localhost:3002' }
  let(:http_auth) do
    {
      user: ENV['ELASTIC_ENTERPRISE_USER'] || 'enterprise_search',
      password: ENV['ELASTIC_ENTERPRISE_PASSWORD'] || 'changeme'
    }
  end
  let(:client) do
    Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(host: host, http_auth: http_auth)
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

  context 'Content Sources' do
    it 'creates, retrieves and deletes authenticated with basic auth' do
      # Create a content source and get its id
      response = client.create_content_source(name: 'test')
      expect(response.status).to eq 200
      expect(response.body['id'])
      id = response.body['id']

      # Test we get the content source information with get_content_source
      response = client.content_source(id)
      expect(response.status).to eq 200

      # List all content sources
      response = client.list_content_sources
      expect(response.status).to eq 200
      expect(response.body['results'].count).to be >= 1

      # Delete content source
      response = client.delete_content_source(id)
      expect(response.status).to eq 200
    end

    it 'creates and updates' do
      response = client.create_content_source(name: 'ruby_client_app')
      expect(response.status).to eq 200
      id = response.body['id']

      documents = [{ title: 'My first Document', body: 'Content', url: 'elastic.co' }]
      response = client.index_documents(id, documents: documents)
      expect(response.status).to eq 200

      new_name = 'ruby_client'
      body = {
        name: new_name,
        schema: { title: 'text', body: 'text', url: 'text' },
        display: { title_field: 'title', url_field: 'url', color: '#f00f00' },
        is_searchable: true
      }
      response = client.put_content_source(id, body: body)
      expect(response.status).to eq 200

      response = client.content_source(id)
      expect(response.status).to eq 200
      expect(response.body['name']) == new_name
    end
  end

  context 'Documents' do
    let(:content_source_id) do
      client.create_content_source(name: 'test').body['id']
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
    let(:content_source_id) { client.create_content_source(name: 'books').body['id'] }
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
  end

  context 'External Identities' do
    let(:content_source_id) { client.create_content_source(name: 'my_content').body['id'] }
    let(:user) { 'elastic_user' }
    let(:source_user_id) { 'example@elastic.co' }
    let(:body) do
      { user: user, source_user_id: source_user_id }
    end

    context 'Creates' do
      let(:source_user_id) { 'test@elastic.co' }
      let(:user) { 'test' }

      it 'creates an external identity' do
        response = client.create_external_identity(content_source_id, body: body)

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'source_user_id' => source_user_id, 'user' => user })

        client.delete_external_identity(content_source_id, user: user)
      end

      it 'creates and retrieves' do
        client.create_external_identity(content_source_id, body: body)
        response = client.external_identity(content_source_id, user: user)

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'source_user_id' => source_user_id, 'user' => user })
        client.delete_external_identity(content_source_id, user: user)
      end
    end

    context 'Lists' do
      let(:user) { 'lists_test' }

      it 'lists external identities' do
        client.create_external_identity(content_source_id, body: body)
        response = client.list_external_identities(content_source_id)

        expect(response.status).to eq 200
        expect(response.body['results']).to eq([{ 'source_user_id' => source_user_id, 'user' => user }])
        client.delete_external_identity(content_source_id, user: user)
      end
    end

    context 'Updates' do
      before do
        client.create_external_identity(content_source_id, body: body)
      end

      it 'updates an external identity' do
        body = { source_user_id: 'example2@elastic.co' }
        response = client.put_external_identity(content_source_id, user: user, body: body)

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'source_user_id' => 'example2@elastic.co', 'user' => user })
      end
    end

    context 'Deletes' do
      before do
        client.create_external_identity(content_source_id, body: body)
      end

      it 'deletes an external identity' do
        response = client.delete_external_identity(content_source_id, user: user)
        expect(response.status).to eq 200
        expect(response.body).to eq 'ok'
      end
    end
  end

  context 'Permissions' do
    let(:content_source_id) { client.create_content_source(name: 'my_content').body['id'] }
    let(:user) { 'enterprise_search' }
    let(:permissions) { ['permission1', 'permission2'] }

    after do
      client.put_user_permissions(content_source_id, { permissions: [], user: user })
    end

    it 'adds permissions to a user' do
      response = client.add_user_permissions(
        content_source_id,
        { permissions: permissions, user: user }
      )
      expect(response.status).to eq 200
      expect(response.body).to eq({ 'user' => 'enterprise_search', 'permissions' => ['permission1', 'permission2'] })
    end

    it 'removes permissions from a user' do
      client.add_user_permissions(content_source_id, { permissions: permissions, user: user })

      # Removes Permissions
      response = client.remove_user_permissions(
        content_source_id,
        { permissions: permissions, user: user }
      )
      expect(response.status).to eq 200
      expect(response.body).to eq({ 'user' => 'enterprise_search', 'permissions' => [] })
    end

    it 'lists permissions' do
      response = client.list_permissions(content_source_id)
      expect(response.status).to eq 200
    end

    it 'gets a user\'s permissions' do
      client.add_user_permissions(content_source_id, { permissions: permissions, user: user })
      response = client.user_permissions(content_source_id, { user: user })
      expect(response.status).to eq 200
      expect(response.body).to eq({ 'user' => 'enterprise_search', 'permissions' => permissions })
    end

    it 'updates a user\'s permissions' do
      permissions = ['testing', 'more', 'permissions']
      response = client.add_user_permissions(content_source_id, { permissions: permissions, user: user })
      expect(response.status).to eq 200
      expect(response.body).to eq({ 'user' => 'enterprise_search', 'permissions' => permissions })

      response = client.put_user_permissions(content_source_id, { permissions: [], user: user })
      expect(response.status).to eq 200
      expect(response.body).to eq({ 'user' => 'enterprise_search', 'permissions' => [] })
    end
  end

  context 'Synonym sets' do
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
      id = client.create_batch_synonym_sets(
        body: {
          synonym_sets: [
            { 'synonyms' => ['mouses', 'mice'] }
          ]
        }
      ).body['synonym_sets'].first['id']
      body = { synonyms: ['mouses', 'mice', 'luch'] }

      response = client.put_synonym_set(synonym_set_id: id, body: body)

      expect(response.status).to eq 200
      expect(response.body).to eq({ 'id' => id, 'synonyms' => ['mouses', 'mice', 'luch'] })
      client.delete_synonym_set(synonym_set_id: id)
    end
  end

  context 'Users' do
    it 'gets the current user' do
      response = client.current_user
      expect(response.status).to eq 200
      expect(response.body.keys).to eq ['email', 'username']
    end

    it 'gets the current user with an access token' do
      response = client.current_user(get_token: true)
      expect(response.status).to eq 200
      expect(response.body.keys).to eq ['email', 'username', 'access_token']
    end
  end
end
