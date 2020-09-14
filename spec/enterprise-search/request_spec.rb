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
require 'ostruct'
require_relative './../webmock_requires'

describe Elastic::EnterpriseSearch::Client do
  let(:client) { Elastic::EnterpriseSearch::Client.new(http_auth: http_auth) }
  let(:stub_response) { OpenStruct.new(status: 200) }
  let(:host) { 'http://localhost:8080' }
  let(:http_auth) { { user: 'elastic', password: 'password' } }
  let(:user_agent) do
    [
      "#{Elastic::EnterpriseSearch::CLIENT_NAME}/#{Elastic::EnterpriseSearch::VERSION} ",
      "(RUBY_VERSION: #{RUBY_VERSION}; ",
      "#{RbConfig::CONFIG['host_os'].split('_').first[/[a-z]+/i].downcase} ",
      "#{RbConfig::CONFIG['target_cpu']}; ",
      "elasticsearch-transport: #{Elasticsearch::Transport::VERSION})"
    ].join
  end

  let(:headers) do
    {
      'Authorization' => 'Basic ZWxhc3RpYzpwYXNzd29yZA==',
      'Content-Type' => 'application/json',
      'User-Agent' => user_agent
    }
  end

  context 'builds request' do
    context 'get' do
      it 'builds the right request' do
        stub_request(:get, "#{host}/test")
          .with(
            query: { 'params' => 'test' },
            headers: headers
          ).to_return(stub_response)

        expect(client.get('test', params: 'test').status).to eq(200)
      end
    end

    context 'delete' do
      it 'builds the right request' do
        stub_request(:delete, "#{host}/test")
          .with(
            query: { 'params' => 'test' },
            headers: headers
          ).to_return(stub_response)

        expect(client.delete('test', params: 'test').status).to eq(200)
      end
    end

    context 'post' do
      it 'builds the right request' do
        stub_request(:post, "#{host}/test")
          .with(
            body: { some: 'value' },
            headers: headers
          ).to_return(stub_response)

        expect(client.post('test', {}, { some: 'value' }).status).to eq(200)
      end
    end

    context 'put' do
      it 'builds the right request' do
        stub_request(:put, "#{host}/test")
          .with(body: { 'params' => 'test' }, headers: headers)
          .to_return(stub_response)

        expect(client.put('test', {}, { 'params' => 'test' }).status).to eq(200)
      end
    end
  end

  context 'with ssl' do
    let(:host) { 'https://localhost:3002/api/ws/v1' }
    let(:client) do
      Elastic::EnterpriseSearch::Client.new(
        http_auth: http_auth,
        host: host
      )
    end

    it 'sends the request correctly' do
      stub_request(:get, "#{host}/test")
        .with(
          query: { 'params' => 'test' },
          headers: headers
        ).to_return(stub_response)

      expect(client.get('test', { 'params' => 'test' }).status).to eq(200)
    end
  end
end
