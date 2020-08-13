# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe Elastic::EnterpriseSearch::Client do
  let(:client) { Elastic::EnterpriseSearch::Client.new(http_auth: http_auth) }
  let(:response) { { 'status' => 'ok' } }
  let(:stub_response) { { body: response.to_json } }
  let(:host) { 'http://localhost:8080' }
  let(:http_auth) { { user: 'elastic', password: 'password' } }
  let(:user_agent) do
    [
      "#{Elastic::EnterpriseSearch::CLIENT_NAME}/#{Elastic::EnterpriseSearch::VERSION} ",
      "(RUBY_VERSION: #{RUBY_VERSION}; ",
      "#{RbConfig::CONFIG['host_os'].split('_').first[/[a-z]+/i].downcase} ",
      "#{RbConfig::CONFIG['target_cpu']})"
    ].join
  end

  let(:headers) do
    {
      'User-Agent' => user_agent,
      'Content-Type' => 'application/json',
      'Authorization' => 'Basic ZWxhc3RpYzpwYXNzd29yZA=='
    }
  end

  context 'builds request' do
    context 'get' do
      it 'builds the right request' do
        stub_request(:get, "#{host}/test")
          .with(query: { 'params' => 'test' }, headers: headers)
          .to_return(stub_response)

        expect(client.get('test', { 'params' => 'test' })).to eq(response)
      end
    end

    context 'delete' do
      it 'builds the right request' do
        stub_request(:delete, "#{host}/test")
          .with(query: { 'params' => 'test' }, headers: headers)
          .to_return(stub_response)

        expect(client.delete('test', { 'params' => 'test' })).to eq(response)
      end
    end

    context 'post' do
      it 'builds the right request' do
        stub_request(:post, "#{host}/test")
          .with(body: { 'params' => 'test' }, headers: headers)
          .to_return(stub_response)

        expect(client.post('test', { 'params' => 'test' })).to eq(response)
      end
    end

    context 'put' do
      it 'builds the right request' do
        stub_request(:put, "#{host}/test")
          .with(body: { 'params' => 'test' }, headers: headers)
          .to_return(stub_response)

        expect(client.put('test', { 'params' => 'test' })).to eq(response)
      end
    end
  end

  context 'with ssl' do
    let(:host) { 'https://localhost:3002/api/ws/v1' }

    before do
      client.endpoint = host
    end

    it 'sends the request correctly' do
      stub_request(:get, "#{host}/test")
        .with(query: { 'params' => 'test' }, headers: headers)
        .to_return(stub_response)

      expect(client.get('test', { 'params' => 'test' })).to eq(response)
    end
  end
end
# rubocop:enable Metrics/BlockLength
