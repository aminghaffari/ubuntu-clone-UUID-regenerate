#!/bin/bash

set -e

echo "======================================="
echo " Linux Clone Post-Setup Automation"
echo "======================================="

# Root check
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root:"
  echo "sudo bash $0"
  exit 1
fi

# Hostname
read -p "Enter new hostname: " NEW_HOSTNAME

if [ -n "$NEW_HOSTNAME" ]; then
  echo "[+] Setting hostname..."
  hostnamectl set-hostname "$NEW_HOSTNAME"
fi

# Machine ID
echo "[+] Regenerating machine-id..."
truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id
systemd-machine-id-setup

# SSH Keys
echo "[+] Regenerating SSH host keys..."
rm -f /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server

# DHCP leases
echo "[+] Removing old DHCP leases..."
rm -rf /var/lib/dhcp/*

# Cloud-init cleanup
if command -v cloud-init >/dev/null 2>&1; then
  echo "[+] Cleaning cloud-init..."
  cloud-init clean
fi

# Netplan detection
if [ -d /etc/netplan ]; then
  echo "[+] Netplan configuration detected."

  read -p "Do you want to edit network config now? (y/n): " EDIT_NET

  if [[ "$EDIT_NET" =~ ^[Yy]$ ]]; then
    nano /etc/netplan/*.yaml

    echo "[+] Applying netplan..."
    netplan generate
    netplan apply
  fi
fi

# Restart SSH
echo "[+] Restarting SSH service..."
systemctl restart ssh || systemctl restart sshd

echo ""
echo "======================================="
echo " Clone cleanup completed successfully"
echo "======================================="
echo ""
echo "Recommended next steps:"
echo "1. Change VM MAC address from hypervisor"
echo "2. Reboot system"
echo ""
