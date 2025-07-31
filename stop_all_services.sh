#!/bin/bash

cd "$(dirname "$0")"

echo "Stopping all running Spring Boot services..."

if ls logs/*.pid 1> /dev/null 2>&1; then
  for pid_file in logs/*.pid; do
    PID=$(cat "$pid_file")
    SERVICE_NAME=$(basename "$pid_file" .pid)

    if kill "$PID" > /dev/null 2>&1; then
      echo "✅ Stopped $SERVICE_NAME (PID $PID)"
      rm -f "$pid_file"
    else
      echo "❌ Failed to stop $SERVICE_NAME (PID $PID may not exist)"
    fi
  done
else
  echo "ℹ️ No PID files found. Are the services running?"
fi

echo "🛑 All PID-tracked services have been handled."
