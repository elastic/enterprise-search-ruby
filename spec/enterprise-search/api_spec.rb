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

describe Elastic::EnterpriseSearch::Client do
  let(:host) { ENV['ENTERPRISE_HOST'] || 'localhost:8080' }
  let(:http_auth) { { user: 'elastic', password: ENV['ENTERPRISE_PASSWORD'] || 'changeme' } }
  let(:client) do
    Elastic::EnterpriseSearch::Client.new(host: host, http_auth: http_auth)
  end

  context 'API' do
    context 'health' do
      it 'makes GET request' do
        VCR.use_cassette(:health) do
          response = client.health

          expect(response.status).to eq 200
          expect(response.body['name']).to be_a(String)
          expect(response.body['version']).to have_key('number')
          expect(response.body['jvm']).to have_key('gc')
          expect(response.body['system']).to have_key('os_name')
        end
      end
    end

    context 'read only' do
      it 'makes GET request' do
        VCR.use_cassette(:read_only) do
          response = client.read_only

          expect(response.status).to eq 200
          expect(response.body).to have_key('enabled')
        end
      end
    end

    context 'put_read_only' do
      it 'makes PUT request with enabled: true' do
        VCR.use_cassette(:read_only_put_true) do
          response = client.put_read_only(enabled: true)

          expect(response.status).to eq 200
          expect(response.body).to have_key('enabled')
          expect(response.body['enabled'])
        end
      end

      it 'makes PUT request with enabled: false' do
        VCR.use_cassette(:read_only_put_false) do
          response = client.put_read_only(enabled: false)

          expect(response.status).to eq 200
          expect(response.body).to have_key('enabled')
          expect(response.body['enabled']).to eq false
        end
      end
    end

    context 'stats' do
      it 'makes GET request' do
        VCR.use_cassette(:stats) do
          response = client.stats

          expect(response.status).to eq 200
          expect(response.body).to have_key('app')
          expect(response.body).to have_key('queues')
          expect(response.body).to have_key('connectors')
        end
      end
    end

    context 'version' do
      it 'makes GET request' do
        VCR.use_cassette(:version) do
          response = client.version

          expect(response.status).to eq 200
          expect(response.body).to have_key('number')
          expect(response.body).to have_key('build_hash')
          expect(response.body).to have_key('build_date')
        end
      end
    end
  end
end
