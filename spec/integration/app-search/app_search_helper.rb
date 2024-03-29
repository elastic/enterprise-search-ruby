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
require 'logger'

# App Search Integration tests Client Configuration
def client
  @client ||= Elastic::EnterpriseSearch::AppSearch::Client.new(
    host: ENV['ELASTIC_ENTERPRISE_HOST'] || 'http://localhost:3002',
    http_auth: {
      user: ENV['ELASTIC_ENTERPRISE_USER'] || 'enterprise_search',
      password: ENV['ELASTIC_ENTERPRISE_PASSWORD'] || 'changeme'
    }
  )
end

def delete_engines
  engines = client.list_engines.body['results']
  engines.each do |engine|
    client.delete_engine(engine['name'])
    # Gives time to the server to sync:
    sleep 2
  end
end

def create_engine(name)
  client.create_engine({ body: { name: name } })
rescue Elastic::Transport::Transport::Errors::BadRequest => e
  raise e unless e.message.match(/Name is already taken/)

  Logger.new($stdout).info("Engine '#{name}' had already been created, giving time for the server to sync.")
  sleep 5
  client.create_engine(name: name)
end
