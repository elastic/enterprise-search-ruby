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

RSpec.configure do |config|
  config.before(:example) do
    @host = ENV['ELASTIC_ENTERPRISE_HOST'] || 'http://localhost:3002'
    @api_key = ENV['ELASTIC_APPSEARCH_API_KEY'] || 'api_key'
    @client = Elastic::EnterpriseSearch::AppSearch::Client.new(
      host: @host,
      http_auth: @api_key
    )
  end
end
