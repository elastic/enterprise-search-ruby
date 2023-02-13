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

require 'rspec/core/rake_task'
require 'bundler/gem_tasks'
import 'rake_tasks/unified_release_tasks.rake'

desc 'Open an irb session preloaded with this library'
task :console do
  sh 'irb -r rubygems -I lib -r elastic-enterprise-search.rb'
end

desc 'Run Elastic Enterprise Search stack'
task :stack, [:version] do |_, params|
  sh "STACK_VERSION=#{params[:version]} ./.buildkite/run-local.sh"
end

# rubocop:disable Metrics/BlockLength
namespace :spec do
  desc 'Run client tests'
  task :client do
    sh 'rspec spec/enterprise-search spec/workplace-search spec/app-search'
  end

  desc 'Run integration tests'
  task :integration do
    buildkite = ENV['BUILDKITE']
    puts '--- :rspec: Running Enteprise Search API Tests' if buildkite
    sh 'rspec spec/integration/enterprise_search_api_spec.rb'
    puts '--- :rspec: Running Workplace Search API Tests' if buildkite
    sh 'rspec spec/integration/workplace-search'
    puts '--- :rspec: Running App Search API Tests' if buildkite
    sh 'rspec spec/integration/app-search'
  end

  desc 'Run all tests'
  task :all do
    sh 'rspec spec'
  end

  namespace :integration do
    desc 'Run App Search integration tests'
    task :appsearch do
      sh 'rspec spec/integration/app-search'
    end

    desc 'Run Enterprise Search integration tests'
    task :enterprisesearch do
      sh 'rspec spec/integration/enterprise_search_api_spec.rb'
    end

    desc 'Run Workplace Search integration tests'
    task :workplacesearch do
      sh 'rspec spec/integration/workplace-search'
    end
  end
end
# rubocop:enable Metrics/BlockLength
