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
require_relative './lib/generator/endpoint_generator'

SPECS = [:workplace, :enterprise, :app].freeze

desc 'Generate code from JSON API spec - rake generate[wokplace enterprise app]'
task :generate, [:files] do |_, params|
  if params[:files].nil?
    SPECS.each do |spec|
      generate_specs(spec)
      # Generate specs:
      # generate specs(spec)
    end
  else
    params[:files].split(' ').each do |arg|
      raise "Available parameters are #{SPECS}, no spec for #{arg}" unless SPECS.include?(arg.to_sym)

      generate_specs(arg)
      # Generate specs:
      # generate specs(endpoints)
    end
  end
end

def generate_specs(name)
  Elastic::Generator::EndpointGenerator.new(name.to_sym).generate
end

desc 'Open an irb session preloaded with this library'
task :console do
  sh 'irb -r rubygems -I lib -r elastic_enterprise_search.rb'
end

desc 'Run Elastic Enterprise Search stack'
task :stack, [:version] do |_, params|
  sh "STACK_VERSION=#{params[:version]} ./.ci/run-local.sh"
end

namespace :spec do
  desc 'Run client tests'
  task :client do
    sh 'rspec spec/enterprise-search spec/workplace-search spec/app-search'
  end

  desc 'Run integration tests'
  task :integration do
    sh 'rspec spec/integration'
  end

  desc 'Run all tests'
  task :all do
    sh 'rspec spec'
  end
end
