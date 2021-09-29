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

require_relative "#{__dir__}/workplace_search_helper.rb"

describe Elastic::EnterpriseSearch::WorkplaceSearch::Client do
  context 'Triggers' do
    it 'gets and updates triggers blocklist' do
      response = client.triggers_blocklist
      expect(response.status).to eq 200
      expect(response.body['blocklist']).not_to be_empty
      original_list = response.body['blocklist']

      # Add a term to the block list and check it's been changed
      response = client.put_triggers_blocklist(body: { blocklist: original_list + ['tests'] })
      expect(response.status).to eq 200
      expect(response.body['blocklist']).to eq(original_list + ['tests'])
      response = client.triggers_blocklist
      expect(response.body['blocklist']).to eq(original_list + ['tests'])

      # Restored original list
      response = client.put_triggers_blocklist(body: { blocklist: original_list })
      expect(response.status).to eq 200
      expect(response.body['blocklist']).to eq(original_list)
    end
  end
end
