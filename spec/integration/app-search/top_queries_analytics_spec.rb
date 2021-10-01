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
  let(:engine_name) { 'top-queries-analytics' }

  before do
    create_engine(engine_name)
  end

  after do
    delete_engines
  end

  context 'top queries analytics' do
    it 'returns api_top_queries_analytics with no query' do
      response = @client.top_queries_analytics(engine_name)
      expect(response.status).to eq 200

      expect(response.body['results'])
      expect(response.body['meta'])
    end
  end
end
