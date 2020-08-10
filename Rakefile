require 'rspec/core/rake_task'
require_relative './lib/generator/generator.rb'

desc 'Generate code from JSON API spec'
task :generate do
  Elastic::Generator.generate
end
