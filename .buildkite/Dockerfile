ARG RUBY_VERSION=${RUBY_VERSION:-3.1}
FROM ruby:$RUBY_VERSION

ENV QUIET=true
ENV CI=true

# Install required tools
RUN apt-get -q update && apt-get -y install zip curl

WORKDIR /code/enterprise-search-ruby
COPY . .

RUN bundle install
