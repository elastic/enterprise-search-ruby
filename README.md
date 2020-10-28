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

Install the gem:

```
$ gem install elastic-enterprise-search
```

Or add it to your project's Gemfile:

```
gem 'elastic-enterprise-search'
```

The version follows the Elastic Stack version so 7.10 is compatible with Enterprise Search released in Elastic Stack 7.10.

## Getting Started

### Enterprise Search

The Enterprise Search API uses basic auth with credentials from an Elasticsearch user. You can read about the API, authentication and privileges needed [on the official docs](https://www.elastic.co/guide/en/enterprise-search/current/management-apis.html).

#### Example usage:

```ruby
http_auth = {user: 'elastic', password: 'password'}
host = 'https://id.ent-search.europe-west2.gcp.elastic-cloud.com'

ent_client = Elastic::EnterpriseSearch::Client.new(host: host, http_auth: http_auth)
```

#### Health API

```ruby
> response = ent_client.health
> response.body
 => {"name"=>"...",
     "version"=>{"number"=>"7.10.0", "build_hash"=>"...", "build_date"=>"..."},
     "jvm"=>{...},
     "filebeat"=>{...},
     "system"=>{...}
    }
```

#### Version API

```ruby
> response = ent_client.version
> response.body
 => {"number"=>"7.10.0", "build_hash"=>"...", "build_date"=>"..."}
```

#### Managing Read-Only mode:

```ruby
# Set read-only flag state
ent_client.put_read_only(enabled: false)

# Get read-only flag state
ent_client.read_only
```

#### Stats API
```ruby
> ent_client.stats.body
 => {"app"=>{"pid"=>1, "start"=>"...", "end"=>"", "metrics"=>{...}},
     "queues"=>{"connectors"=>{...}, "document_destroyer"=>{...}, "engine_destroyer"=>{...}, "index_adder"=>{...}, ...},
     "connectors"=>{"alive"=>true, "pool"=>{...}, "job_store"=>{...}}}}

```

### Workplace Search

In your Elastic Workplace Search dashboard navigate to _Sources/Add a Shared Content Source_ and select _Custom API Source_ to create a new source. Name your source (e.g. `Enterprise Search Ruby Client`) and once it's created you'll get an `access token` and a `key`. You'll need these in the following steps.

#### Instantiation

The Workplace Search client can be accessed from an existing Enterprise Search Client, or you can initialize a new one. If you instantiate the Workplace Search client from an existing Enterprise Search Client, it's going to share the HTTP transport instance, so it's going to connect to the same host, which is a common scenario. However, if you want to connect to a different host, you should instantiate a new Workplace Client on its own:

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
```

TODO: Document All Workplace Search APIs

### App Search

In your Elastic App Search dashboard, navigate to Credentials and Create a Key for the client to use. Make sure to read [the documentation on Authentication](https://www.elastic.co/guide/en/app-search/current/authentication.html) to understand which key you want to use. Once you've created your key, you need to copy the key value to use on your client:

#### Instantiation

The App Search client can be accessed from an existing Enterprise Search Client, or you can initialize a new one. If you instantiate the App Search client from an existing Enterprise Search Client, it's going to share the HTTP transport instance, so it's going to connect to the same host which is a common scenario. However, if you want to connect to a different host, you should instantiate a new App Search Client on its own.

```ruby
# Prerequisites
host = 'https://id.ent-search.europe-west2.gcp.elastic-cloud.com'
api_key = 'private-api-key'

# From the Enterprise Search client:
ent_client = Elastic::EnterpriseSearch::Client.new(host: host)
ent_client.app_search.http_auth = api_key

# On its own
client = Elastic::EnterpriseSearch::AppSearch::Client.new(host: host, http_auth: api_key)
```

TODO: Documents all App Search APIs

#### Index Documents

```
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
# Create an engine
client.create_engine(name: 'videogames')

# List all engines
client.list_engines

# Get an engine
client.engine('videogames')

# Delete an engine
client.delete_engine('videogames')
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

`elasticsearch-transport` defines a [number of exception classes](https://github.com/elasticsearch/elasticsearch-ruby/blob/master/elasticsearch-transport/lib/elasticsearch/transport/transport/errors.rb) for various client and server errors, as well as unsuccessful HTTP responses, making it possible to rescue specific exceptions with desired granularity. More details [here](https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-transport#exception-handling). You can find the full documentation for `elasticsearch-transport` at [RubyDoc](https://rubydoc.info/gems/elasticsearch-transport).

The clients pass different options to transport, you can check them out [in the source code](https://github.com/elastic/enterprise-search-ruby/blob/master/lib/elastic/enterprise-search/client.rb) while we set up RubyDocs.

### Setting the host and port

If you don't specify a host and port, the client will default to `http://localhost:3002`.

## Generating the API Code

The code from the API endpoints is programatically generated from OpenAPI JSON specs.

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
