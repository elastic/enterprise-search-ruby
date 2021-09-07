# Contributing to enterprise-search-ruby

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
   on top of the latest `main` branch. All of your changes will be squashed
   into a single commit so don't worry about pushing multiple times.
   
4. Submit a pull request. Push your local changes to your forked repository
   and [submit a pull request](https://github.com/elastic/enterprise-search-python/pulls)
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
