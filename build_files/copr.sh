#!/bin/bash
#
# COPR Packages
alias dnf='dnf5'

#
## zellij
#
dnf -y copr enable varlad/zellij 
dnf -y install zellij
