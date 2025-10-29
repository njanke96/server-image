#!/bin/bash

set -ouex pipefail

#
## sudo NOPASSWD for %wheel
#
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> '/etc/sudoers.d/wheel_nopasswd'

#
## Services personal preference
# 
systemctl enable crond.service
systemctl enable bootc-fetch-apply-updates.timer
systemctl disable rpm-ostreed-automatic.timer
systemctl disable firewalld
systemctl disable coreos-container-signing-migration-motd.service
