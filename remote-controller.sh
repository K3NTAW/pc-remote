#!/bin/bash

# Configuration file
source remote-config.sh

ACTION=$1

wake_pc() {
    echo "Sending Wake-on-LAN packet to $MAC_ADDRESS at $ROUTER_PUBLIC_IP:$PORT..."
    wakeonlan -i $ROUTER_PUBLIC_IP -p $PORT $MAC_ADDRESS
    echo "Waiting for the PC to wake up..."
    sleep 60
}

start_parsec() {
    echo "Starting Parsec on $ROUTER_PUBLIC_IP..."
    ssh $SSH_USER@$ROUTER_PUBLIC_IP "C:\\Sysinternals\\psexec.exe -i 1 -d \"$APPLICATION\""

    echo "Parsec has been started."
}

shutdown_pc() {
    echo "Shutting down the PC at $ROUTER_PUBLIC_IP..."
    ssh -i $SSH_KEY $SSH_USER@$ROUTER_PUBLIC_IP "shutdown /s /t 0"
    echo "PC is shutting down."
}

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
        echo "Usage: $0 {turn_on|start_parsec|both|shutdown}"
        exit 1
        ;;
esac

echo "Done."
