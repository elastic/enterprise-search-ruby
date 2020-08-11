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

module Elastic
  module Generator
    # Generates code for REST API Endpoints
    class EndpointGenerator
      ALIASES = {
        put_user_permissions: :update_user_permissions,
        delete_documents: :destroy_documents
      }.freeze

      def initialize(name)
        @name = name
        @spec = load_spec(name)
        @target_dir = File.expand_path(__dir__ + "../../elastic/#{@name}-search/api").freeze
      end

      def load_spec(name)
        file = Generator::CURRENT_PATH + "/json/#{name}-search.json"
        JSON.parse(File.read(file))
      end

      def generate
        Dir.mkdir(@target_dir) unless File.directory?(@target_dir)
        Utils.empty_directory(@target_dir)

        # for each endpoint in the spec generate the code
        @spec['paths'].each do |endpoints|
          generate_classes(endpoints)
        end
        Utils.run_rubocop(@target_dir)
      end

      private

      def namespace
        return 'EnterpriseSearch' if @name == :enterprise

        "#{@name.capitalize}Search"
      end

      def generate_classes(endpoints)
        @path = replace_path_variables(endpoints[0])

        endpoints[1].each do |method, endpoint|
          @http_method = method
          setup_values!(endpoint)
          file_name = "#{@target_dir}/#{@method_name}.rb"
          Utils.write_file(file_name, generate_method_code)
        end
      end

      def replace_path_variables(path)
        path.gsub(/{([a-z_]+)}/, '#{\1}')
      end

      def setup_values!(endpoint)
        @module_name = Utils.module_name(endpoint['tags'])
        @method_name = Utils.to_ruby_name(endpoint['operationId'])
        @required_params = []

        setup_parameters!(endpoint['parameters']) if endpoint.dig('parameters')
        @doc = setup_documentation(endpoint)
      end

      def setup_parameters!(params)
        @params = params.map { |param| parameter_name_and_description(param) }
      end

      def parameter_name_and_description(param)
        param['name'] = 'current_page' if param['name'] == 'page[current]'
        param['name'] = 'page_size' if param['name'] == 'page[size]'
        param['name'] = 'included_stats' if param['name'] == 'include' && @method_name == 'stats'

        param_info = @spec.dig('components', 'parameters', param['name'])

        {
          'name' => param['name'],
          'description' => param_info['description'],
          'type' => param_info['schema']['type'],
          'required' => param_info['required']
        }
      end

      def required_params
        return [] unless @params

        @params.select { |p| p['required'] }
      end

      def method_signature_params
        return unless @params

        params = required_params.map do |param|
          param['name']
        end
        params << 'parameters = {}'
        "(#{params.join(', ')})"
      end

      def request_method_params
        params = []
        params += [":#{@http_method}", "\"#{@path}\""]
        params << 'parameters' if @params
        params.join(",\n")
      end

      def generate_method_code
        template = "#{Generator::CURRENT_PATH}/templates/endpoint_template.erb"
        code = ERB.new(File.read(template), nil, '-')
        code.result(binding)
      end

      def setup_documentation(endpoint)
        # Description is markdown with [description](external_url)
        # So we split the string with regexp:
        matches = endpoint['description'].match(/\[(.+)\]\((.+)\)/)
        description = matches[1]
        url = matches[2]
        docs = []
        docs << "# #{@module_name} - #{endpoint['summary']}"
        docs << "# #{description}"
        docs << '#'
        docs << parameters_doc if @params
        docs << '#'
        docs << "# @see #{url}"
        docs << "#\n"
        docs.join("\n")
      end

      def parameters_doc
        return unless @params

        @params.map do |param|
          "# @option #{param['name']} - #{param['description']}" + ' (*Required*)' if param['required']
        end.join("\n")
      end

      def aliases
        return unless ALIASES[@method_name.to_sym]

        "alias_method :#{ALIASES[@method_name.to_sym]}, :#{@method_name}"
      end
    end
  end
end
