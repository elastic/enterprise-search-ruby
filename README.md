# Elastic Enterprise Search Client

![build](https://github.com/elastic/enterprise-search-ruby/workflows/master/badge.svg)
![rubocop](https://github.com/elastic/enterprise-search-ruby/workflows/rubocop/badge.svg)

This project is in development and is not ready for use in production yet.

## Contents
- [Installation](https://github.com/elastic/enterprise-search-ruby#installation)
- [Getting Started](https://github.com/elastic/enterprise-search-ruby#getting-started)
  - [Enterprise Search](https://github.com/elastic/enterprise-search-ruby#enterprise-search)
  - [Workplace Search](https://github.com/elastic/enterprise-search-ruby#workplace-search)
  - [App Search](https://github.com/elastic/enterprise-search-ruby#app-search)
- [Generating the API Code](https://github.com/elastic/enterprise-search-ruby#generating-the-api-code)
- [License](https://github.com/elastic/enterprise-search-ruby#license)

## Installation

```
$ gem install elastic-enterprise-search
```
The version follows the Elastic Stack version so 7.10 is compatible with Enterprise Search released in Elastic Stack 7.10.

## Getting Started

### Enterprise Search

```ruby
http_auth = {user: 'elastic', password: 'password'}
ent_client = Elastic::EnterpriseSearch::Client.new(host: 'host', http_auth: http_auth)
ent_client.health
```

### Workplace Search

```ruby
ent_client = Elastic::EnterpriseSearch::Client.new
http_auth = '<content source access token>'
ent_client.workplace_search.http_auth = http_auth
ent_client.workplace_search.index_documents(content_source_key, documents)
```

### App Search

## Generating the API Code

The code from the API endpoints is programatically generated from OpenAPI JSON specs.  These specs are stored in `lib/generator/json`. There's a rake task you can use to generate the code:

```
$ rake generate
```

This will generate the code for all the specs. But if you only want to update one spec, you can also pass in the name(s) as a parameter:

```
$ rake generate[workplace enterprise]
```

## License

Apache-2.0
