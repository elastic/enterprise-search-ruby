# frozen_string_literal: true

require 'elastic/enterprise-search/version'

# Require generated API code:
[
  File.dirname(__FILE__) + '/enterprise-search/api/*.rb',
  File.dirname(__FILE__) + '/workplace-search/api/*.rb'
].each do |path|
  Dir[path].sort.each { |file| require file }
end

require 'elastic/enterprise-search/client'
require 'elastic/workplace-search/workplace_search.rb'

module Elastic
  module EnterpriseSearch
  end
end
