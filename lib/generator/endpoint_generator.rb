# frozen_string_literal: true

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
require_relative './utils.rb'
require_relative './documentation_helper.rb'
require_relative './parameters_helper.rb'

module Elastic
  module Generator
    # Generates code for REST API Endpoints
    class EndpointGenerator
      include DocumentationHelper
      include ParametersHelper
      CURRENT_PATH = File.dirname(__FILE__).freeze

      def initialize(name)
        @name = name
        @spec = load_spec(name)
        @target_dir = File.expand_path(__dir__ + "../../elastic/#{@name}-search/api").freeze
      end

      def generate
        Dir.mkdir(@target_dir) unless File.directory?(@target_dir)
        Utils.empty_directory(@target_dir)

        # for each endpoint in the spec generate the code
        @spec['paths'].each do |endpoint|
          @path = generate_path(endpoint[0])
          generate_classes(endpoint)
        end
        Utils.run_rubocop(@target_dir)
      end

      private

      def namespace
        return 'EnterpriseSearch' if @name == :enterprise

        "#{@name.capitalize}Search"
      end

      def load_spec(name)
        file_path = Pathname.new("./../json-specs/#{name}-search.json")
        JSON.parse(File.read(file_path))
      end

      def generate_classes(endpoint)
        endpoint.last.each_key do |method|
          @params = []
          if method == 'parameters'
            endpoint.last['parameters'].each { |param| add_parameter(param) }
            next
          end
          @http_method = method
          setup_values!(endpoint.last[method])
          write_file(generate_code)
        end
      end

      def write_file(code)
        file_name = "#{@target_dir}/#{@method_name}.rb"
        Utils.write_file(file_name, code)
      end

      def generate_path(path_string)
        path = replace_path_variables(path_string).gsub(/^\//, '')

        path.match?(/\/$/) ? path : "#{path}/"
      end

      def replace_path_variables(path)
        # rubocop:disable Lint/InterpolationCheck
        path.gsub(/{([a-z_]+)}/, '#{\1}')
        # rubocop:enable Lint/InterpolationCheck
      end

      def setup_values!(endpoint)
        @module_name = Utils.module_name(endpoint.fetch('tags'))
        @method_name = Utils.to_ruby_name(endpoint['operationId'])
        setup_parameters!(endpoint)
        @doc = setup_documentation(endpoint)
      end

      def body?
        ['post', 'put', 'patch'].include? @http_method
      end

      def generate_code
        template = "#{CURRENT_PATH}/templates/endpoint_template.erb"
        code = ERB.new(File.read(template), nil, '-')
        code.result(binding)
      end
    end
  end
end
