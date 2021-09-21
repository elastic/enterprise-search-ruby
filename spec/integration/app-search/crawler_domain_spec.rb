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
  context 'Crawler Domain' do
    let(:engine_name) { 'crawler' }
    let(:name) { 'https://www.elastic.co' }

    before do
      client.create_engine(name: engine_name)
    end

    after do
      client.delete_crawler_domain(engine_name, domain_id: @domain['id'])
      client.delete_engine(engine_name)
      sleep 1
    end

    it 'creates and gets a crawler domain' do
      body = { name: name }
      response = client.create_crawler_domain(engine_name, body: body)
      @domain = response.body

      expect(response.status).to eq 200
      expect(response.body['id']).to eq @domain['id']
      expect(response.body).to include('name' => name)

      # client.crawler_domain
      response = client.crawler_domain(engine_name, domain_id: @domain['id'])
      expect(response.status).to eq 200
      expect(response.body['id']).to eq @domain['id']
      expect(response.body).to include('name' => name)
    end

    it 'creates and updates a crawler domain' do
      body = { name: name }
      response = client.create_crawler_domain(engine_name, body: body)
      @domain = response.body

      expect(response.status).to eq 200
      expect(response.body['id']).to eq @domain['id']
      expect(response.body).to include('name' => name)

      new_name = 'https://www.wikipedia.org'
      body = { name: new_name }
      response = client.put_crawler_domain(engine_name, domain_id: @domain['id'], domain: body)

      expect(response.status).to eq 200
      expect(response.body['id']).to eq @domain['id']
      expect(response.body).to include('name' => new_name)
    end

    it 'validates a domain' do
      body = { name: name }
      @domain = client.create_crawler_domain(engine_name, body: body).body
      body = { url: name }
      response = client.crawler_domain_validation_result(body: body)

      expect(response.status).to eq 200
      expect(response.body['url']).to eq name
      expect(response.body['valid']).to eq true
    end
  end
end
