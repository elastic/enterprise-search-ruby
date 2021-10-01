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
  context 'Crawler crawl requests' do
    let(:engine_name) { 'crawler-requests' }
    let(:name) { 'https://www.elastic.co' }

    before do
      create_engine(engine_name)
      body = { name: name }
      response = client.create_crawler_domain(engine_name, body: body)
      @domain = response.body
    end

    after do
      client.delete_crawler_active_crawl_request(engine_name)
      delete_engines
    end

    it 'creates, gets, lists and deletes a crawl request' do
      response = client.create_crawler_crawl_request(engine_name)

      expect(response.status).to eq 200
      expect(response.body.keys).to include('status')
      expect(response.body.keys).to include('id')
      request_id = response.body['id']

      # get crawl request
      response = client.crawler_crawl_request(engine_name, crawl_request_id: request_id)
      expect(response.status).to eq 200
      expect(response.body.keys).to include('status')
      expect(response.body.keys).to include('id')

      # get active crawl request details
      response = client.crawler_active_crawl_request(engine_name)
      expect(response.status).to eq 200
      expect(response.body.keys).to include('status')
      expect(response.body.keys).to include('id')

      attempts = 0
      while response.body['status'] != 'running' && attempts < 20
        sleep 1
        attempts += 1
        response = client.crawler_active_crawl_request(engine_name)
      end
      expect(response.body['status']).to eq 'running'

      # list crawl requests
      response = client.list_crawler_crawl_requests(engine_name)
      expect(response.status).to eq 200

      # delete active crawl request
      response = client.delete_active_crawl_request(engine_name)
      expect(response.status).to eq 200
    end

    it 'creates, starts and stops a crawl request' do
      response = client.create_crawler_crawl_request(engine_name)
      request_id = response.body['id']

      response = client.delete_crawler_active_crawl_request(engine_name)
      expect(response.status).to eq 200
      expect(response.body['id']).to eq request_id
      expect(response.body['status']).to eq('canceling')
    end
  end
end
