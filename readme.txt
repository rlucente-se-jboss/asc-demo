These scripts simplify creating a clean, never-been-run installation of
BPMS 6 with the latest rollup patch applied.  The scripts also set up a
properly patched directory of runtimes for JBDS to use for both Drools
and jBPM.

To use this, edit the demo.conf file and make sure the "dist" directory
contains the following files:

    jboss-bpms-installer-6.0.3.GA-redhat-1.jar
    jboss-bpms-6.0.3.GA-redhat-1-deployable-generic.zip
    jboss-brms-6.0.3.GA-redhat-1-deployable-generic.zip
    BZ-1174359.zip  (the BPMS 6.0.3 rollup 2 patch)
    BZ-1174357.zip  (the BRMS 6.0.3 rollup 2 patch)

The auto.xml script should also be edited so that the <installpath/>
element matches the intended installation location.  This script will
install BPMS 6 in the same directory as these scripts.  I currently
target $HOME/asc-demo/bpms so the installed directory is actually
$HOME/asc-demo/bpms/jboss-eap-6.1

After that, to remove an installation, simply type:

    ./clean.sh

And to install the software, simply type:

    ./install.sh

The fully patched runtimes for JBDS are located at:

    Drools Runtime:  $HOME/asc-demo/runtimes/jboss-brms-6.0.3.GA-redhat-1-deployable-generic/jboss-brms-engine
      jBPM Runtime:  $HOME/asc-demo/runtimes/jboss-bpms-6.0.3.GA-redhat-1-deployable-generic/jboss-bpms-engine

The install.sh script adds additional users for BPMS.  You can modify
these as needed.  The auto.xml.variable file contains the password for
the bpmsAdmin user.

Github Repositories
-------------------

BPMS 6 PoC with workflows, task forms, rules, etc:
https://github.com/rlucente-se-jboss/bpmdemo.git

Data model for PoC with persistence:
https://github.com/bit4man/bpmdemo1.git

