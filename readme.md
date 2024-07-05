## README

### Remote PC and Docker Container Management Script

This script provides functionality to control a remote PC and manage Docker containers on it via SSH. It supports waking up the PC, starting applications like Parsec, shutting down or restarting the PC, and managing Docker containers using YAML configuration files.

### Features

1. **Remote PC Control**:
   - Wake up the PC using Wake-on-LAN.
   - Start the Parsec application on the remote PC.
   - Shut down or restart the remote PC.
   - Connect to the remote PC via SSH.

2. **Docker Container Management**:
   - Create Docker containers based on YAML configuration files.
   - Start, stop, and delete Docker containers.
   - List all running and existing Docker containers.

### Prerequisites

1. **Dependencies**:
   - `wakeonlan`: For waking up the PC remotely.
   - `ssh`: For connecting to the remote PC.
   - Docker: Installed and configured on the remote machine.

2. **Configuration**:
   - Ensure Wake-on-LAN is enabled in the BIOS of the remote PC.
   - Configure router settings to forward Wake-on-LAN packets.
   - Create an SSH key and configure SSH access to the remote PC.

### Installation

1. **Linux**:
   - Install `wakeonlan`:
     ```bash
     sudo apt-get install wakeonlan
     ```
   - Ensure Docker is installed and configured on the remote machine.

2. **macOS**:
   - Install `wakeonlan` using Homebrew:
     ```bash
     brew install wakeonlan
     ```
   - Docker installation should follow standard macOS procedures.

3. **Windows**:
   - Download and install a Wake-on-LAN tool suitable for Windows.
   - Ensure Docker Desktop is installed and configured on the remote Windows PC.

### Configuration File (`pc-secrets.sh`)

Create a `pc-secrets.sh` file in the script directory with the following variables:

```bash
# pc-secrets.sh

# Remote PC details
MAC_ADDRESS="00:11:22:33:44:55"   # MAC address for Wake-on-LAN
ROUTER_PUBLIC_IP="203.0.113.1"    # Router's public IP for Wake-on-LAN
PORT=9                            # Wake-on-LAN port
SSH_USER="your_ssh_username"      # SSH username for remote PC
SSH_KEY="/path/to/your/ssh/key"   # Path to SSH private key
HOSTNAME="remote.pc.hostname.or.ip"   # Remote PC hostname or IP

# Parsec application path (for Windows)
APPLICATION="C:\\Path\\To\\Parsec.exe"
```

### Usage

Run the script with the following commands:

- **Wake up the PC**:
  ```bash
  ./pc-remote-controller.sh turn_on
  ```

- **Start Parsec application**:
  ```bash
  ./pc-remote-controller.sh start_parsec
  ```

- **Both (Wake up and start Parsec)**:
  ```bash
  ./pc-remote-controller.sh both
  ```

- **Shutdown the PC**:
  ```bash
  ./pc-remote-controller.sh shutdown
  ```

- **Restart the PC**:
  ```bash
  ./pc-remote-controller.sh restart
  ```

- **Connect to the PC via SSH**:
  ```bash
  ./pc-remote-controller.sh connect
  ```

- **Create a Docker container** (replace `<yaml_file>` with your YAML file):
  ```bash
  ./pc-remote-controller.sh create_container <yaml_file>
  ```

- **Start a Docker container**:
  ```bash
  ./pc-remote-controller.sh start_container <container_name>
  ```

- **Stop a Docker container**:
  ```bash
  ./pc-remote-controller.sh stop_container <container_name>
  ```

- **Delete a Docker container**:
  ```bash
  ./pc-remote-controller.sh delete_container <container_name>
  ```

- **List all Docker containers**:
  ```bash
  ./pc-remote-controller.sh list_containers
  ```

### Detailed Command Help

For detailed command information, use:
```bash
./pc-remote-controller.sh <command> -h
```

### Troubleshooting

- Ensure Wake-on-LAN is correctly configured in the BIOS and router settings.
- Verify SSH connectivity and credentials (`pc-secrets.sh`).
- Check Docker installation and configuration on the remote machine.
- Review script logs and error messages for specific issues.

### Notes

- Customize paths and configurations in `pc-secrets.sh` according to your setup.
- Ensure Docker containers are configured properly in YAML files for container management commands.
