#!/bin/bash

source /Users/taawake2/projects/personal/scripts/project/pc-secrets.sh

ACTION=$1
SUB_COMMAND=$2
YAML_FILE=$2

REMOTE_SSH="ssh -i $SSH_KEY $SSH_USER@$HOSTNAME"

show_help() {
    echo "PC remote controller help"
    echo "  turn_on       : Wake up the PC and check connectivity."
    echo "  start_parsec  : Start Parsec application on the remote machine."
    echo "  both          : Perform both turn_on and start_parsec."
    echo "  shutdown      : Shutdown the remote PC."
    echo "  restart       : Restart the remote PC."
    echo "  connect       : Connect to the remote PC via SSH."
    echo "  create_container <yaml_file> : Create a Docker container based on the YAML configuration."
    echo "  start_container <container_name> : Start the specified Docker container."
    echo "  stop_container <container_name> : Stop the specified Docker container."
    echo "  delete_container <container_name> : Delete the specified Docker container."
    echo "  list_containers : List all running and existing Docker containers."
    echo ""
    echo "For specific command help use:"
    echo "  $0 <command> -h or --help"
    exit 1
}

create_container() {
    local yaml_file=$1

    echo "Creating Docker container using YAML file: $yaml_file"  # Log the YAML file name

    if [ ! -f "$yaml_file" ]; then
        echo "YAML file not found at path: $yaml_file"
        exit 1
    fi

    container_name=$(yq e '.container_name' "$yaml_file")
    image=$(yq e '.image' "$yaml_file")
    ports=$(yq e '.ports[]' "$yaml_file" | awk '{print "-p "$1}')
    volumes=$(yq e '.volumes[]' "$yaml_file" | awk '{print "-v "$1}')
    env_vars=$(yq e '.environment[]' "$yaml_file" | awk '{print "-e "$1}')

    echo "Creating container with name: $container_name, image: $image, ports: $ports, volumes: $volumes, env_vars: $env_vars"

    $REMOTE_SSH "docker create --name \"$container_name\" $ports $volumes $env_vars \"$image\""
    if [ $? -eq 0 ]; then
        echo "Container '$container_name' created successfully."
    else
        echo "Failed to create container '$container_name'."
    fi
}


# Function to start a Docker container on the remote machine
start_container() {
    local container_name=$1
    $REMOTE_SSH "docker start \"$container_name\""
    if [ $? -eq 0 ]; then
        echo "Container '$container_name' started successfully."
    else
        echo "Failed to start container '$container_name'."
    fi
}

# Function to stop a Docker container on the remote machine
stop_container() {
    local container_name=$1
    $REMOTE_SSH "docker stop \"$container_name\""
    if [ $? -eq 0 ]; then
        echo "Container '$container_name' stopped successfully."
    else
        echo "Failed to stop container '$container_name'."
    fi
}

# Function to delete a Docker container on the remote machine
delete_container() {
    local container_name=$1
    $REMOTE_SSH "docker rm \"$container_name\""
    if [ $? -eq 0 ]; then
        echo "Container '$container_name' deleted successfully."
    else
        echo "Failed to delete container '$container_name'."
    fi
}

# Function to list Docker containers on the remote machine
list_containers() {
    echo "Running containers on remote machine:"
    $REMOTE_SSH "docker ps"
    echo ""
    echo "All containers on remote machine:"
    $REMOTE_SSH "docker ps -a"
}

show_command_help() {
    local command=$1

    case $command in
        "turn_on")
            echo "Command: turn_on"
            echo "Description: Wakes up the PC using Wake-on-LAN and checks connectivity."
            echo "Usage: $0 turn_on"
            echo ""
            echo "Detailed Information:"
            echo "  This command sends a Wake-on-LAN packet to the PC's MAC address to wake it up."
            echo "  It then waits for the PC to become reachable by pinging its local IP address."
            echo ""
            exit 0
            ;;
        "start_parsec")
            echo "Command: start_parsec"
            echo "Description: Starts the Parsec application on the remote machine."
            echo "Usage: $0 start_parsec"
            echo ""
            echo "Detailed Information:"
            echo "  This command initiates the Parsec application on the remote PC using SSH."
            echo "  It uses psexec to start the application in the background."
            echo ""
            exit 0
            ;;
        "both")
            echo "Command: both"
            echo "Description: Performs both turn_on (Wake-on-LAN) and start_parsec (Parsec application)."
            echo "Usage: $0 both"
            echo ""
            echo "Detailed Information:"
            echo "  This command combines the functionalities of turn_on and start_parsec."
            echo "  It first wakes up the PC and then starts the Parsec application on it."
            echo ""
            exit 0
            ;;
        "shutdown")
            echo "Command: shutdown"
            echo "Description: Shuts down the remote PC."
            echo "Usage: $0 shutdown"
            echo ""
            echo "Detailed Information:"
            echo "  This command sends a shutdown signal to the remote PC using SSH."
            echo "  It uses the shutdown command with a timeout of 0 seconds."
            echo ""
            exit 0
            ;;
        "restart")
            echo "Command: restart"
            echo "Description: Restarts the remote PC."
            echo "Usage: $0 restart"
            echo ""
            echo "Detailed Information:"
            echo "  This command sends a restart signal to the remote PC using SSH."
            echo "  It uses the shutdown command with the /r option."
            echo ""
            exit 0
            ;;
        "connect")
            echo "Command: connect"
            echo "Description: Connect to the remote PC via SSH."
            echo "Usage: $0 connect"
            echo ""
            echo "Detailed Information:"
            echo "  This command opens an SSH connection to the remote PC."
            echo "  It uses the ssh command with the configured user and hostname."
            echo ""
            exit 0
            ;;
        "create_container")
            echo "Command: create_container"
            echo "Description: Creates a Docker container based on the YAML configuration."
            echo "Usage: $0 create_container <yaml_file>"
            echo ""
            echo "Detailed Information:"
            echo "  This command reads the YAML file and creates a Docker container based on its contents."
            echo ""
            exit 0
            ;;
        "start_container")
            echo "Command: start_container"
            echo "Description: Starts the specified Docker container."
            echo "Usage: $0 start_container <container_name>"
            echo ""
            echo "Detailed Information:"
            echo "  This command starts a Docker container that has already been created."
            echo ""
            exit 0
            ;;
        "stop_container")
            echo "Command: stop_container"
            echo "Description: Stops the specified Docker container."
            echo "Usage: $0 stop_container <container_name>"
            echo ""
            echo "Detailed Information:"
            echo "  This command stops a running Docker container."
            echo ""
            exit 0
            ;;
        "delete_container")
            echo "Command: delete_container"
            echo "Description: Deletes the specified Docker container."
            echo "Usage: $0 delete_container <container_name>"
            echo ""
            echo "Detailed Information:"
            echo "  This command deletes a Docker container."
            echo ""
            exit 0
            ;;
        "list_containers")
            echo "Command: list_containers"
            echo "Description: Lists all running and existing Docker containers."
            echo "Usage: $0 list_containers"
            echo ""
            echo "Detailed Information:"
            echo "  This command lists all Docker containers, showing which ones are running and which ones exist but are not running."
            echo ""
            exit 0
            ;;
        *)
            echo "Invalid command."
            show_help
            ;;
    esac

    exit 1
}

