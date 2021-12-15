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
  context 'Adaptive Relevance' do
    let(:engine_name) { 'adaptive-relevance' }

    before do
      create_engine(engine_name)
    end

    after do
      delete_engines
    end

    it 'retrieves adaptive relevance settings' do
      response = client.adaptive_relevance_settings(engine_name)
      expect(response.body['curation'])
      expect(response.status).to eq 200
    end

    it 'updates settings and lists adaptive relevance for an engine' do
      body = {
        curation: {
          enabled: true
        }
      }
      # Enables curations
      response = client.put_adaptive_relevance_settings(engine_name, body: body)
      expect(response.status).to eq 200
      expect(response.body.dig('curation', 'enabled'))

      # Lists suggestions
      response = client.list_adaptive_relevance_suggestions(engine_name)
      expect(response.status).to eq 200
      expect(response.body['meta'])
      expect(response.body['results'])
    end
  end
end
