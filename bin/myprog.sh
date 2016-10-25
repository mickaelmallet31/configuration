#!/bin/bash
#
# this script should not be run directly,
# instead you need to source it from your .bashrc,
# by adding this line:
#   . ~/bin/myprog.sh
#

function mcd() {
  path=`grep -R 'name="'$1'"' .repo/manifests/*|sed -e 's/.*path="//' -e 's/".*//'|head -1`
  echo 'Changing to '$path
  cd $path
}

function screen_kill()
{
    screen -X -S $1 kill
    set +x
}

function ssp()
{
    ssh -i /home/mickaelm/.ssh/porcinet_rsa root@$1
}

function ssb()
{
    labID=`echo $1|sed -e 's/\..*//'`
    machineID=`echo $1|sed -e 's/.*\.//'`
    siteID=`echo $labID|sed -e 's/[0-9]//'`
    ssh -i /home/mickaelm/.ssh/exploit-prod exploit-prod@${labID}sisbld${machineID}l.${siteID}.intel.com
}

function ssc()
{
    machine=$1
    case $machine in
    jf*)
        site=.jf.intel.com
        ;;
    sh*)
        site=.sh.intel.com
        ;;
    esac
    set -x
	ssh -i /home/mickaelm/.ssh/id_rsa_cortex2 core@$1$site
    #ssh -i /home/mickaelm/.ssh/id_rsa core@$1$site
    set +x
}

function sp() {
    for name in $*
    do
        i=`echo $name|sed -e "s/sisbld/\./" -e "s/l$//"`
        set -x
        fleetctl stop slave-prod-meta@$i slave-prod-micro@$i
        fleetctl start slave-prod-meta@$i slave-prod-micro@$i
        set +x
    done
}

function spme() {
    for name in $*
    do
        i=`echo $name|sed -e "s/sisbld/\./" -e "s/l$//"`
        set -x
        fleetctl stop slave-prod-meta@$i
        fleetctl start slave-prod-meta@$i
        set +x
    done
}

function spmi() {
    for name in $*
    do
        i=`echo $name|sed -e "s/sisbld/\./" -e "s/l$//"`
        set -x
        fleetctl stop slave-prod-micro@$i
        fleetctl start slave-prod-micro@$i
        set +x
    done
}

function stp() {
    for name in $*
    do
        i=`echo $name|sed -e "s/sisbld/\./" -e "s/l$//"`
        set -x
        fleetctl stop slave-prod-meta@$i slave-prod-micro@$i
        set +x
    done
}

function stt() {
    for name in $*
    do
        i=`echo $name|sed -e "s/sisbld/\./" -e "s/l$//"`
        set -x
        fleetctl stop slave-testprod-meta@$i slave-testprod-micro@$i
        set +x
    done
}


function stestprod() {
    for name in $*
    do
        i=`echo $name|sed -e "s/sisbld/\./" -e "s/l$//"`
        set -x
        fleetctl stop slave-testprod-meta@$1 slave-testprod-micro@$1
        fleetctl start slave-testprod-meta@$1 slave-testprod-micro@$1
        set +x
    done
}

function start_stage() {
    for name in $*
    do
        i=`echo $name|sed -e "s/sisbld/\./" -e "s/l$//"`
        set -x
        fleetctl stop slave-stage-meta@$1 slave-stage-micro@$1
        fleetctl start slave-stage-meta@$1 slave-stage-micro@$1
        set +x
    done
}

function stop_stage() {
    for name in $*
    do
        i=`echo $name|sed -e "s/sisbld/\./" -e "s/l$//"`
        set -x
        fleetctl stop slave-stage-meta@$1 slave-stage-micro@$1
        set +x
    done
}

function docker_meta() {
    machine=$1
    /usr/bin/docker run -d --hostname=$machine --name=slave-prod-meta --add-host $machine:${COREOS_PUBLIC_IPV4} -e BBMASTERPORT=9990 -e BBMASTERADDR=buildbot.tl.intel.com --volume=/var/lib/docker/buildbot-data:/data --volume=/storage/buildbot:/buildbot --volume=/storage/tarballs:/data/tarballs docker-registry.intel.com/mojave/slave-prod
}

function docker_micro() {
    machine=$1
    /usr/bin/docker run -d --hostname=$machine --name=slave-prod-micro --add-host $machine:${COREOS_PUBLIC_IPV4} -e BBMASTERPORT=9991 -e BBMASTERADDR=buildbot.tl.intel.com --volume=/var/lib/docker/buildbot-data:/data --volume=/storage/buildbot:/buildbot --volume=/storage/tarballs:/data/tarballs docker-registry.intel.com/mojave/slave-prod
}

