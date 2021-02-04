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

describe Elastic::EnterpriseSearch::WorkplaceSearch::Client do
  let(:host) { ENV['ELASTIC_ENTERPRISE_HOST'] || 'http://localhost:3002' }
  let(:access_token) { ENV['ELASTIC_WORKPLACE_TOKEN'] || 'access_token' }
  let(:content_source_id) { ENV['ELASTIC_WORKPLACE_SOURCE_ID'] || 'content_source_id' }
  let(:client) do
    Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(
      host: host,
      http_auth: access_token
    )
  end

  it 'goes through the search OAuth ' do
    VCR.use_cassette('workplace_search/oauth_request_access_token_for_search') do
      client_id = 'client_id'
      client_secret = 'client_secret'
      redirect_uri = 'http://localhost:9393'

      # gets authorization code via  client.authorization_url(client_id, redirect_uri)
      authorization_code = 'authorization_code'

      access_token = client.request_access_token(client_id, client_secret, authorization_code, redirect_uri)

      response = client.search(body: {query: '1984'}, access_token: access_token)
      expect(response.status).to eq 200
      expect(response.body['results'].count).to be > 1
      expect(response.body['results'][0]['title']['raw']).to eq '1984'
      expect(response.body['results'][0]['author']['raw']).to eq 'George Orwell'
    end
  end
end
