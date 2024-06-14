# Remote PC Control Script

This project contains a bash script that allows you to remotely control your Windows 11 PC from a MacBook. You can turn on your PC, start Parsec, and shut down your PC using SSH and Wake-on-LAN. This is useful for using your PC as a quick server or for gaming from another location.

## Features

- **Turn on your PC remotely** using Wake-on-LAN.
- **Start Parsec** on your PC to enable remote desktop and gaming.
- **Shut down your PC remotely** using SSH.

## Prerequisites

- A MacBook with macOS.
- A Windows 11 PC with SSH server installed and configured.
- Wake-on-LAN enabled on your Windows 11 PC.
- SSH keys set up for password-less login.

## Setup

### Step 1: Enable Wake-on-LAN on Your Windows 11 PC

1. **Enable WoL in BIOS/UEFI**:
   - Reboot your PC and enter the BIOS/UEFI settings (usually by pressing `Del`, `F2`, `F10`, or another key during startup).
   - Find and enable the "Wake on LAN" or "Power on by PCI-E" setting.
   - Save and exit the BIOS/UEFI settings.

2. **Enable WoL in Windows 11**:
   - Open Device Manager.
   - Expand the Network adapters section, right-click your network adapter, and select Properties.
   - Go to the Power Management tab and check "Allow this device to wake the computer" and "Only allow a magic packet to wake the computer".
   - Go to the Advanced tab, find "Wake on Magic Packet", and set it to Enabled.

### Step 2: Install and Configure an SSH Server on Your Windows 11 PC

1. **Install OpenSSH Server**:
   - Go to Settings > Apps > Optional Features > Add a feature.
   - Find and install "OpenSSH Server".

2. **Start and Enable the SSH Server**:
   - Open PowerShell as Administrator and run:
     ```powershell
     Start-Service sshd
     Set-Service -StartupType Automatic -Name sshd
     ```
   - Allow SSH through the Windows Firewall:
     ```powershell
     New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
     ```

### Step 3: Set Up Wake-on-LAN on Your MacBook

1. **Install Wake-on-LAN Tool**:
   - Install `wakeonlan` using Homebrew:
     ```sh
     brew install wakeonlan
     ```

## Usage

To use the script, run it with the appropriate parameter:

- To turn on the PC:
  ```sh
  ./remote_start.sh turn_on
  ```

- To start Parsec:
  ```sh
  ./remote_start.sh start_parsec
  ```

- To both turn on the PC and start Parsec:
  ```sh
  ./remote_start.sh both
  ```

- To shut down the PC:
  ```sh
  ./remote_start.sh shutdown
  ```

## Security

- **File Permissions**: Ensure that both `remote_config.sh` and `remote_start.sh` have appropriate file permissions to prevent unauthorized access.
- **Environment Variables**: Alternatively, you can export these variables in your shell profile (e.g., `.bash_profile` or `.zshrc`), but this might expose them to any process running in your user session.

## Purpose

This setup allows you to use your Windows PC as a quick server or for gaming from another location, providing flexibility and convenience. By turning on your PC, starting necessary applications, and shutting it down remotely, you can manage your PC efficiently without being physically present.
