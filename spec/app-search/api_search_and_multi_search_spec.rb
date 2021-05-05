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

require_relative './api_spec_helper'

describe Elastic::EnterpriseSearch::AppSearch::Client do
  let(:engine_name) { 'books' }

  context 'single search' do
    it 'performs a single query search' do
      VCR.use_cassette('app_search/single_query_search') do
        response = @client.search(engine_name, query: 'Herman')
        expect(response.status).to eq 200
        expect(response.body).not_to be nil
        expect(response.body['results'].count).to be > 1
      end
    end
  end

  context 'multi query search' do
    it 'performs a multi query search' do
      VCR.use_cassette('app_search/multi_query_search') do
        response = @client.multi_search('books', body: [{ query: 'Herman' }, { query: 'Edgar' }])
        expect(response.status).to eq 200
        expect(response.body.class).to be Array
        expect(response.body.count).to be 2
        expect(response.body[0]['results']).to_not be nil
        expect(response.body[1]['results']).to_not be nil
      end
    end
  end
end
