#!/usr/bin/env bash

script_path=$(dirname $(realpath -s $0))
source $script_path/functions/imports.sh
set -euo pipefail

docker run \
       --name "kibana" \
       --network "$network_name" \
       --publish "5601:5601" \
       --interactive \
       --tty \
       --rm \
       --env "ENTERPRISESEARCH_HOST=http://localhost:3002" \
       "docker.elastic.co/kibana/kibana:${STACK_VERSION}"

# --volume $ssl_ca:/usr/share/elasticsearch/config/certs/ca.crt \

# --env "ELASTICSEARCH_HOSTS=${elasticsearch_url}" \
  # --env "ELASTICSEARCH_USERNAME=enterprise_search" \
  # --env "ELASTICSEARCH_PASSWORD=${elastic_password}" \
  # --env "ELASTICSEARCH_SSL_CERTIFICATEAUTHORITIES=${ssl_ca}" \
