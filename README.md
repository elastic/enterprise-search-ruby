# Elastic Enterprise Search Client

![build](https://github.com/elastic/enterprise-search-ruby/workflows/master/badge.svg)
![rubocop](https://github.com/elastic/enterprise-search-ruby/workflows/rubocop/badge.svg)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop-hq/rubocop)

Official Ruby API client for [Elastic Enterprise Search](https://www.elastic.co/enterprise-search). Use this gem to integrate App Search and Workplace Search into your Ruby code.

## Documentation

[See the documentation](https://www.elastic.co/guide/en/enterprise-search-clients/ruby/current/index.html) for compatibility info, configuring, and an API reference.

## Development

### Run Stack locally

A rake task is included to run the Elastic Enterprise Search stack locally via Docker:

```
$ rake stack[7.10.0]
```

This will run Elastic Enterprise Search in http://localhost:3002
- Username: `enterprise_search`
- Password: `changeme`

The version of the Elastic Enterprise Search Stack to use should be the same as tags of `https://www.docker.elastic.co/r/enterprise-search`. You can also use SNAPSHOT builds such as `8.0.0-SNAPSHOT`, `7.11-SNAPSHOT`, etc.

### Running Tests

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
