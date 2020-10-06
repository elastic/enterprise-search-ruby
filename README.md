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
- [Development](https://github.com/elastic/enterprise-search-ruby#development)
  - [Run stack locally](https://github.com/elastic/enterprise-search-ruby#run-stack-locally)
  - [Run tests](https://github.com/elastic/enterprise-search-ruby#run-tests)
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

In your Elastic Workplace Search dashboard navigate to Sources/Add a Shared Content Source/Custom API Source to create a new source. Name your source (e.g. `Enterprise Search Ruby Client`) and once it's created you'll get an `access token` and a `key`. You'll need these in the following steps.

#### Instantiation

The Workplace Search client can be accessed from an existing Enterprise Search Client, or you can initialize a new one if you're only going to use Worplace Search:

```ruby
# Prerequisites
host = 'https://id.ent-search.europe-west2.gcp.elastic-cloud.com'
access_token = '<access token>'
content_source_key = '<content source key>'

# From the Enterprise Search client:
ent_client = Elastic::EnterpriseSearch::Client.new(host: host)
ent_client.workplace_search.http_auth = access_token
ent_client.workplace_search.index_documents(content_source_key, documents)

# On its own
workplace_search_client = Elastic::EnterpriseSearch::WorkplaceSearch::Client.new(
  host: host,
  http_auth: access_token
)

workplace_search_client.list_permissions(content_source_key)
```

### App Search

In your Elastic App Search dashboard, navigate to Credentials and Create a Key for the client to use. Make sure to read [the documentation on Authentication](https://www.elastic.co/guide/en/app-search/current/authentication.html) to understand which key you want to use. Once you've created your key, you need to copy the key value to use on your client:

#### Instantiation

The App Search client can be accessed from an existing Enterprise Search Client, or you can initialize a new one if you're only going to use App Search:

```ruby
# Prerequisites
host = 'https://id.ent-search.europe-west2.gcp.elastic-cloud.com'
api_key = 'private-api-key'

# From the Enterprise Search client:
ent_client = Elastic::EnterpriseSearch::Client.new(host: host)
ent_client.app_search.http_auth = api_key

# On its own
client = Elastic::EnterpriseSearch::AppSearch::Client.new(host: host, http_auth: api_key)

engine_name = 'videogames'
document = {
  id: 'Mr1064',
  name: 'Super Mario 64',
  body: 'A classic 3D videogame'
}

client.index_documents(engine_name, document, {engine_name: engine_name})
```

#### Engines
```ruby
# List all engines
client.list_engines

# Get an engine
client.engine('videogames')
```

#### Search

```ruby
queries = {
  query: 'mario'
}

client.search(engine_name, query)
```
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

### Run Stack locally

A rake task is included to run the Elastic Enterprise Search stack locally via Docker:

```
$ rake stack[7.10.0]
```

This will run Elastic Enterprise Search in http://localhost:3002
- Username: `enterprise_search`
- Password: `changeme`

### Run Tests

Unit tests for the clients:

```
$ rake spec:client
```

Integration tests: you need to have an instance of Enterprise Search running either locally or remotely, and specify the host and credentials in environment variables (see below for a complete dockerized setup). If you're using the included rake task `rake stack[:version]`, you can run the integration tests with the following command:
```
$ ELASTIC_ENTERPRISE_HOST='http://localhost:3002' \
  ELASTIC_ENTERPRISE_USER='elastic' \
  ELASTIC_ENTERPRISE_PASSWORD='changeme' \
  rake spec:integration
```

Run integration tests completely within containers, the way we run them on our CI:
```
RUNSCRIPTS=enterprise-search STACK_VERSION=7.10.0 ./.ci/run-tests
```

## License

Apache-2.0
