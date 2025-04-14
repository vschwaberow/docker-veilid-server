#!/bin/bash

if command -v docker-compose >/dev/null 2>&1; then
    echo "Using docker-compose (legacy)..."
    docker-compose up --build "$@"
elif docker compose version >/dev/null 2>&1; then
    echo "Using docker compose (plugin)..."
    docker compose up --build "$@"
else    
    echo "Error: Neither 'docker-compose' nor 'docker compose' command found in PATH." >&2
    echo "Please ensure Docker and Docker Compose (v1 or v2 plugin) are installed correctly." >&2
    exit 1
fi

exit_status=$?
if [ $exit_status -ne 0 ]; then
    echo "Docker Compose command finished with status $exit_status" >&2
fi

exit $exit_status