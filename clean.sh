#!/bin/bash

. `dirname $0`/demo.conf

PUSHD ${WORK_DIR}
    rm -fr bpms runtimes
POPD
