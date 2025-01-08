#!/bin/bash

#
# ansible installation on dom0 is requred
#
echo "Installing ansible and missing collections"
sudo qubes-dom0-update -y ansible
