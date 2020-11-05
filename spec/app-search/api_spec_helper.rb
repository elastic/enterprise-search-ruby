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
