ARG RUBY_VERSION=2.7
FROM ruby:${RUBY_VERSION}

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH
ENV QUIET=true
ENV CI=true

WORKDIR /code/enterprise-search-ruby

COPY . .

RUN gem update --system
RUN gem uninstall bundler
RUN gem install bundler
RUN bundle install