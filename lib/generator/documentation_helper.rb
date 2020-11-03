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
    # Helper for setting up generated code documentation
    module DocumentationHelper
      def setup_documentation(endpoint)
        description, url = url_and_description(endpoint)
        docs = []
        docs << "# #{@module_name} - #{endpoint['summary']}"
        docs << "# #{description}" if description
        docs << '#'
        docs << parameters_documentation if @params && !@params.empty?
        docs << "# @see #{url}" if url
        docs << "#\n"
        docs.join("\n")
      end

      private

      # Description is markdown with [description](external_url)
      # So we split the string with regexp:
      def url_and_description(endpoint)
        if endpoint['description'].nil?
          description = nil
          url = endpoint.dig('externalDocs', 'url')
        else
          matches = endpoint['description'].match(/\[(.+)\]\((.+)\)/)
          description = matches[1]
          url = matches[2]
        end

        [description, url]
      end

      def parameters_documentation
        doc = ['# @param arguments [Hash] endpoint arguments']
        # Show required parameters first
        required_params.each do |param|
          if in_signature?(param['name'])
            doc.unshift(show_required_param(param))
          else
            doc << show_required_option(param)
          end
        end
        # Show optional parameters for the `parameters` hash
        unless (optional = @params - required_params).empty?
          optional.each { |param| doc << show_param(param) }
        end
        doc << "# @option body - The request body\n#" if body?
        doc << '#'
        doc.join("\n")
      end

      def show_param(param)
        "# @option #{build_param_display(param)}"
      end

      def show_required_param(param)
        "# @param #{build_param_display(param)} (*Required*)"
      end

      def show_required_option(param)
        "# @option #{build_param_display(param)} (*Required*)"
      end

      def build_param_display(param)
        "#{param['name']} [#{param['type']&.capitalize}] #{param['description']}"
      end
    end
  end
end
