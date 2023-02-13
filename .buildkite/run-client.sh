#!/usr/bin/env bash
#
# Once called Elasticsearch and Enteprise Search should be up and running
#
script_path=$(dirname $(realpath -s $0))
source $script_path/functions/imports.sh
set -euo pipefail

export RUBY_VERSION=${RUBY_VERSION:-3.1}

echo "--- :telephone_receiver: Pinging Elasticsearch :elasticsearch:"
curl --insecure --fail $external_elasticsearch_url/_cluster/health?pretty

enterprise_search_url="http://localhost:3002"
echo "--- :telephone_receiver: Pinging Enterprise Search :elastic-enterprise-search:"
curl -I --fail $enterprise_search_url

echo "--- :docker: :ruby: Building Docker image"
docker build \
       --file $script_path/Dockerfile \
       --tag elastic/enterprise-search-ruby \
       --build-arg RUBY_VERSION=${RUBY_VERSION} \
       .

echo "--- :docker: :ruby: Running Client Container"
docker run \
       --network ${network_name} \
       --name enterprise-search-ruby \
       --env "ELASTIC_ENTERPRISE_HOST=http://${CONTAINER_NAME}:3002" \
       --env "BUILDKITE=true" \
       --rm \
       --volume `pwd`:/code/enterprise-search-ruby \
       elastic/enterprise-search-ruby \
       rake spec:integration

