# frozen_string_literal: true

require 'rspec/core/rake_task'
require_relative './lib/generator/generator.rb'

RSpec::Core::RakeTask.new(:spec)

desc 'Generate code from JSON API spec'
task :generate do
  Elastic::Generator.generate
end

desc 'Open an irb session preloaded with this library'
task :console do
  sh 'irb -r rubygems -I lib -r elastic_enterprise_search.rb'
end
