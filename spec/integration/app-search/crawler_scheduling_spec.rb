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
  context 'Crawler scheduling' do
    let(:engine_name) { 'crawler-scheduling' }
    let(:body) { { frequency: 1, unit: 'day' } }
    let(:name) { 'https://www.elastic.co' }

    before do
      attempts = 0
      loop do
        attempts += 1
        client.create_engine(name: engine_name)
        break if attempts > 9
      rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
        if e.message.match?(/Name is already taken/)
          sleep 1
          next
        end
      else
        break
      end
      body = { name: name }
      response = client.create_crawler_domain(engine_name, body: body)
      @domain = response.body
    end

    after do
      client.delete_engine(engine_name)
    end

    it 'sets a crawl schedule' do
      response = client.put_crawler_crawl_schedule(engine_name, body: body)
      expect(response.status).to eq 200
      expect(response.body).to eq({
                                    'engine' => engine_name,
                                    'frequency' => 1,
                                    'unit' => 'day'
                                  })
    end

    it 'gets the crawl schedule' do
      client.put_crawler_crawl_schedule(engine_name, body: body)

      response = client.crawler_crawl_schedule(engine_name)
      expect(response.status).to eq 200
      expect(response.body).to eq({
                                    'engine' => engine_name,
                                    'frequency' => 1,
                                    'unit' => 'day'
                                  })
    end

    it 'deletes a crawler crawl schedule' do
      client.put_crawler_crawl_schedule(engine_name, body: body)

      response = client.delete_crawler_crawl_schedule(engine_name)
      expect(response.status).to eq 200
      expect(response.body).to eq({ 'deleted' => true })
    end
  end
end
