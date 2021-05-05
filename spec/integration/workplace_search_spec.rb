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
end
