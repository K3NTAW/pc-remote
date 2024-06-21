#!/usr/bin/env bats

SCRIPT_PATH="/Users/taawake2/projects/personal/scripts/project/pc-remote-controller.sh"

@test "Help output" {
  run $SCRIPT_PATH -h
  [ "$status" -eq 1 ]
  [[ "$output" =~ "PC remote controller help" ]]
}

@test "Turn on help output" {
  run $SCRIPT_PATH turn_on -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Command: turn_on" ]]
  [[ "$output" =~ "Description: Wakes up the PC using Wake-on-LAN and checks connectivity." ]]
}

@test "Start Parsec help output" {
  run $SCRIPT_PATH start_parsec -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Command: start_parsec" ]]
  [[ "$output" =~ "Description: Starts the Parsec application on the remote machine." ]]
}

@test "Both help output" {
  run $SCRIPT_PATH both -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Command: both" ]]
  [[ "$output" =~ "Description: Performs both turn_on (Wake-on-LAN) and start_parsec (Parsec application)." ]]
}

@test "Shutdown help output" {
  run $SCRIPT_PATH shutdown -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Command: shutdown" ]]
  [[ "$output" =~ "Description: Shuts down the remote PC." ]]
}

@test "Restart help output" {
  run $SCRIPT_PATH restart -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Command: restart" ]]
  [[ "$output" =~ "Description: Restarts the remote PC." ]]
}

@test "Connect help output" {
  run $SCRIPT_PATH connect -h
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Command: connect" ]]
  [[ "$output" =~ "Description: Connect to the remote PC via SSH." ]]
}

@test "Turn on PC" {
  run $SCRIPT_PATH turn_on
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Sending Wake-on-LAN packet to" ]]
  [[ "$output" =~ "Waiting for the PC to wake up..." ]]
}

@test "Start Parsec" {
  run $SCRIPT_PATH start_parsec
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Starting Parsec on" ]]
}

@test "Shutdown PC" {
  run $SCRIPT_PATH shutdown
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Shutting down the PC at" ]]
}

@test "Restart PC" {
  run $SCRIPT_PATH restart
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Restarting the PC at" ]]
}

@test "Connect to PC via SSH" {
  run $SCRIPT_PATH connect
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Connecting to the remote PC at" ]]
}
