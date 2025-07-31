#!/bin/bash

cd "$(dirname "$0")"

# Create logs folder if missing
mkdir -p logs

declare -A services=(
  ["api-gateway-service"]=8081
  ["vechile-service"]=8082
  ["common-lib"]=8083
  ["service-track"]=8084
  ["blockchain-gateway-service"]=8085
)

PIDS=()
FAILED=()

echo "Starting all services..."
for service in "${!services[@]}"; do
  PORT=${services[$service]}
  LOG_FILE="logs/$service.log"
  PID_FILE="logs/$service.pid"

  echo "→ Starting $service on port $PORT..."

  (
    cd "$service" || exit 1
    mvn spring-boot:run > "../$LOG_FILE" 2>&1
  ) &

  PID=$!
  echo $PID > "$PID_FILE"
  PIDS+=($PID)

  # Wait briefly and check if still running
  sleep 5
  if ! ps -p $PID > /dev/null; then
    echo "❌ $service failed to start (see logs/$service.log)"
    FAILED+=("$service")
  else
    echo "✅ $service started"
  fi
done

echo ""
if [ ${#FAILED[@]} -eq 0 ]; then
  echo "🟢 All services started successfully."
else
  echo "🔴 Some services failed to start:"
  for service in "${FAILED[@]}"; do
    echo "   • $service (check logs/$service.log)"
  done
fi

echo ""
echo "📂 Logs are stored in: backend/logs/"
echo ""
echo "💡 To stop services: run \`kill \$(cat logs/*.pid)\`"
