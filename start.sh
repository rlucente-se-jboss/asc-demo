#!/bin/bash

. `dirname $0`/demo.conf

echo "Launching BPMS 6.0 ..."

PUSHD ${JBOSS_HOME}
    bin/standalone.sh &
POPD
