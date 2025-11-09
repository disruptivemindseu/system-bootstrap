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

rm /etc/apt/sources.list

# Create APT source files
cat <<EOF > /etc/apt/sources.list.d/debian.sources
Types: deb deb-src
URIs: https://${DEBIAN_MIRROR}/debian/
Suites: ${VERSION_CODENAME}
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb deb-src
URIs: https://${DEBIAN_MIRROR}/debian-security/
Suites: ${VERSION_CODENAME}-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb deb-src
URIs: https://${DEBIAN_MIRROR}/debian/
Suites: ${VERSION_CODENAME}-updates
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

EOF

# Create backports source file
cat <<EOF > /etc/apt/sources.list.d/debian-backports.sources
Types: deb deb-src
URIs: https://${DEBIAN_MIRROR}/debian/
Suites: ${VERSION_CODENAME}-backports
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

EOF

# Clear APT cache
echo "Clearing APT cache..."
find /var/lib/apt/lists -type f -delete

# Update and upgrade existing packages
echo "Updating and upgrading packages..."
apt update && apt dist-upgrade -y && apt autoremove --purge && apt clean

# Configure timezone
echo "Configuring timezone..."
echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections
echo 'tzdata tzdata/Zones/Europe select Luxembourg' | debconf-set-selections
rm /etc/localtime /etc/timezone
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure tzdata

# Preconfigure packages to avoid interactive prompts
echo "Preconfiguring packages..."
echo "iperf3 iperf3/start_daemon boolean false" | debconf-set-selections
echo "sysstat sysstat/enable boolean true" | debconf-set-selections
echo "wireshark-common wireshark-common/install-setuid boolean false" | debconf-set-selections

# Install common packages
echo "Installing common packages..."
apt install -y      \
  bash-completion   \
  bind9-host        \
  bridge-utils      \
  build-essential   \
  command-not-found \
  curl              \
  dos2unix          \
  emacs-nox         \
  ethtool           \
  fail2ban          \
  fping             \
  git               \
  gpg               \
  htop              \
  icdiff            \
  iftop             \
  iperf3            \
  iptables          \
  iptraf-ng         \
  iputils-arping    \
  jq                \
  locales           \
  locate            \
  man-db            \
  mc                \
  mtr-tiny          \
  net-tools         \
  netcat-openbsd    \
  nload             \
  nmon              \
  openssh-client    \
  pipx              \
  psmisc            \
  pwgen             \
  rclone            \
  rename            \
  rsync             \
  sudo              \
  sysstat           \
  tcpdump           \
  tmux              \
  tmuxinator        \
  tshark            \
  unzip             \
  vim               \
  vlan              \
  wakeonlan         \
  wget              \
  whois             \

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

