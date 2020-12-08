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
  let(:engine_name) { 'videogames' }

  # TODO: Once we stop using VCR, we need to do create / list / destroy engines

  context 'engines' do
    it 'creates an engine' do
      VCR.use_cassette('app_search/create_engine') do
        response = @client.create_engine(name: 'videogames')

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'name' => 'videogames', 'type' => 'default', 'language' => nil })
      end
    end

    it 'lists engines' do
      VCR.use_cassette('app_search/list_engines') do
        response = @client.list_engines

        expect(response.status).to eq 200
        expect(response.body).to eq(
          { 'meta' => { 'page' => { 'current' => 1, 'total_pages' => 1, 'total_results' => 1, 'size' => 25 } },
            'results' => [{ 'name' => 'videogames', 'type' => 'default', 'language' => nil }] }
        )
      end
    end

    it 'retrieves an engine by name' do
      VCR.use_cassette('app_search/get_engine') do
        response = @client.engine('videogames')

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'name' => 'videogames', 'type' => 'default', 'language' => nil })
      end
    end

    it 'deletes an engine' do
      VCR.use_cassette('app_search/delete_engine') do
        response = @client.delete_engine('videogames')

        expect(response.status).to eq 200
        expect(response.body).to eq({ 'deleted' => true })
      end
    end
  end
end
