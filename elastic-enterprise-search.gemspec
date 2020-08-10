# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'elastic/enterprise-search/version'

Gem::Specification.new do |s|
  s.name        = 'elastic-enterprise-search'
  s.version     = Elastic::EnterpriseSearch::VERSION
  s.authors     = ['Fernando Briano']
  s.email       = ['support@elastic.co']
  s.homepage    = 'https://github.com/elastic/enterprise-search-ruby'
  s.summary     = 'Official gem for accessing the Elastic Enterprise Search APIs'
  s.description = 'API client for accessing the Elastic Enterprise APIs.'
  s.licenses    = ['Apache-2.0']

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'rspec', '~> 3.9.0'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'vcr', '~> 3.0.3'
  s.add_development_dependency 'webmock'
end
