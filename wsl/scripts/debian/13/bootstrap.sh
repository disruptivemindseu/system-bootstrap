#!/usr/bin/env bash

set -euo pipefail

echo "Starting Debian 13 bootstrap script..."

# Ensure apt-transport-https is installed
echo "Installing apt-transport-https and ca-certificates..."
apt install -y apt-transport-https ca-certificates

# Set up APT sources for Debian 13 (Trixie)
echo "Setting up APT sources..."
DEBIAN_MIRROR=${DEBIAN_MIRROR:-deb.debian.org}
source /etc/os-release

rm -f /etc/apt/sources.list

# Create APT source files
sed "s/@DEBIAN_MIRROR@/${DEBIAN_MIRROR}/g; s/@VERSION_CODENAME@/${VERSION_CODENAME}/g" debian.sources.template > /etc/apt/sources.list.d/debian.sources
sed "s/@DEBIAN_MIRROR@/${DEBIAN_MIRROR}/g; s/@VERSION_CODENAME@/${VERSION_CODENAME}/g" debian-backports.sources.template > /etc/apt/sources.list.d/debian-backports.sources

# Clear APT cache
echo "Clearing APT cache..."
find /var/lib/apt/lists -type f -delete

# Update and upgrade existing packages
echo "Updating and upgrading packages..."
apt update
apt dist-upgrade -y
apt autoremove --purge
apt clean

# Configure timezone
echo "Configuring timezone..."
echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections
echo 'tzdata tzdata/Zones/Europe select Luxembourg' | debconf-set-selections
rm -f /etc/localtime /etc/timezone
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure tzdata

# Preconfigure packages to avoid interactive prompts
echo "Preconfiguring packages..."
echo "iperf3 iperf3/start_daemon boolean false" | debconf-set-selections
echo "sysstat sysstat/enable boolean true" | debconf-set-selections
echo "wireshark-common wireshark-common/install-setuid boolean false" | debconf-set-selections

# Install common packages
echo "Installing common packages..."
apt install -y $(cat packages.list)

echo "Updating command-not-found database..."
apt update                    # To populate command-not-found database
echo "Reinstalling iputils-ping..."
apt reinstall iputils-ping -y # Reinstall ping to ensure SUID bit is set

echo "Copying bashrc files..."
cp ../../../files/debian/13/etc/skel/.bashrc /etc/skel/.bashrc
cp ../../../files/debian/13/root/.bashrc /root/.bashrc

# Install wsl2-ssh-agent
echo "Installing wsl2-ssh-agent..."
curl -L -o /usr/local/bin/wsl2-ssh-agent https://github.com/mame/wsl2-ssh-agent/releases/latest/download/wsl2-ssh-agent
chmod +x /usr/local/bin/wsl2-ssh-agent

echo "Bootstrap script completed successfully."

