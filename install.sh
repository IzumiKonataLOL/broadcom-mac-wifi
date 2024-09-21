#!/bin/bash

distro=$(grep "^ID=" /etc/os-release | cut -d '=' -f 2)

install_broadcom_debian() {
    echo "Detected Ubuntu/Debian-based system"
    sudo apt-get update
    sudo apt-get install -y linux-headers-$(uname -r|sed 's,[*-]*-[*-]*-,,') broadcom-sta-dkms
    sudo modprobe -r b44 b43 b43legacy ssb brcmsmac
    sudo modprobe wl
}

install_broadcom_arch() {
    echo "Detected Arch-based system"
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm broadcom-wl-dkms
    sudo modprobe -r b44 b43 b43legacy ssb brcmsmac
    sudo modprobe wl
}

case "$distro" in
    "ubuntu"|"debian")
        install_broadcom_debian
        ;;
    "arch")
        install_broadcom_arch
        ;;
    *)
        echo "Unsupported distribution: $distro"
        exit 1
        ;;
esac
