#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

export ANSIBLE_STDOUT_CALLBACK=debug
# Shouldn't be done <wut I'm too bad to figure out how to do it
export openstack_creds=/etc/bolla/openstack_openrc

#-------------------------------------------------------------------------------
# Check run as root
#-------------------------------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit -1
fi

echo "
#-------------------------------------------------------------------------------
# Prepare nodes and rancher
#-------------------------------------------------------------------------------
"

source ${openstack_creds}
ansible-playbook opnfv-prepare.yaml

echo "
#-------------------------------------------------------------------------------
# Run rancher-k8s
#-------------------------------------------------------------------------------
"

ansible-playbook -i /etc/r8s/inventory.yaml opnfv-k8s-install.yaml

echo "
#-------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------
"
