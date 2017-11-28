#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

export ANSIBLE_STDOUT_CALLBACK=debug

#-------------------------------------------------------------------------------
# Check run as root
#-------------------------------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit -1
fi

echo "
#-------------------------------------------------------------------------------
# install ansible
#-------------------------------------------------------------------------------
"

# remove old ansible
if pip freeze|grep ansible=; then
    pip uninstall -y ansible
fi
# remove folders
rm -rf /usr/local/bin/ansible*
rm -rf /etc/ansible/
# install ansible from package
apt update
apt install -y software-properties-common python-setuptools \
    python-dev libffi-dev libssl-dev git python-pip
pip install --upgrade pip cryptography ansible netaddr
mkdir -p /etc/ansible
echo "jumphost ansible_connection=local" > /etc/ansible/hosts

# put default values for ansible
cat > /etc/ansible/ansible.cfg <<EOF
[defaults]
forks=50
host_key_checking = False
[ssh_connection]
pipelining=True
EOF

cd /opt/r8s

echo "
#-------------------------------------------------------------------------------
# Prepare nodes and rancher
#-------------------------------------------------------------------------------
"

ansible-playbook opnfv-prepare.yaml

echo "
#-------------------------------------------------------------------------------
# Run rancher-k8s
#-------------------------------------------------------------------------------
"

ansible-playbook -i /etc/r8s/inventory  opnfv-k8s-install.yaml

echo "
#-------------------------------------------------------------------------------
# End
#-------------------------------------------------------------------------------
"
