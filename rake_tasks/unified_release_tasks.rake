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

# rubocop:disable Metrics/BlockLength
namespace :unified_release do
  desc <<-DESC
  Update Rubygems versions in version.rb and *.gemspec files

  Example:

      $ rake unified_release:bump[42.0.0]
  DESC
  task :bump, :version do |_, args|
    abort('[!] Required argument [version] missing') unless args[:version]

    regexp = Regexp.new(/VERSION = ("|'([0-9.]+(-SNAPSHOT)?)'|")/)
    file = './lib/elastic/enterprise-search/version.rb'
    content = File.read(file)

    if (match = content.match(regexp))
      old_version = match[2]
      content.gsub!(old_version, args[:version])
      puts "[#{old_version}] -> [#{args[:version]}] in #{file.gsub('./', '')}"
      File.open(file, 'w') { |f| f.puts content }
    else
      abort "Couldn't find the version in #{file} "
    end
  rescue StandardError => e
    abort "[!!!] #{e.class} : #{e.message}"
  end

  desc 'Update Stack Versions in test matrices (.github/workflows and .ci/test-matrix.yml)'
  task :update_matrices, :version do |_, args|
    @version = args[:version]
    error = 'Error: version must be passed in and needs to be a version format: 9.1.0, 8.7.15.'
    raise ArgumentError, error unless @version&.match?(/[0-9.]/)

    # Replace in test-matrix.yml
    file = File.expand_path('./.ci/test-matrix.yml')
    regex = /(STACK_VERSION:\s+- )([0-9.]+(-SNAPSHOT)?)/
    replace_version(regex, file)
  end

  def replace_version(regex, file)
    content = File.read(file)
    match = content.match(regex)
    content = content.gsub(regex, "#{match[1]}#{@version}")
    File.open(file, 'w') { |f| f.puts content }
  end
end
# rubocop:enable Metrics/BlockLength
