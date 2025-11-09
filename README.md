# system-bootstrap
Scripts to automate the initial setup of any operating system, including development environments, system configurations, and personal preferences.

## Usage

### WSL Debian Setup

To set up a Debian environment in WSL:

1. Open Command Prompt or PowerShell as Administrator.

2. Change to the wsl directory:
   cd wsl
   ```

3. Install WSL and Debian using the provided scripts:
   - For Command Prompt: `install_wsl2_debian.cmd`
   - For PowerShell: `install_wsl2_debian.ps1`

2. Once Debian is installed, run the bootstrap script to configure the system:
   ```bash
   cd cd /path/to/system-bootstrap/wsl/scripts/debian/13
   sudo ./bootstrap.sh
   ```

   Note: Adjust the path according to where you cloned the repository on your Windows system. In WSL, Windows drives are mounted under `/mnt/` (e.g., C: drive is `/mnt/c`).

The bootstrap script will:
- Configure APT sources for Debian 13 (Trixie)
- Update and upgrade the system
- Install essential packages
- Set up timezone and locale
- Configure shell environment (.bashrc)
- Install additional tools like wsl2-ssh-agent

Note: The script requires root privileges and internet access. It includes error handling and will exit on any failure to ensure a clean setup.
