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
  context 'Permissions' do
    let(:content_source_id) { client.create_content_source(name: 'my_content').body['id'] }
    let(:user) { 'enterprise_search' }
    let(:permissions) { ['permission1', 'permission2'] }

    after do
      client.put_user_permissions(content_source_id, { permissions: [], user: user })
      delete_content_sources
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
end
