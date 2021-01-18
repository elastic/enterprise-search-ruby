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
  context 'search settings' do
    let(:engine_name) { 'films' }

    it 'returns engine search settings' do
      VCR.use_cassette('app_search/api_search_settings') do
        response = @client.search_settings(engine_name)

        expect(response.status).to eq 200
        expect(response.body['search_fields'])
        expect(response.body['result_fields'])
        expect(response.body['boosts'])
      end
    end

    it 'updates search settings' do
      VCR.use_cassette('app_search/api_put_search_settings') do
        body = {
          boosts: {
            year: [
              {
                type: 'proximity',
                function: 'linear',
                center: 1950,
                factor: 9
              }
            ]
          }
        }
        response = @client.put_search_settings(engine_name, body: body)

        expect(response.status).to eq 200
        expect(response.body['boosts']).to eq(
          {
            'year' => [
              { 'type' => 'proximity',
                'function' => 'linear',
                'center' => 1950,
                'factor' => 9 }
            ]
          }
        )
      end
    end
  end
end
