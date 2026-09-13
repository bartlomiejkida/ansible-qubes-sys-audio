#!/bin/bash

#
# ansible installation on dom0 is required (Qubes 4.3+).
# The qubes-ansible package provides the official qubesos.core and
# qubesos.security Ansible collections (qubes connection plugin and
# qubes_proxy strategy), see https://github.com/QubesOS/qubes-ansible
#
echo "Installing ansible and qubes-ansible on dom0"
sudo qubes-dom0-update -y ansible qubes-ansible

# For Debian-based dom0, the qubes_proxy strategy is packaged separately:
# sudo qubes-dom0-update -y qubes-ansible-admin
