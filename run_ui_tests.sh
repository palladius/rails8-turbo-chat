#!/bin/bash

# This script runs all UI tests from the docs/prompts/ui directory
# and logs the output to timestamped files.

set -euo pipefail

PROMPT_DIR="docs/prompts/ui"
BASE_LOG_DIR="rubyllm_chat_app/test/ui-tests"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
PID=$$

echo "Starting UI tests..."

for prompt_file in "$PROMPT_DIR"/*.md; do
    if [ -f "$prompt_file" ]; then
        test_name=$(basename "$prompt_file" .md)
        LOG_DIR="$BASE_LOG_DIR/$test_name"
        mkdir -p "$LOG_DIR"

        log_file="$LOG_DIR/${TIMESTAMP}-${PID}.log"

        echo "Running test: $test_name"
        echo "Log file: $log_file"

        cat "$prompt_file" | gemini --yolo --prompt 2>&1 | tee "$log_file"

        echo "Finished test: $test_name"
        echo "---------------------------------"
    fi
done

echo "All UI tests completed."
