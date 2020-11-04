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

describe Elastic::EnterpriseSearch::AppSearch::Client do
  let(:host) { ENV['ELASTIC_ENTERPRISE_HOST'] || 'http://localhost:3002' }
  let(:api_key) { ENV['ELASTIC_APPSEARCH_API_KEY'] || 'api_key' }
  let(:client) do
    Elastic::EnterpriseSearch::AppSearch::Client.new(
      host: host,
      http_auth: api_key
    )
  end

  context 'api_logs' do
    it 'returns api logs' do
      VCR.use_cassette('app_search/api_logs') do
        response = client.api_logs(
          'videogames',
          from_date: Date.new(2020, 10, 0o1),
          to_date: Date.new(2020, 11, 0o5)
        )
        expect(response.status).to eq 200
        expect(response.body['results'].count).to be > 1
      end
    end
  end
end
