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
  context 'Crawler process crawl denied URLs' do
    let(:engine_name) { 'crawler-process-crawl-denied-urls' }
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

    it 'retrieves denied urls for process crawl' do
      response = client.create_crawler_process_crawl(engine_name, body: { dry_run: true })
      id = response.body['id']

      response = client.crawler_process_crawl_denied_urls(engine_name, process_crawl_id: id)
      expect(response.status).to eq 200
      expect(
        response.body.keys &
        ['total_url_count', 'denied_url_count', 'sample_size', 'denied_urls_sample']
      ).to eq response.body.keys
    end
  end
end
