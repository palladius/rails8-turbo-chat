#!/bin/bash
set -e

if grep -q "COPY rubyllm_chat_app/Gemfile rubyllm_chat_app/Gemfile.lock ./" rubyllm_chat_app/Dockerfile; then
  echo "Test passed: COPY Gemfile command updated correctly."
else
  echo "Test failed: COPY Gemfile command not updated."
  exit 1
fi

if grep -q "COPY rubyllm_chat_app/ ." rubyllm_chat_app/Dockerfile; then
  echo "Test passed: COPY . command updated correctly."
else
  echo "Test failed: COPY . command not updated."
  exit 1
fi
