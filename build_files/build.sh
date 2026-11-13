#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

dnf5 install -y \
    tmux \
    kitty \
    incus \
    incus-tools \
    qemu-kvm \
    edk2-ovmf

# Install isx and isx-proxy from COPR, then disable the COPR repo
dnf5 -y copr enable sanne/incus-spawn
dnf5 -y install incus-spawn
dnf5 -y copr disable sanne/incus-spawn

# Remove unwanted packages
dnf5 remove -y \
    lutris \
    waydroid \
    waydroid-selinux

#### Enable System Unit Files

systemctl enable podman.socket
systemctl enable incus.socket incus.service

# Remove leftovers from dnf
dnf5 clean all && \
    rm -rf /var/cache/dnf /var/cache/libdnf5 /var/lib/dnf/* /run/dnf /run/selinux-policy
