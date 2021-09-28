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
  let(:engine_name) { 'search-settings' }

  before do
    client.create_engine(name: engine_name)
  end

  after do
    delete_engines
  end

  context 'search settings' do
    it 'returns engine search settings' do
      response = client.search_settings(engine_name)

      expect(response.status).to eq 200
      expect(response.body['search_fields'])
      expect(response.body['result_fields'])
      expect(response.body['boosts'])
    end

    it 'updates search settings' do
      client.put_schema(engine_name, schema: { year: 'number' })
      documents = [
        { title: 'Attack of the Giant Leeches', year: 1959, director: 'Bernard L. Kowalski' },
        { title: '20,000 Leagues Under the Sea', year: 1916, director: 'Stuart Paton' },
        { title: 'Indestructible Man', year: 1956, director: 'Jack Pollexfen' },
        { title: 'Metropolis', year: 1927, director: 'Fritz Lang' }
      ]
      client.index_documents(engine_name, documents: documents)

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
      response = client.put_search_settings(engine_name, body: body)

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

    it 'resets search settings' do
      response = client.reset_search_settings(engine_name)

      expect(response.body['boosts']).to eq({})
      expect(response.status).to eq 200
    end
  end
end
