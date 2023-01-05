#!/usr/bin/env bash
#
# This script is intended to be run after the build in a Buildkite pipeline
echo "--- Test summary"
buildkite-agent artifact download "tmp/*.html" .

files="tmp/*.html"
for f in $files; do
  SERVICE=`echo $f | grep -o "\(appsearch\|enterprisesearch\|workplacesearch\)"`
  RUBY_VERSION=`echo $f | grep -Po "(\d+\.)+\d+"`
  EXAMPLES=`cat $f | grep -o "[0-9]\+ examples" | tail -1`
  FAILURES=`cat $f | grep -o "[0-9]\+ failures" | tail -1`
  PENDING=`cat $f | grep -o "[0-9]\+ pending" | tail -1`
  echo "--- :rspec: $EXAMPLES - :x: $FAILURES - :pinched_fingers: $PENDING :test_tube: $SERVICE :ruby: $RUBY_VERSION"
done
