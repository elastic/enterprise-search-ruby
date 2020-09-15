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
- [HTTP Layer](https://github.com/elastic/enterprise-search-ruby#http-layer)
- [Generating the API Code](https://github.com/elastic/enterprise-search-ruby#generating-the-api-code)
- [License](https://github.com/elastic/enterprise-search-ruby#license)

## Installation

```
$ gem install elastic-enterprise-search
```
The version follows the Elastic Stack version so 7.10 is compatible with Enterprise Search released in Elastic Stack 7.10.

## Getting Started

### Enterprise Search

Example usage:

```ruby
http_auth = {user: 'elastic', password: 'password'}
host = 'https://id.ent-search.europe-west2.gcp.elastic-cloud.com'

ent_client = Elastic::EnterpriseSearch::Client.new(host: host, http_auth: http_auth)

ent_client.health

ent_client.read_only

ent_client.put_read_only(enabled: false)

ent_client.stats

ent_client.version
```

### Workplace Search

```ruby
ent_client = Elastic::EnterpriseSearch::Client.new
http_auth = '<content source access token>'
ent_client.workplace_search.http_auth = http_auth
ent_client.workplace_search.index_documents(content_source_key, documents)
```

### App Search

TODO

## HTTP Layer

This library uses [elasticsearch-transport](https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-transport), the low-level Ruby client for connecting to an Elasticsearch cluster - also used in the official [Elasticsearch Ruby Client](https://github.com/elastic/elasticsearch-ruby).

All requests, if successful, will return an `Elasticsearch::Transport::Transport::Response` instance. You can access the response `body`, `headers` and `status`.

`elasticsearch-transport` defines a [number of exception classes](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-transport/lib/elasticsearch/transport/transport/errors.rb) for various client and server errors, as well as unsuccessful HTTP responses, making it possible to rescue specific exceptions with desired granularity. More details [here](https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-transport#exception-handling).

You can find the full documentation for `elasticsearch-transport` at [RubyDoc](https://rubydoc.info/gems/elasticsearch-transport).

## Generating the API Code

The code from the API endpoints is programatically generated from OpenAPI JSON specs.  These specs are stored in `lib/generator/json`. There's a rake task you can use to generate the code:

```
$ rake generate
```

This will generate the code for all the specs. But if you only want to update one spec, you can also pass in the name(s) as a parameter:

```
$ rake generate[workplace enterprise]
```

## Development

### Run tests

Unit tests for Enterprise Search Client:

```
$ rake spec:client
```


Integration tests: you need to have an instance of Enterprise Search running either locally or remotely, and specify the host and credentials in environment variables (see below for a complete dockerized setup)
```
$ ELASTIC_ENTERPRISE_HOST='https://id.ent-search.europe-west2.gcp.elastic-cloud.com' \
  ELASTIC_ENTERPRISE_USER='elastic' \
  ELASTIC_ENTERPRISE_PASSWORD='changeme' \
  rake spec:integration
```

Run integration tests with a docker setup for Enterprise Search, the way we run them on our CI:
```
STACK_VERSION=7.10.0 ./.ci/run-tests
```

## License

Apache-2.0
