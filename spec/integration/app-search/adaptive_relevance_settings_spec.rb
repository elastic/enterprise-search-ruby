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
  context 'Adaptive Relevance Settings' do
    let(:engine_name) { 'relevance-settings' }

    before do
      create_engine(engine_name)
      client.put_adaptive_relevance_settings(engine_name, body: { curation: { enabled: true } })
    end

    after do
      delete_engines
    end

    it 'Shows the settings for an engine' do
      response = client.adaptive_relevance_settings(engine_name)

      expect(response.status).to eq 200
      expect(response.body['curation'])
    end

    it 'Updates relevance settings' do
      body = {
        curation: { enabled: true }
      }
      response = client.put_adaptive_relevance_settings(engine_name, body: body)
      expect(response.status).to eq 200
      expect(response.body['curation']['enabled'])
    end

    it 'Refreshes adaptive relevance update process' do
      response = client.refresh_adaptive_relevance_update_process(
        engine_name,
        adaptive_relevance_suggestion_type: 'curation'
      )
      expect(response.status).to eq 200
      expect(response.body['process']['type']).to eq 'curation'
    end
  end
end
