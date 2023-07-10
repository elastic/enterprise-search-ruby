#!/usr/bin/env bash
#
# Script to run Enterprise Search container and Enterprise Search client integration tests on Buildkite
#
# Version 0.1
#
export TEST_SUITE=platinum
export CONTAINER_NAME=enterprise-search

script_path=$(dirname $(realpath -s $0))
source $script_path/functions/imports.sh
set -euo pipefail

echo "--- :docker: :elasticsearch: Starting Elasticsearch"
DETACH=true bash $script_path/run-elasticsearch.sh

echo "--- :docker: :elastic-enterprise-search: Starting Enterprise Search"
DETACH=true bash $script_path/run-enterprise-search.sh

echo "--- :ruby: Run Client"
bash $script_path/run-client.sh
