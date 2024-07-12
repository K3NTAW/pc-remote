#!/usr/bin/env bats

# Test wake_pc function
@test "Test wake_pc function" {
    run ./remote_pc_controller.sh turn_on
    [ "$status" -eq 0 ]
    [ "$(echo "$output" | grep -c "The PC is now awake and reachable")" -eq 1 ]
}

# Test start_parsec function
@test "Test start_parsec function" {
    run ./remote_pc_controller.sh start_parsec
    [ "$status" -eq 0 ]
    [ "$(echo "$output" | grep -c "Parsec has been started successfully")" -eq 1 ]
}

# Test create_container, start_container, stop_container, and delete_container functions
@test "Test Docker container operations" {
    # Create a test YAML file for Docker container creation
    echo "---
    container_name: test_container
    image: nginx:latest
    ports:
      - '80:80'
    volumes:
      - '/data:/var/www/html'
    environment:
      - 'ENV_VAR=test'" > test_container.yaml

    # Test create_container
    run ./remote_pc_controller.sh create_container test_container.yaml
    [ "$status" -eq 0 ]
    [ "$(echo "$output" | grep -c "Container 'test_container' created successfully")" -eq 1 ]

    # Test start_container
    run ./remote_pc_controller.sh start_container test_container
    [ "$status" -eq 0 ]
    [ "$(echo "$output" | grep -c "Container 'test_container' started successfully")" -eq 1 ]

    # Test stop_container
    run ./remote_pc_controller.sh stop_container test_container
    [ "$status" -eq 0 ]
    [ "$(echo "$output" | grep -c "Container 'test_container' stopped successfully")" -eq 1 ]

    # Test delete_container
    run ./remote_pc_controller.sh delete_container test_container
    [ "$status" -eq 0 ]
    [ "$(echo "$output" | grep -c "Container 'test_container' deleted successfully")" -eq 1 ]

    # Clean up: Delete the test YAML file
    rm test_container.yaml
}

# Test connect_ssh function
@test "Test connect_ssh function" {
    run ./remote_pc_controller.sh connect
    [ "$status" -eq 0 ]
    # Add assertions here based on expected output or behavior
    # Example: Check if SSH connection is established successfully
    [ "$(echo "$output" | grep -c "Connected to the remote PC")" -eq 1 ]
}


