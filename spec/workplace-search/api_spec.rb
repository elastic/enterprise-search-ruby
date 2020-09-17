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
  let(:access_token) { ENV['ELASTIC_WORKPLACE_TOKEN'] || 'access_token' }
  let(:content_source_key) { ENV['ELASTIC_WORKPLACE_SOURCE_KEY'] || 'content_source_key' }
  let(:client) do
    Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(
      host: host,
      access_token: access_token
    )
  end

  context 'documents' do
    let(:documents) do
      [
        { 'id' => '4e696e74656e646f203634',
          'url' => 'https://www.elastic.co/blog/introducing-quick-start-guides-getting-started-with-elastic-enterprise-search-for-free',
          'title' => 'Getting started with Elastic Enterprise Search for free',
          'body' => 'this is a test' },
        {
          'id' => '47616d6520426f7920436f6c6f72',
          'url' => 'https://www.elastic.co/workplace-search',
          'title' => 'One-stop answer shop for the virtual workplace',
          'body' => 'this is also a test'
        }
      ]
    end

    it 'indexes' do
      VCR.use_cassette(:index_documents) do
        response = client.index_documents(content_source_key, documents)

        expect(response.status).to eq 200
        expect(response.body)
          .to eq(
            { 'results' =>
              [
                { 'id' => '4e696e74656e646f203634', 'errors' => [] },
                { 'id' => '47616d6520426f7920436f6c6f72', 'errors' => [] }
              ] }
          )
      end
    end

    it 'deletes' do
      VCR.use_cassette(:index_documents) do
        client.index_documents(content_source_key, documents)
      end

      VCR.use_cassette(:delete_documents) do
        response = client.delete_documents(content_source_key, documents.map { |doc| doc['id'] })
        expect(response.status).to eq 200
        expect(response.body)
          .to eq(
            { 'results' =>
              [
                { 'id' => '4e696e74656e646f203634', 'success' => true },
                { 'id' => '47616d6520426f7920436f6c6f72', 'success' => true }
              ] }
          )
      end
    end
  end

  context 'permissions' do
    let(:user) { 'enterprise_search' }

    it 'lists permissions' do
      VCR.use_cassette(:list_permissions) do
        response = client.list_permissions(content_source_key)

        expect(response.status).to eq 200

        expect(response.body)
          .to eq(
            { 'meta' =>
              { 'page' => { 'current' => 1, 'total_pages' => 1, 'total_results' => 1, 'size' => 25 } }, 'results' => [
                { 'user' => 'enterprise_search', 'permissions' => [] }
              ] }
          )
      end
    end

    it 'gets user permissions' do
      clear_user_permissions

      VCR.use_cassette(:user_permissions_empty) do
        response = client.user_permissions(content_source_key, { user: user })

        expect(response.status).to eq 200

        expect(response.body)
          .to eq(
            { 'user' => 'enterprise_search', 'permissions' => [] }
          )
      end
    end

    def clear_user_permissions
      VCR.use_cassette(:clear_user_permissions) do
        client.put_user_permissions(
          content_source_key,
          { permissions: [] },
          { user: user }
        )
      end
    end

    it 'updates user permissions' do
      VCR.use_cassette(:put_user_permissions) do
        response = client.add_user_permissions(
          content_source_key,
          { permissions: ['testing', 'more', 'permissions'] },
          { user: user }
        )

        expect(response.status).to eq 200

        expect(response.body)
          .to eq(
            { 'user' => 'enterprise_search', 'permissions' => ['testing', 'more', 'permissions'] }
          )

        response = client.put_user_permissions(
          content_source_key,
          { permissions: [] },
          { user: user }
        )

        expect(response.status).to eq 200

        expect(response.body)
          .to eq(
            { 'user' => 'enterprise_search', 'permissions' => [] }
          )
      end
    end

    it 'adds and removes permissions from a user' do
      VCR.use_cassette(:add_user_permissions) do
        permissions = ['permission1', 'permission2']
        response = client.add_user_permissions(
          content_source_key,
          { permissions: permissions },
          { user: user }
        )

        expect(response.status).to eq 200

        expect(response.body)
          .to eq(
            { 'user' => 'enterprise_search', 'permissions' => ['permission1', 'permission2'] }
          )
      end

      VCR.use_cassette(:remove_user_permissions) do
        permissions = ['permission1', 'permission2']
        response = client.remove_user_permissions(
          content_source_key,
          { permissions: permissions },
          { user: user }
        )

        expect(response.status).to eq 200

        expect(response.body)
          .to eq(
            { 'user' => 'enterprise_search', 'permissions' => [] }
          )
      end
    end
  end
end
