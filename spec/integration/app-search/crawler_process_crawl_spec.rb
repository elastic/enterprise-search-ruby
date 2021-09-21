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
  context 'Crawler Process Crawl' do
    let(:engine_name) { 'crawler-urls' }
    let(:name) { 'https://www.elastic.co' }

    before do
      client.create_engine(name: engine_name)
      body = { name: name }
      response = client.create_crawler_domain(engine_name, body: body)
      @domain = response.body
    end

    after do
      client.delete_engine(engine_name)
      sleep 1
    end

    it 'creates, retrieves and shows denied for a process crawl' do
      response = client.create_crawler_process_crawl(engine_name, body: { dry_run: true })
      expect(response.status).to eq 200

      id = response.body['id']
      expect(response.body['dry_run']).to eq true
      expect(response.body['domains']).to eq(['https://www.elastic.co'])

      response = client.crawler_process_crawl(engine_name, process_crawl_id: id)
      expect(response.status).to eq 200
      expect(response.body['dry_run']).to eq true
      expect(response.body['domains']).to eq(['https://www.elastic.co'])

      response = client.denied_urls(engine_name, process_crawl_id: id)
      expect(response.status).to eq 200
      expect(response.body.keys).to eq(['total_url_count', 'denied_url_count', 'sample_size', 'denied_urls_sample'])
    end

    it 'lists process crawls' do
      client.create_crawler_process_crawl(engine_name, body: { dry_run: true })
      client.create_crawler_process_crawl(engine_name, body: { dry_run: true })

      response = client.list_crawler_process_crawls(engine_name)
      expect(response.status).to eq 200
      expect(response.body.count).to be 2
    end
  end
end
