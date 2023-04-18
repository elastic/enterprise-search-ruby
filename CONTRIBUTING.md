# Contributing to enterprise-search-ruby

## Run Stack locally

A rake task is included to run the Elastic Enterprise Search stack locally via Docker:

```
$ rake stack[7.10.0]
```

This will run Elastic Enterprise Search in http://localhost:3002
- Username: `enterprise_search`
- Password: `changeme`

The version of the Elastic Enterprise Search Stack to use should be the same as tags of `https://www.docker.elastic.co/r/enterprise-search`. You can also use SNAPSHOT builds such as `8.0.0-SNAPSHOT`, `7.11-SNAPSHOT`, etc.

## Running Tests

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


## Contributing Code Changes

1. Please make sure you have signed the [Contributor License
   Agreement](http://www.elastic.co/contributor-agreement/). We are not
   asking you to assign copyright to us, but to give us the right to distribute
   your code without restriction. We ask this of all contributors in order to
   assure our users of the origin and continuing existence of the code. You only
   need to sign the CLA once.

2. Run rubocop and the test suite to ensure your changes do not break existing
   code:

   ```
   $ bundle exec rubocop
   ```

   Check [Running
   tests](https://github.com/elastic/enterprise-search-ruby/#run-tests) on the
   README for instructions on how to run all the tests.

3. Rebase your changes. Update your local repository with the most recent code
   from the main `enterprise-search-ruby` repository and rebase your branch
   on top of the latest `main` branch.

4. Submit a pull request. Push your local changes to your forked repository
   and [submit a pull request](https://github.com/elastic/enterprise-search-ruby/pulls)
   and mention the issue number if any (`Closes #123`) Make sure that you
   add or modify tests related to your changes so that CI will pass.

5. Sit back and wait. There may be some discussion on your pull request and
   if changes are needed we would love to work with you to get your pull request
   merged into enterprise-search-ruby.

## API Code Generation

All the API methods within
`lib/elastic/[app-search|enterprise-search|workplace-search]/api/*.rb` are
generated from an API specification that is not available publicly currently.
Because these files are generated, changes should instead be suggested in an
issue or as part of the description in your Pull Request.
