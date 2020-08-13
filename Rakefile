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
require_relative './lib/generator/endpoint_generator.rb'

RSpec::Core::RakeTask.new(:spec)

desc 'Generate code from JSON API spec'
task :generate do
  # Generate endpoint code:
  Elastic::Generator::EndpointGenerator.new(:workplace).generate
  Elastic::Generator::EndpointGenerator.new(:enterprise).generate
  # Generate specs:
  # generate specs(endpoints)
end

desc 'Open an irb session preloaded with this library'
task :console do
  sh 'irb -r rubygems -I lib -r elastic_enterprise_search.rb'
end
