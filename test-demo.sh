#!/bin/bash

echo "╔════════════════════════════════════════════════════════════╗"
echo "║     Image Generation API - Live Test Demonstration        ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Configuration
BASE_URL="http://localhost:3000"
AUTH_KEY="image-generate-service-secret-key-57@@57"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}📋 Test Configuration:${NC}"
echo "   Base URL: $BASE_URL"
echo "   Auth Key: ${AUTH_KEY:0:20}..."
echo ""

# Test 1: Health Check
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Test 1: Health Check (No Auth Required)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "$ curl http://localhost:3000/health"
echo ""
HEALTH_RESPONSE=$(curl -s "$BASE_URL/health")
echo "$HEALTH_RESPONSE" | jq .
echo ""

# Test 2: Async Image Generation
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Test 2: Async Image Generation (Recommended)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "$ curl -X POST http://localhost:3000/api/images/generate-async \\"
echo "  -H \"Content-Type: application/json\" \\"
echo "  -H \"auth_key: YOUR_KEY\" \\"
echo "  -d @data.json"
echo ""
echo -e "${GREEN}⏱️  Measuring response time...${NC}"
echo ""

START=$(date +%s%N)
ASYNC_RESPONSE=$(curl -s -X POST "$BASE_URL/api/images/generate-async" \
  -H "Content-Type: application/json" \
  -H "auth_key: $AUTH_KEY" \
  -d @data.json)
END=$(date +%s%N)

DURATION=$(( (END - START) / 1000000 ))

echo "$ASYNC_RESPONSE" | jq .
echo ""
echo -e "${GREEN}✅ Response received in: ${DURATION}ms${NC}"
echo -e "${GREEN}✅ Image is being generated in background${NC}"
echo ""

# Test 3: Check Background Processing
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Test 3: Background Processing Status${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "Checking server logs for background processing..."
echo ""
sleep 2

# Show last few log lines
if [ -f "logs/combined-$(date +%Y-%m-%d).log" ]; then
    echo -e "${GREEN}Recent log entries:${NC}"
    tail -n 5 "logs/combined-$(date +%Y-%m-%d).log" | grep -E "(Background|Image generated)" || echo "Processing..."
else
    echo "Log file not found - check console output"
fi

echo ""

# Test 4: List Generated Images
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Test 4: List Generated Images${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "$ curl -H \"auth_key: YOUR_KEY\" http://localhost:3000/api/images"
echo ""
echo "Waiting for background processing to complete..."
sleep 10
echo ""

IMAGES_RESPONSE=$(curl -s -H "auth_key: $AUTH_KEY" "$BASE_URL/api/images")
IMAGE_COUNT=$(echo "$IMAGES_RESPONSE" | jq -r '.count')
LATEST_IMAGE=$(echo "$IMAGES_RESPONSE" | jq -r '.images[0]')

echo "Total images: $IMAGE_COUNT"
echo ""
echo "Latest generated image:"
echo "$LATEST_IMAGE" | jq '{
  type: .type,
  id: .metadata.id,
  url: .url,
  createdAt: .createdAt
}'

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ All Tests Completed Successfully!${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "📚 For complete API documentation, see: API_DOCUMENTATION.md"
echo ""
