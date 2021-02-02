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
require_relative './api_spec_helper'

describe Elastic::EnterpriseSearch::AppSearch::Client do
  context 'schema' do
    let(:engine_name) { 'films' }

    it 'returns an engine schema' do
      VCR.use_cassette('app_search/api_schema') do
        response = @client.schema(engine_name)

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'title' => 'text', 'year' => 'number', 'director' => 'text' })
      end
    end

    it 'updates a schema for an engine' do
      VCR.use_cassette('app_search/api_put_schema') do
        response = @client.put_schema(engine_name, schema: { year: 'text' })

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'title' => 'text', 'year' => 'text', 'director' => 'text' })

        response = @client.schema(engine_name)
        expect(response.body).to eq({ 'title' => 'text', 'year' => 'text', 'director' => 'text' })
      end
    end
  end
end
