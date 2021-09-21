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
  context 'Crawler crawl rules' do
    let(:engine_name) { 'crawler-crawl-rule' }
    let(:name) { 'https://www.elastic.co' }

    before do
      client.create_engine(name: engine_name)
      body = { name: name }
      response = client.create_crawler_domain(engine_name, body: body)
      @domain = response.body
    end

    after do
      client.delete_engine(engine_name)
    end

    it 'creates, updates and deletes a rule' do
      # Create a crawler crawl rule
      body = { order: 1, policy: 'allow', rule: 'contains', pattern: '/stack' }
      response = client.create_crawler_crawl_rule(engine_name, domain_id: @domain['id'], body: body)
      expect(response.status).to eq 200
      rule_id = response.body['id']
      expect(response.body['order']).to eq 1
      expect(response.body['policy']).to eq 'allow'
      expect(response.body['rule']).to eq 'contains'
      expect(response.body['pattern']).to eq '/stack'

      # Update a crawler crawl rule
      body = { order: 2, policy: 'allow', rule: 'begins', pattern: '/stack' }
      response = client.put_crawler_crawl_rule(
        engine_name,
        domain_id: @domain['id'],
        crawl_rule_id: rule_id,
        body: body
      )
      expect(response.status).to eq 200
      expect(response.body['order']).to eq 2
      expect(response.body['policy']).to eq 'allow'
      expect(response.body['rule']).to eq 'begins'
      expect(response.body['pattern']).to eq '/stack'

      # Delete a crawler crawl rule
      response = client.delete_crawler_crawl_rule(
        engine_name,
        domain_id: @domain['id'],
        crawl_rule_id: rule_id
      )
      expect(response.status).to eq 200
      expect(response.body).to eq({ 'deleted' => true })
    end
  end
end
