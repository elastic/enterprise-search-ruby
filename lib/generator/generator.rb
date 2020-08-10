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

require 'json'
require 'erb'
require_relative './endpoint_generator.rb'
require_relative './utils.rb'

module Elastic
  # Generates endpoint Ruby code for the EnterpriseSearch API specs.
  module Generator
    CURRENT_PATH = File.dirname(__FILE__).freeze

    def self.generate
      workplace_spec = load_spec(:workplace)

      # Generate Workplace Search endpoint code:
      EndpointGenerator.new(workplace_spec).generate
      # Generate specs:
      # generate specs(endpoints)
    end

    def self.load_spec(name)
      file = CURRENT_PATH + "/json/#{name}-search.json"
      JSON.parse(File.read(file))
    end
  end
end
