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

require 'elastic/enterprise-search/version'

# Require API code:
[
  "#{File.dirname(__FILE__)}/enterprise-search/api/*.rb",
  "#{File.dirname(__FILE__)}/workplace-search/api/*.rb",
  "#{File.dirname(__FILE__)}/app-search/api/*.rb"
].each do |path|
  Dir[path].sort.each { |file| require file }
end

require 'elastic/enterprise-search/client'
require 'elastic/workplace-search/workplace_search'
require 'elastic/app-search/app_search'

module Elastic
  # If the version is X.X.X.pre/alpha/beta, use X.X.Xp for the meta-header:
  def self.client_meta_version
    regexp = /^([0-9]+\.[0-9]+\.[0-9]+)\.?([a-z0-9.-]+)?$/
    match = Elastic::EnterpriseSearch::VERSION.match(regexp)
    return "#{match[1]}p" if match[2]

    Elastic::EnterpriseSearch::VERSION
  end

  ENTERPRISE_SERVICE_VERSION = [:ent, client_meta_version].freeze

  module EnterpriseSearch
  end
end
