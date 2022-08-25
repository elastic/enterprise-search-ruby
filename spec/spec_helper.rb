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

require 'simplecov'
SimpleCov.start
require 'elastic/enterprise_search'
require 'rspec'
require 'vcr'

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.add_formatter('documentation')
  config.add_formatter('RspecJunitFormatter', 'enterprise-search-junit.xml')

  VCR.configure do |c|
    c.cassette_library_dir = 'spec/fixtures/vcr'
    c.hook_into :webmock
    c.allow_http_connections_when_no_cassette = true
  end
end

def is_faraday2?
  return false unless defined?(Faraday::VERSION)

  Gem::Version.new(Faraday::VERSION) >= Gem::Version.new(2)
end

def hide_constants
  hide_const('Faraday::Adapter::Patron')
  hide_const('Patron')
  hide_const('Faraday::Adapter::Typhoeus')
  hide_const('Typhoeus')
end

shared_examples 'adapters compatibility' do
  let(:transport_client) { instance_double(Elastic::Transport::Client) }
  let(:adapter) { client.transport.transport.connections.all.first.connection.builder.adapter }
  let(:client) { described_class.new }

  context 'default ' do
    it 'uses default NetHttp Faraday adapter' do
      hide_constants
      expect(adapter).to eq Faraday::Adapter::NetHttp
    end
  end

  context 'selecting adapter' do
    it 'uses Typhoeus when specified' do
      allow(Elastic::Transport::Client).to receive(:new).and_return({})
      described_class.new(adapter: :typhoeus)
      expect(Elastic::Transport::Client).to have_received(:new).with(hash_including(adapter: :typhoeus))
    end
  end
end
