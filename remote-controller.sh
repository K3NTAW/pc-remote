#!/bin/bash

#configuration file
source remote-config.sh

ACTION=$1

wake_pc() {
    echo "Sending Wake-on-LAN packet to $MAC_ADDRESS..."
    wakeonlan $MAC_ADDRESS
    echo "Waiting for the PC to wake up..."
    sleep 60 
}

start_parsec() {
    echo "Starting Parsec on $TARGET_IP..."
    ssh -i $SSH_KEY $SSH_USER@$TARGET_IP "Start-Process -NoNewWindow -FilePath '$APPLICATION'"
    echo "Parsec has been started."
}

shutdown_pc() {
    echo "Shutting down the PC at $TARGET_IP..."
    ssh -i $SSH_KEY $SSH_USER@$TARGET_IP "shutdown /s /t 0"
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
