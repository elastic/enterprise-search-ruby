# Elastic Enterprise Search Client

![rubocop](https://github.com/elastic/enterprise-search-ruby/workflows/rubocop/badge.svg)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)
![build](https://github.com/elastic/enterprise-search-ruby/workflows/main/badge.svg)
[![Build status](https://badge.buildkite.com/a6c44f2af741c866381fb3c845e8d4b0e9b5c5883ef84ac30e.svg)](https://buildkite.com/elastic/enterprise-search-ruby)

> [!WARNING] **Enterprise Search will be discontinued in 9.0.**

> Starting with Elastic version 9.0, the standalone Enterprise Search products, will no longer be included in our offering. They remain supported in their current form in version 8.x and will only receive security upgrades and fixes. Enterprise Search clients will continue to be supported in their current form throughout 8.x versions, according to our EOL policy: https://www.elastic.co/support/eol
> We recommend transitioning to our actively developed Elastic Stack (https://www.elastic.co/elastic-stack) tools for your search use cases. However, if you're still using any Enterprise Search products, we recommend using the latest stable release of the clients.

> Here are some useful links with more information:
> * Enterprise Search FAQ: https://www.elastic.co/resources/enterprise-search/enterprise-search-faq
> * Migrating to 9.x from Enterprise Search 8.x versions: https://www.elastic.co/guide/en/enterprise-search/current/upgrading-to-9-x.html


Official Ruby API client for [Elastic Enterprise Search](https://www.elastic.co/enterprise-search). Use this gem to integrate App Search and Workplace Search into your Ruby code.

## Installation

Install the `elastic-enterprise-search` gem from [Rubygems](https://rubygems.org/gems/elastic-enterprise-search):

```
$ gem install elastic-enterprise-search
```

Or add it to your project's Gemfile:

```ruby
gem 'elastic-enterprise-search', 'VERSION'
```

The Enterprise Search client is implemented with [`elastic-transport`](https://github.com/elastic/elastic-transport-ruby/) as the HTTP layer, which uses [Faraday](https://rubygems.org/gems/faraday). Faraday supports several [adapters](https://lostisland.github.io/faraday/adapters/) and will use `Net::HTTP` by default. For optimal performance with the Enterprise Search API, we suggest using an HTTP library which supports persistent ("keep-alive") connections. For the standard Ruby implementation, this could be [Net::HTTP::Persistent](https://github.com/drbrain/net-http-persistent), [patron](https://github.com/toland/patron) or [Typhoeus](https://github.com/typhoeus/typhoeus). For JRuby, [Manticore](https://github.com/cheald/manticore) is a great option as well. Require the library for the adapter in your code and then pass in the `:adapter` parameter to the client when you initialize it:

```ruby
require 'elastic-enterprise-search'
require 'faraday/net_http_persistent'

client = Elastic::EnterpriseSearch::Client.new(adapter: :net_http_persistent)
```
If an adapter is not specified, the client will try to auto-detect available libraries and use the best available HTTP client.

## Documentation

[See the documentation](https://www.elastic.co/guide/en/enterprise-search-clients/ruby/current/index.html) for usage, code examples, configuring the client, and an API reference.

See code examples of usage for the [Enterprise Search](https://www.elastic.co/guide/en/enterprise-search-clients/ruby/current/enterprise-search-api.html), [App Search](https://www.elastic.co/guide/en/enterprise-search-clients/ruby/current/app-search-api.html) and [Workplace Search](https://www.elastic.co/guide/en/enterprise-search-clients/ruby/current/workplace-search-api.html) APIs.

## Compatibility

We follow Ruby’s own maintenance policy and officially support all currently maintained versions per [Ruby Maintenance Branches](https://www.ruby-lang.org/en/downloads/branches/).

## Development

See [CONTRIBUTING](https://github.com/elastic/enterprise-search-ruby/blob/main/CONTRIBUTING.md).

## License

This software is licensed under the [Apache 2 license](./LICENSE). See [NOTICE](./NOTICE).