show_loading_bar() {
    local duration=$1
    local updates=100
    local sleep_interval=$(bc -l <<< "$duration / $updates")
    local elapsed=0
    local percent=0

    for ((i=1; i<=updates; i++)); do
        echo -ne "Progress: $percent%\r"
        percent=$((percent + 100 / updates))
        sleep $sleep_interval
        elapsed=$(bc -l <<< "$elapsed + $sleep_interval")
    done

    echo -ne "Progress: 100%\n"
}

wake_pc() {
    echo "Sending Wake-on-LAN packet to $MAC_ADDRESS at $ROUTER_PUBLIC_IP:$PORT..."
    wakeonlan -i $ROUTER_PUBLIC_IP -p $PORT $MAC_ADDRESS
    
    echo "Waiting for the PC to wake up..."
    show_loading_bar 60
    
    if ping -c 1 -W 1 $ROUTER_PUBLIC_IP >/dev/null 2>&1; then
        echo "The PC is now awake and reachable at $ROUTER_PUBLIC_IP."
    else
        echo "Failed to reach the PC. It may not have woken up correctly."
    fi
}

start_parsec() {
    echo "Starting Parsec on $HOSTNAME..."
    ssh $SSH_USER@$HOSTNAME "C:\\Sysinternals\\psexec.exe -i 1 -d \"$APPLICATION\""
    SSH_STATUS=$?

    if [ $SSH_STATUS -eq 0 ]; then
        echo "Parsec has been started successfully."
    else
        echo "Failed to start Parsec. Please check the connection and the command."
    fi
}

restart_pc() {
    echo "Restarting the PC at $HOSTNAME..."
    ssh -i $SSH_KEY $SSH_USER@$HOSTNAME "shutdown /r /t 0"
    SSH_STATUS=$?

    if [ $SSH_STATUS -eq 0 ]; then
        echo "PC is restarting."
    else
        echo "Failed to restart the PC. Please check the connection and the command."
    fi
}

shutdown_pc() {
    echo "Shutting down the PC at $HOSTNAME..."
    ssh -i $SSH_KEY $SSH_USER@$HOSTNAME "shutdown /s /t 0"
    SSH_STATUS=$?

    if [ $SSH_STATUS -eq 0 ]; then
        echo "PC is shutting down."
    else
        echo "Failed to shutdown the PC. Please check the connection and the command."
    fi
}

connect_ssh() {
    echo "Connecting to the remote PC at $HOSTNAME..."
    ssh -i $SSH_KEY $SSH_USER@$HOSTNAME
}

if [ -z "$ACTION" ] || [ "$ACTION" == "-h" ] || [ "$ACTION" == "--help" ]; then
    show_help
fi

if [ "$SUB_COMMAND" == "-h" ] || [ "$SUB_COMMAND" == "--help" ]; then
    show_command_help $ACTION
fi

case $ACTION in
    "turn_on")
        wake_pc
        ;;
    "start_parsec")
        start_parsec
        ;;
    "both")
        wake_pc
        start_parsec
        ;;
    "shutdown")
        shutdown_pc
        ;;
    "restart")
        restart_pc
        ;;
    "connect")
        connect_ssh
        ;;
    "create_container")
        create_container $YAML_FILE
        ;;
    "start_container")
        start_container $SUB_COMMAND
        ;;
    "stop_container")
        stop_container $SUB_COMMAND
        ;;
    "delete_container")
        delete_container $SUB_COMMAND
        ;;
    "list_containers")
        list_containers
        ;;
    *)
        echo "Invalid command."
        show_help
        ;;
esac

echo "Done."
