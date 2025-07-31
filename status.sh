#!/bin/bash

cd "$(dirname "$0")"

echo "Checking running services..."

any_running=0

for pid_file in logs/*.pid; do
  service_name=$(basename "$pid_file" .pid)
  pid=$(cat "$pid_file")

  if ps -p "$pid" > /dev/null 2>&1; then
    echo "✅ $service_name is running (PID $pid)"
    any_running=1
  else
    echo "❌ $service_name is NOT running (stale PID file)"
  fi
done

if [ "$any_running" -eq 0 ]; then
  echo "ℹ️ No services are currently running."
fi
