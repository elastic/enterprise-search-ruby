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
  context 'Crawler Sitemap' do
    let(:engine_name) { 'crawler-sitemap' }
    let(:name) { 'https://www.elastic.co' }

    before do
      create_engine(engine_name)
      body = { name: name }
      response = client.create_crawler_domain(engine_name, body: body)
      @domain = response.body
    end

    after do
      client.delete_engine(engine_name)
    end

    it 'creates, updates and deletes a crawler sitemap configuration' do
      # Create a sitemap
      sitemap_url = 'https://www.elastic.co/sitemap.xml'
      body = { url: sitemap_url }
      response = client.create_crawler_sitemap(engine_name, domain_id: @domain['id'], body: body)
      expect(response.status).to eq 200
      expect(response.body.keys).to eq(['id', 'url', 'created_at'])
      expect(response.body['url']).to eq(sitemap_url)

      # Update a sitemap
      sitemap_id = response.body['id']
      sitemap_url = 'https://www.elastic.co/sitemap2.xml'
      body = { url: sitemap_url }
      response = client.put_crawler_sitemap(
        engine_name,
        domain_id: @domain['id'],
        sitemap_id: sitemap_id,
        body: body
      )
      expect(response.status).to eq 200
      expect(response.body.keys).to eq(['id', 'url', 'created_at'])
      expect(response.body['url']).to eq(sitemap_url)

      # Delete sitemap
      response = client.delete_crawler_sitemap(
        engine_name,
        domain_id: @domain['id'],
        sitemap_id: sitemap_id
      )

      expect(response.status).to eq 200
      expect(response.body).to eq({ 'deleted' => true })
    end
  end
end
