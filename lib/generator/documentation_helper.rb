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
        description, url = url_and_description(endpoint['description'])
        docs = []
        docs << "# #{@module_name} - #{endpoint['summary']}"
        docs << "# #{description}"
        docs << '#'
        docs << parameters_documentation if @params && !@params.empty?
        docs << "# @see #{url}"
        docs << "#\n"
        docs.join("\n")
      end

      private

      def parameters_documentation
        doc = []
        @params.each do |param|
          info = "# @param #{param['name']} [#{param['type'].capitalize}] #{param['description']}"
          info += ' (*Required*)' if param['required']
          doc << info
        end
        doc << '#'
        doc.join("\n")
      end

      # Description is markdown with [description](external_url)
      # So we split the string with regexp:
      def url_and_description(description)
        matches = description.match(/\[(.+)\]\((.+)\)/)
        [matches[1], matches[2]]
      end
    end
  end
end
