# Enable WSL features
Write-Host "Enabling WSL features..."
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart

# Set WSL default version
Write-Host "Setting WSL default version to 2..."
wsl --set-default-version 2

# Install Debian
Write-Host "Installing Debian..."
wsl --install -d Debian

Write-Host "Installation complete. Please restart your computer to apply changes."