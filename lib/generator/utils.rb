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
    # Utility functions for code generation
    module Utils
      def self.empty_directory(dir)
        FileUtils.remove_dir(dir)
        Dir.mkdir(dir)
      end

      def self.write_file(file_name, content)
        File.open(file_name, 'w') { |f| f.puts content }
        puts colorize(:green, "\nSuccessfully generated #{file_name}\n\n")
      end

      def self.run_rubocop(dir)
        system("rubocop -c ./.rubocop.yml --format autogenconf -a #{dir}")
      end

      def self.module_name(tag)
        tag.first.gsub(/\s{1}API/, '').gsub(/\s/, '')
      end

      def self.to_ruby_name(camel_case)
        camel_case
          .gsub(/([a-z])([A-Z])+/, '\1_\2') # to camel_case
          .gsub(/get_/, '') # remove prepended 'get' in method names
          .downcase
      end

      def self.colorize(color, message)
        colors = { red: 31, green: 32 }
        "\e[#{colors[color]}m#{message}\e[0m"
      end

      # TODO: Use this for modules
      def self.setup_tags(tags)
        tags.map do |tag|
          {
            name: tag['name'],
            description: tag['description'],
            url: tag['externalDocs']['url']
          }
        end
      end
    end
  end
end
