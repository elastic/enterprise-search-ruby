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

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |s|
  s.required_ruby_version = '>= 2.6'
  s.name        = 'elastic-enterprise-search'
  s.version     = Elastic::EnterpriseSearch::VERSION
  s.authors     = ['Fernando Briano']
  s.email       = ['clients-team@elastic.co']
  s.homepage    = 'https://github.com/elastic/enterprise-search-ruby'
  s.summary     = 'Official API client for Elastic Enterprise Search'
  s.description = <<~DESCRIPTION
    Official API client for Elastic Enterprise Search APIs.
  DESCRIPTION
  s.licenses = ['Apache-2.0']

  s.metadata = {
    'bug_tracker_uri' => 'https://github.com/elastic/enterprise-search-ruby/issues',
    'documentation_uri' => 'https://www.elastic.co/guide/en/enterprise-search-clients/ruby/current/index.html',
    'homepage_uri' => 'https://www.elastic.co/enterprise-search',
    'source_code_uri' => 'https://github.com/elastic/enterprise-search-ruby',
    'changelog_uri' => 'https://www.elastic.co/guide/en/enterprise-search-clients/ruby/current/release_notes.html'
  }

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'elastic-transport', '~> 8.1'
  s.add_runtime_dependency 'jwt', '>= 1.5', '< 3.0'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'byebug' unless defined?(JRUBY_VERSION)
  s.add_development_dependency 'rspec', '~> 3.9.0'
  s.add_development_dependency 'rspec_junit_formatter'
  s.add_development_dependency 'rubocop', '>= 1.51' unless defined?(JRUBY_VERSION) &&
                                                           Gem::Version.new(JRUBY_VERSION) < Gem::Version.new('9.4')
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock', '>= 3.23.1'
  # Adapters
  s.add_development_dependency 'faraday-httpclient'
  s.add_development_dependency 'faraday-net_http_persistent'
  s.add_development_dependency 'faraday-patron' unless defined? JRUBY_VERSION
  s.add_development_dependency 'faraday-typhoeus'

  s.post_install_message = <<~MESSAGE

    Warning: Starting with Elastic version 9.0, the standalone Enterprise Search products, will no longer be included in our offering. They remain supported in their current form in version 8.x and will only receive security upgrades and fixes.
    Enterprise Search clients will continue to be supported in their current form throughout 8.x versions, according to our EOL policy: https://www.elastic.co/support/eol
    We recommend transitioning to our actively developed Elastic Stack (https://www.elastic.co/elastic-stack) tools for your search use cases. However, if you're still using any Enterprise Search products, we recommend using the latest stable release of the clients.

    Here are some useful links with more information:
    * Enterprise Search FAQ: https://www.elastic.co/resources/enterprise-search/enterprise-search-faq
    * Migrating to 9.x from Enterprise Search 8.x versions: https://www.elastic.co/guide/en/enterprise-search/current/upgrading-to-9-x.html

  MESSAGE
end
# rubocop:enable Metrics/BlockLength
