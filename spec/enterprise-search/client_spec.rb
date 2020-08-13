# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
describe Elastic::EnterpriseSearch::Client do
  let(:endpoint) { 'https://localhost:8080' }
  let(:http_auth) { { user: 'elasticenterprise', password: 'password' } }

  context 'initialization' do
    it 'sets up options' do
      client = Elastic::EnterpriseSearch::Client.new(
        endpoint: endpoint
      )
      expect(client.endpoint).to eq endpoint
    end
  end

  context 'basic authentication' do
    it 'sets up authentication on initialization' do
      client = Elastic::EnterpriseSearch::Client.new(
        http_auth: http_auth
      )
      expect(client.http_auth).to eq http_auth
    end

    it 'sets authentication after initialization' do
      http_auth = { user: 'test', password: 'testing' }
      client = Elastic::EnterpriseSearch::Client.new
      client.http_auth = http_auth
      expect(client.http_auth).to eq http_auth
    end
  end

  context 'workplace search instantiation from enterprise search' do
    let(:client) { Elastic::EnterpriseSearch::Client.new(endpoint: endpoint) }

    it 'instantiates workplace search with default endpoint' do
      expect(client.workplace_search.endpoint).to eq endpoint
    end
  end
end
# rubocop:enable Metrics/BlockLength
