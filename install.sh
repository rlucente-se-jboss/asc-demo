#!/bin/bash

. `dirname $0`/demo.conf

function wait_for_eap_code() {
   timeout 20 grep -q $1 <(tail -f ${JBOSS_HOME}/standalone/log/server.log)
   echo "[ Server code detected: $1 ]"
   echo
}

function wait_for_eap_stop() {
  wait_for_eap_code JBAS015950
}

function wait_for_eap_start() {
   while [ ! -f "${JBOSS_HOME}/standalone/log/server.log" ]
   do
     sleep 1
   done

  wait_for_eap_code JBAS015874
}

PUSHD ${WORK_DIR}
    # clean existing install
    ./clean.sh

    # install BPMS 6
    java -jar ${BIN_DIR}/jboss-bpms-installer-${VER_BPMS_DIST}.jar auto.xml -variablefile auto.xml.variables

    mkdir -p runtimes
    PUSHD runtimes
        # expand the runtimes for JBDS
        unzip -q ${BIN_DIR}/jboss-bpms-${VER_BPMS_DIST}-deployable-generic.zip
        PUSHD jboss-bpms-${VER_BPMS_DIST}-deployable-generic
            unzip -q jboss-bpms-engine.zip
        POPD

        unzip -q ${BIN_DIR}/jboss-brms-${VER_BPMS_DIST}-deployable-generic.zip
        PUSHD jboss-brms-${VER_BPMS_DIST}-deployable-generic
            unzip -q jboss-brms-engine.zip
        POPD

        # apply the patch
        unzip -q ${BIN_DIR}/BZ-${VER_BPMS_PATCH}.zip
        PUSHD BZ-${VER_BPMS_PATCH}
            for i in `cat removed-list-bpms-eap6.x.txt`
            do
                rm -r ${JBOSS_HOME}/../$i
            done

            cp -r patch-deployable-eap6.x/* ${JBOSS_HOME}/..

            BPMS_ENGINE=../jboss-bpms-${VER_BPMS_DIST}-deployable-generic/jboss-bpms-engine
            for i in `cat removed-list-bpms-engine.txt`
            do
                rm -r ${BPMS_ENGINE}/$i
            done

            cp -r patch-bpms-engine/* ${BPMS_ENGINE}
        POPD

        unzip -q ${BIN_DIR}/BZ-${VER_BRMS_PATCH}.zip
        PUSHD BZ-${VER_BRMS_PATCH}
            BRMS_ENGINE=../jboss-brms-${VER_BPMS_DIST}-deployable-generic/jboss-brms-engine
            for i in `cat removed-list-brms-engine.txt`
            do
                rm -r ${BRMS_ENGINE}/$i
            done

            cp -r patch-brms-engine/* ${BRMS_ENGINE}
        POPD
    POPD

    # create users with other roles
    $JBOSS_HOME/bin/add-user.sh -a -p 'demo!123' -u broker1 -s -ro user,broker
    $JBOSS_HOME/bin/add-user.sh -a -p 'demo!123' -u broker2 -s -ro user,broker
    $JBOSS_HOME/bin/add-user.sh -a -p 'demo!123' -u manager1 -s -ro user,manager
    $JBOSS_HOME/bin/add-user.sh -a -p 'demo!123' -u manager2 -s -ro user,manager
    $JBOSS_HOME/bin/add-user.sh -a -p 'demo!123' -u appraiser1 -s -ro user,appraiser
    $JBOSS_HOME/bin/add-user.sh -a -p 'demo!123' -u appraiser2 -s -ro user,appraiser

    # add the mysql driver and datasource
    mkdir -p ${JBOSS_HOME}/modules/com/mysql/main
    cp ${BIN_DIR}/mysql-connector-java.jar ${JBOSS_HOME}/modules/com/mysql/main
    cp ${WORK_DIR}/module.xml ${JBOSS_HOME}/modules/com/mysql/main

    PUSHD ${JBOSS_HOME}
        bin/standalone.sh &
        wait_for_eap_start

        bin/jboss-cli.sh --connect --file=${WORK_DIR}/mysql-datasource.cli
        sleep 10

        pkill -u $USER java
        wait_for_eap_stop
    POPD
POPD
