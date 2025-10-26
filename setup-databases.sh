#!/bin/bash

# Pomi Database Setup Script
# This script starts MongoDB, PostgreSQL, and Redis using Docker Compose

echo "🚀 Starting Pomi Databases..."
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker daemon is not running"
    echo "Please start Docker and try again"
    exit 1
fi

echo "✅ Docker is running"
echo ""

# Navigate to the pomi app directory
cd "$(dirname "$0")"

echo "📦 Starting databases with Docker Compose..."
docker-compose down -v 2>/dev/null  # Clean up any existing containers
docker-compose up -d

echo ""
echo "⏳ Waiting for databases to be ready (30 seconds)..."
sleep 30

echo ""
echo "📊 Database Status:"
docker-compose ps

echo ""
echo "✅ Databases started successfully!"
echo ""
echo "Connection Details:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "MongoDB:"
echo "  URI: mongodb://pomi_user:pomi_password@localhost:27017/pomi"
echo "  Port: 27017"
echo ""
echo "PostgreSQL:"
echo "  URI: postgresql://pomi_user:pomi_password@localhost:5432/pomi_db"
echo "  Port: 5432"
echo ""
echo "Redis:"
echo "  URI: redis://localhost:6379"
echo "  Port: 6379"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📚 Documentation: See DATABASE_SETUP.md for detailed instructions"
echo ""
