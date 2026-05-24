# Linux VM post-clone initialization toolkit

A small utility/checklist for preparing cloned Linux machines before putting them into production.

Features:

* Regenerate machine-id
* Recreate SSH host keys
* Update hostname
* Reset DHCP leases
* Prepare templates for cloud-init environments
* Avoid conflicts between cloned VMs on the same network

Useful for VMware, Proxmox, VirtualBox, KVM and other virtualization platforms.
