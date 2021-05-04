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
  let(:http_auth) do
    {
      user: ENV['ELASTIC_ENTERPRISE_USER'] || 'enterprise_search',
      password: ENV['ELASTIC_ENTERPRISE_PASSWORD'] || 'changeme'
    }
  end
  let(:client) do
    Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(host: host, http_auth: http_auth)
  end

  it 'creates a content source authenticated with basic auth' do
    response = client.create_content_source(name: 'test')
    expect(response.status).to eq 200
    expect(response.body['id'])
  end
end
