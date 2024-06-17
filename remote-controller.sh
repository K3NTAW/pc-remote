#!/bin/bash

# Configuration file
source remote-config.sh

ACTION=$1
SUB_COMMAND=$2

# Function to display overall script usage
show_help() {
    echo "Usage: $0 {turn_on|start_parsec|both|shutdown} [-h|--help]"
    echo "  turn_on       : Wake up the PC and check connectivity."
    echo "  start_parsec  : Start Parsec application on the remote machine."
    echo "  both          : Perform both turn_on and start_parsec."
    echo "  shutdown      : Shutdown the remote PC."
    echo ""
    echo "Options:"
    echo "  -h, --help    : Show this help message and exit."
    echo ""
    echo "For specific command help use:"
    echo "  $0 turn_on - h or --help"
    echo "  $0 start_parsec - h or --help"
    echo "  $0 both - h or --help"
    echo "  $0 shutdown - h or --help"
    exit 1
}

# Function to display detailed command help
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
            echo "Options:"
            echo "  -h, --help    : Show detailed help for the turn_on command."
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
            echo "Options:"
            echo "  -h, --help    : Show detailed help for the start_parsec command."
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
            echo "Options:"
            echo "  -h, --help    : Show detailed help for the both command."
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
            echo "Options:"
            echo "  -h, --help    : Show detailed help for the shutdown command."
            ;;
        *)
            echo "Invalid command."
            show_help
            ;;
    esac

    exit 1
}

# Function to show loading bar
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

# Function to wake up the PC
wake_pc() {
    echo "Sending Wake-on-LAN packet to $MAC_ADDRESS at $ROUTER_PUBLIC_IP:$PORT..."
    wakeonlan -i $ROUTER_PUBLIC_IP -p $PORT $MAC_ADDRESS
    
    echo "Waiting for the PC to wake up..."
    show_loading_bar 60
    
    if ping -c 1 -W 1 $PC_LOCAL_IP >/dev/null 2>&1; then
        echo "The PC is now awake and reachable at $PC_LOCAL_IP."
    else
        echo "Failed to reach the PC. It may not have woken up correctly."
    fi
}

# Function to start Parsec on the remote machine
start_parsec() {
    echo "Starting Parsec on $ROUTER_PUBLIC_IP..."
    ssh $SSH_USER@$ROUTER_PUBLIC_IP "C:\\Sysinternals\\psexec.exe -i 1 -d \"$APPLICATION\""
    SSH_STATUS=$?

    if [ $SSH_STATUS -eq 0 ]; then
        echo "Parsec has been started successfully."
    else
        echo "Failed to start Parsec. Please check the connection and the command."
    fi
}

# Function to shut down the remote PC
shutdown_pc() {
    echo "Shutting down the PC at $ROUTER_PUBLIC_IP..."
    ssh -i $SSH_KEY $SSH_USER@$ROUTER_PUBLIC_IP "shutdown /s /t 0"
    SSH_STATUS=$?

    if [ $SSH_STATUS -eq 0 ]; then
        echo "PC is shutting down."
    else
        echo "Failed to shutdown the PC. Please check the connection and the command."
    fi
}

# Main execution starts here

# Check if no action is provided or help option is used
if [ -z "$ACTION" ] || [ "$ACTION" == "-h" ] || [ "$ACTION" == "--help" ]; then
    show_help
fi

# Handle specific command help
if [ "$SUB_COMMAND" == "-h" ] || [ "$SUB_COMMAND" == "--help" ]; then
    case $ACTION in
        "turn_on")
            show_command_help turn_on
            ;;
        "start_parsec")
            show_command_help start_parsec
            ;;
        "both")
            show_command_help both
            ;;
        "shutdown")
            show_command_help shutdown
            ;;
        *)
            echo "Invalid command."
            show_help
            ;;
    esac
fi

# Execute the selected action
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
    *)
        echo "Invalid command."
        show_help
        ;;
esac

echo "Done."
