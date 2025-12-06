#!/bin/bash

echo "🚀 Testing Async Image Generation"
echo "=================================="
echo ""

BASE_URL="http://localhost:3000"
AUTH_KEY="my-secret-auth-key-12345"

echo "📋 Sending async image generation request..."
echo ""

START=$(date +%s)

# Send async request
RESPONSE=$(curl -s -X POST "$BASE_URL/api/images/generate-async" \
  -H "Content-Type: application/json" \
  -H "auth_key: $AUTH_KEY" \
  -d @data.json)

END=$(date +%s)
DURATION=$((END - START))

echo "Response received in ${DURATION}s:"
echo "$RESPONSE" | jq .

echo ""
echo "✅ Notice: Response came back immediately!"
echo "   The image is being generated in the background."
echo ""
echo "Check the logs to see background processing:"
echo "   tail -f logs/combined-$(date +%Y-%m-%d).log"
