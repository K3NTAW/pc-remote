## README

### Remote PC Control Script

This script allows you to control a remote PC by waking it up, starting the Parsec application, shutting it down, restarting it, and connecting to it via SSH.

### Features

1. **Wake up the PC**: Use Wake-on-LAN to wake up the remote PC.
2. **Start Parsec**: Start the Parsec application on the remote PC.
3. **Both**: Perform both wake up and start Parsec.
4. **Shutdown**: Shut down the remote PC.
5. **Restart**: Restart the remote PC.
6. **Connect**: Connect to the remote PC via SSH.

### Prerequisites

- **Wake-on-LAN Configuration**:
  - Ensure that Wake-on-LAN is enabled in the BIOS of the remote PC.
  - Configure your router to forward the necessary ports for Wake-on-LAN.
  - Create a firewall rule to allow Wake-on-LAN packets through.

### Software Installation

#### Linux

Install `wakeonlan` on the machine where this script will be run:

```sh
sudo apt-get install wakeonlan
```

#### macOS

Install `wakeonlan` using Homebrew:

```sh
brew install wakeonlan
```

#### Windows

For Windows, you can download the Wake-on-LAN tool from the internet or use the PowerShell script below to install it:

1. Download the Wake-on-LAN tool from [Depicus](https://www.depicus.com/wake-on-lan).
2. Alternatively, use PowerShell:

```powershell
Install-Module -Name WakeOnLAN -Scope CurrentUser
```

### Configuration File (`pc-secrets.sh`)

Create a file named `pc-secrets.sh` in the same directory as your script and include the following variables:

```sh
# pc-secrets.sh

# MAC address of the remote PC
MAC_ADDRESS="00:11:22:33:44:55"

# Router's public IP address
ROUTER_PUBLIC_IP="203.0.113.1"

# Port number for Wake-on-LAN
PORT=9

# SSH configuration
SSH_USER="your_ssh_username"
SSH_KEY="/path/to/your/ssh/key"
HOSTNAME="remote.pc.hostname.or.ip"

# Parsec application path on the remote PC
APPLICATION="C:\\Path\\To\\Parsec.exe"
```

#### Commands

- **turn_on**: Wake up the PC and check connectivity.
  ```sh
  ./pc-remote-controller.sh turn_on
  ```
- **start_parsec**: Start Parsec application on the remote machine.
  ```sh
  ./pc-remote-controller.sh start_parsec
  ```
- **both**: Perform both turn_on and start_parsec.
  ```sh
  ./pc-remote-controller.sh both
  ```
- **shutdown**: Shutdown the remote PC.
  ```sh
  ./pc-remote-controller.sh shutdown
  ```
- **restart**: Restart the remote PC.
  ```sh
  ./pc-remote-controller.sh restart
  ```
- **connect**: Connect to the remote PC via SSH.
  ```sh
  ./pc-remote-controller.sh connect
  ```

#### Options

- **-h, --help**: Show help message and exit.

### Detailed Command Help

For detailed command help, use:

```sh
./pc-remote-controller.sh <command> -h
```

### Example

To wake up the remote PC and start Parsec:

```sh
./pc-remote-controller.sh both
```

### Troubleshooting

- Ensure Wake-on-LAN is properly configured in the BIOS of the remote PC.
- Verify port forwarding and firewall rules for Wake-on-LAN.
- Check SSH connectivity to the remote PC using the provided SSH key and user.

### Notes

- This script assumes you have SSH access to the remote PC and the `psexec.exe` tool installed for starting applications on Windows.
- Modify the paths and user details in `pc-secrets.sh` according to your setup.