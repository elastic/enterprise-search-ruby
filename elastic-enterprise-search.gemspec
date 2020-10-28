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

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'elastic/enterprise-search/version'

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 2.5'
  s.name        = 'elastic-enterprise-search'
  s.version     = Elastic::EnterpriseSearch::VERSION
  s.authors     = ['Fernando Briano']
  s.email       = ['support@elastic.co']
  s.homepage    = 'https://github.com/elastic/enterprise-search-ruby'
  s.summary     = 'Official gem for accessing the Elastic Enterprise Search APIs'
  s.description = 'API client for accessing the Elastic Enterprise APIs.'
  s.licenses    = ['Apache-2.0']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'elasticsearch-transport'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'byebug' unless defined?(JRUBY_VERSION)
  s.add_development_dependency 'rspec', '~> 3.9.0'
  s.add_development_dependency 'rspec_junit_formatter'
  s.add_development_dependency 'rubocop', '~> 1.0.0'
  s.add_development_dependency 'vcr', '~> 3.0.3'
  s.add_development_dependency 'webmock'
end
