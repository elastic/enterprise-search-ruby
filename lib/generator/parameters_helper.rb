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

module Elastic
  module Generator
    # Generator Helper for working with parameters
    module ParametersHelper
      METHOD_SIGNATURE_PARAMS = [
        'content_source_key',
        'engine_name'
      ].freeze

      def setup_parameters!(endpoint)
        # TODO: Follow $ref to document parameters from body
        endpoint['parameters'].each { |param| add_parameter(param) } if endpoint.dig('parameters')
        extract_path_parameters.each do |param|
          next unless @params.select { |p| p['name'] == param }.empty?

          @params << {
            'name' => param,
            'required' => true,
            'description' => '',
            'type' => 'String'
          }
        end
      end

      def extract_path_parameters
        @path.scan(/{(\w+)}/).flatten
      end

      def add_parameter(param)
        @params << if param.keys.include?('$ref') && !param['$ref'].empty?
                     parameter_name_and_description(Utils.dig_ref_from_spec(param['$ref'], @spec))
                   else
                     parameter_name_and_description(param)
                   end
      end

      def parameter_name_and_description(param)
        param['name'] = parameter_name(param)

        # Check the spec for parameters with a given name and retrieve info
        param_info = @spec.dig('components', 'parameters').select do |_, p|
          p['name'] == param['name']
        end.values.first
        param_info = param if param_info.nil?

        parameter_display(param['name'], param_info)
      end

      def parameter_display(name, param_info)
        {
          'name' => name,
          'description' => param_info['description'],
          'type' => param_info.dig('schema', 'type') || param_info.dig('type'),
          'required' => param_info['required']
        }
      end

      def parameter_name(param)
        if (name = param['x-codegen-param-name'])
          if name == 'engineName'
            'name'
          else
            Utils.to_ruby_name(name)
          end
        else
          param['name']
        end
      end

      def required_params
        return [] unless @params

        @params.select { |param| param['required'] }
      end

      def required_variables_from_parameters
        response = []
        required_params.map do |param|
          name = param['name']
          next if in_signature?(name) || !extract_path_parameters.include?(name)

          response << "#{name} = parameters[:#{name}]"
        end
        response.join("\n")
      end

      def method_signature_params
        return unless @params

        parameters = required_params.select do |param|
          in_signature?(param['name'])
        end
        parameters.map { |param| param['name'] }
      end

      def in_signature?(param_name)
        METHOD_SIGNATURE_PARAMS.include?(param_name)
      end

      def raise_for_required_params
        errors = []
        required_params.map do |param|
          name = param['name']
          parameter = in_signature?(name) ? name : "parameters[:#{name}]"
          errors << "raise ArgumentError, \"Required parameter '#{name}' missing\" unless #{parameter}"
        end
        errors.join("\n")
      end

      def display_signature_params
        # Display
        params = method_signature_params
        params << 'body = {}' if body?
        params << 'parameters = {}'
        "(#{params.join(', ')})"
      end

      def request_method_params
        params = []
        params += [":#{@http_method}", "\"#{@path}\""]
        params << 'parameters' if @params
        params << 'body' if body?
        params.join(",\n")
      end
    end
  end
end
