#!/usr/bin/env bash
set -euo pipefail

echo "Cleaning machine-specific data..."

sudo cloud-init clean --logs

sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

sudo rm -f /etc/ssh/ssh_host_*

sudo apt-get autoremove -y
sudo apt-get clean

history -c || true

echo "Cleanup completed."
