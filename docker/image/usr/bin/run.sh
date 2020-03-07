#!/usr/bin/env bash

service smbd restart
status=$?

if [ $status -ne 0 ]; then
  echo "Failed to start my_first_process: $status"
  exit $status
fi

while sleep 60; do
  ps aux |grep smbd |grep -q -v grep
  PROCESS_1_STATUS=$?

  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "Process exited"
    exit 1
  fi
done
