#!/bin/bash

cat /etc/*release
uname -a
cat /proc/meminfo | head -6
vboxmanage --version
vagrant --version
ansible --version
#  configured module search path = None
vagrant box list
