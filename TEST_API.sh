#!/bin/bash

# POMI API Testing Script
# This script tests all major API endpoints

API_BASE_URL="${API_URL:-http://localhost:3000/api/v1}"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}POMI Application API Testing${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Function to make requests and show results
test_endpoint() {
    local method=$1
    local endpoint=$2
    local token=$3
    local data=$4
    local description=$5

    echo -e "${YELLOW}Testing: ${description}${NC}"
    echo -e "  ${method} ${endpoint}"

    if [ -z "$data" ]; then
        response=$(curl -s -X "$method" "$API_BASE_URL$endpoint" \
            -H "Authorization: Bearer $token" \
            -H "Content-Type: application/json" \
            -w "\n%{http_code}")
    else
        response=$(curl -s -X "$method" "$API_BASE_URL$endpoint" \
            -H "Authorization: Bearer $token" \
            -H "Content-Type: application/json" \
            -d "$data" \
            -w "\n%{http_code}")
    fi

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [[ "$http_code" =~ ^[2][0-9][0-9]$ ]]; then
        echo -e "  ${GREEN}✓ Status: $http_code${NC}"
        echo -e "  ${BLUE}Response:${NC} $(echo "$body" | head -c 100)..."
    else
        echo -e "  ${RED}✗ Status: $http_code${NC}"
        echo -e "  ${RED}Response: $body${NC}"
    fi
    echo ""
}

# Step 1: Register/Login Test Users
echo -e "${BLUE}PHASE 1: Authentication${NC}\n"

echo -e "${YELLOW}Registering Test User 1${NC}"
user1_response=$(curl -s -X POST "$API_BASE_URL/auth/register" \
    -H "Content-Type: application/json" \
    -d '{
        "email": "testuser1@pomi.test",
        "password": "TestPassword123!",
        "username": "testuser1",
        "age": 25,
        "area": "Ottawa",
        "workOrSchool": "Test Company"
    }')

echo "Response: $(echo "$user1_response" | head -c 150)...\n"

echo -e "${YELLOW}Logging in Test User 1${NC}"
user1_login=$(curl -s -X POST "$API_BASE_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d '{
        "email": "testuser1@pomi.test",
        "password": "TestPassword123!"
    }')

USER1_TOKEN=$(echo "$user1_login" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
USER1_ID=$(echo "$user1_login" | grep -o '"_id":"[^"]*' | cut -d'"' -f4 | head -1)

echo -e "  ${GREEN}User 1 Token:${NC} ${USER1_TOKEN:0:20}..."
echo -e "  ${GREEN}User 1 ID:${NC} $USER1_ID\n"

echo -e "${YELLOW}Registering Test User 2${NC}"
user2_response=$(curl -s -X POST "$API_BASE_URL/auth/register" \
    -H "Content-Type: application/json" \
    -d '{
        "email": "testuser2@pomi.test",
        "password": "TestPassword123!",
        "username": "testuser2",
        "age": 30,
        "area": "Ottawa",
        "workOrSchool": "Test Company 2"
    }')

echo "Response: $(echo "$user2_response" | head -c 150)...\n"

echo -e "${YELLOW}Logging in Test User 2${NC}"
user2_login=$(curl -s -X POST "$API_BASE_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d '{
        "email": "testuser2@pomi.test",
        "password": "TestPassword123!"
    }')

USER2_TOKEN=$(echo "$user2_login" | grep -o '"token":"[^"]*' | cut -d'"' -f4)
USER2_ID=$(echo "$user2_login" | grep -o '"_id":"[^"]*' | cut -d'"' -f4 | head -1)

echo -e "  ${GREEN}User 2 Token:${NC} ${USER2_TOKEN:0:20}..."
echo -e "  ${GREEN}User 2 ID:${NC} $USER2_ID\n"

# Step 2: Test Message API
echo -e "${BLUE}PHASE 2: Message API Testing${NC}\n"

echo -e "${YELLOW}Test 1: Send message from User 1 to User 2${NC}"
message_response=$(curl -s -X POST "$API_BASE_URL/messages" \
    -H "Authorization: Bearer $USER1_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
        \"recipientId\": \"$USER2_ID\",
        \"content\": \"Hello User 2, this is a test message!\"
    }" \
    -w "\n%{http_code}")

http_code=$(echo "$message_response" | tail -n1)
echo -e "  Status: $http_code"
echo -e "  Response: $(echo "$message_response" | sed '$d' | head -c 150)...\n"

echo -e "${YELLOW}Test 2: Get conversations for User 1${NC}"
conv_response=$(curl -s -X GET "$API_BASE_URL/messages" \
    -H "Authorization: Bearer $USER1_TOKEN" \
    -w "\n%{http_code}")

http_code=$(echo "$conv_response" | tail -n1)
echo -e "  Status: $http_code"
echo -e "  Response: $(echo "$conv_response" | sed '$d' | head -c 150)...\n"

echo -e "${YELLOW}Test 3: Get conversation history${NC}"
history_response=$(curl -s -X GET "$API_BASE_URL/messages/$USER2_ID" \
    -H "Authorization: Bearer $USER1_TOKEN" \
    -w "\n%{http_code}")

http_code=$(echo "$history_response" | tail -n1)
echo -e "  Status: $http_code"
echo -e "  Response: $(echo "$history_response" | sed '$d' | head -c 150)...\n"

echo -e "${YELLOW}Test 4: Get unread message count${NC}"
unread_response=$(curl -s -X GET "$API_BASE_URL/messages/unread/count" \
    -H "Authorization: Bearer $USER2_TOKEN" \
    -w "\n%{http_code}")

http_code=$(echo "$unread_response" | tail -n1)
echo -e "  Status: $http_code"
echo -e "  Response: $(echo "$unread_response" | sed '$d')\n"

# Step 3: Test Marketplace Features
echo -e "${BLUE}PHASE 3: Marketplace Integration Testing${NC}\n"

echo -e "${YELLOW}Test 1: Create marketplace listing${NC}"
listing_response=$(curl -s -X POST "$API_BASE_URL/marketplace/listings" \
    -H "Authorization: Bearer $USER1_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Test Laptop",
        "description": "A great laptop for testing",
        "category": "electronics",
        "price": 500,
        "location": "Downtown Ottawa",
        "condition": "like-new"
    }' \
    -w "\n%{http_code}")

http_code=$(echo "$listing_response" | tail -n1)
echo -e "  Status: $http_code"
echo -e "  Response: $(echo "$listing_response" | sed '$d' | head -c 150)...\n"

# Step 4: Test Event Features
echo -e "${BLUE}PHASE 4: Event Features Testing${NC}\n"

echo -e "${YELLOW}Test 1: Create event with social media link${NC}"
event_response=$(curl -s -X POST "$API_BASE_URL/events" \
    -H "Authorization: Bearer $USER1_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Test Community Gathering",
        "description": "Testing event creation",
        "location": "Ottawa Community Center",
        "date": "2025-12-25",
        "startTime": "18:00",
        "endTime": "21:00",
        "category": "social",
        "socialMediaLink": "https://instagram.com/pomi_ottawa"
    }' \
    -w "\n%{http_code}")

http_code=$(echo "$event_response" | tail -n1)
echo -e "  Status: $http_code"
echo -e "  Response: $(echo "$event_response" | sed '$d' | head -c 150)...\n"

# Summary
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Testing Complete!${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "${GREEN}Summary:${NC}"
echo "  User 1 ID: $USER1_ID"
echo "  User 2 ID: $USER2_ID"
echo ""
echo "  ${YELLOW}Next Steps:${NC}"
echo "  1. Check MongoDB for saved messages"
echo "  2. Verify email notifications were sent"
echo "  3. Test Socket.io connection manually"
echo "  4. Test frontend components in browser"
echo ""
