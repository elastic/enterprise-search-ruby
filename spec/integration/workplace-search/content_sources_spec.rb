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
  context 'Content Sources' do
    after do
      delete_content_sources
    end

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

    it 'syncs jobs' do
      response = client.create_content_source(name: 'sync_jobs_test')
      expect(response.status).to eq 200
      id = response.body['id']

      response = client.command_sync_jobs(id, body: { command: 'interrupt' })
      expect(response.status).to eq 200
      expect(response.body['results'].keys).to eq ['interrupted']
    end

    context 'Icons' do
      let(:content_source_id) { client.create_content_source(name: 'with-icon').body['id'] }

      it 'puts an icon' do
        path = File.expand_path("#{File.dirname(__FILE__)}/icon.png")
        icon = Base64.strict_encode64(File.read(path))
        response = client.put_content_source_icons(content_source_id, main_icon: icon, alt_icon: icon)
        expect(response.status).to eq 200
        expect(response.body['results']).to eq({ 'main_icon' => 'success', 'alt_icon' => 'success' })
      end
    end
  end
end
