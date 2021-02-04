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
  let(:content_source_id) { ENV['ELASTIC_WORKPLACE_SOURCE_ID'] || 'content_source_id' }
  let(:client) do
    Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(
      host: host
    )
  end

  context 'create analytics event' do
    it 'creates an event' do
      VCR.use_cassette('workplace_search/oauth_request_token') do
        client_id = 'client_id'
        client_secret = 'client_secret'
        redirect_uri = 'http://localhost:9393'

        # gets authorization code via  client.authorization_url(client_id, redirect_uri)
        authorization_code = 'authorization_code'
        @oauth_access_token = client.request_access_token(client_id, client_secret, authorization_code, redirect_uri)
      end

      VCR.use_cassette('workplace_search/create_analytics_event') do
        body = {
          type: 'click',
          query_id: 'search_query_id',
          document_id: 'document_id',
          page: 1,
          content_source_id: 'content_source_id',
          rank: 1,
          event: 'api'
        }

        response = client.create_analytics_event(access_token: @oauth_access_token, body: body)
        expect(response.status).to eq 200
      end
    end
  end
end
