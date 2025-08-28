#!/bin/bash

# Spotify MVP - Local Setup Script (No Docker)
# This script automates the local deployment process

set -e  # Exit on any error

echo "🎵 Spotify MVP - Local Setup Script"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "🔍 Checking prerequisites..."
echo ""

# Check Node.js
if command_exists node; then
    NODE_VERSION=$(node --version)
    print_success "Node.js found: $NODE_VERSION"
else
    print_error "Node.js is not installed. Please install Node.js 18+ from https://nodejs.org/"
    exit 1
fi

# Check npm
if command_exists npm; then
    NPM_VERSION=$(npm --version)
    print_success "npm found: v$NPM_VERSION"
else
    print_error "npm is not installed. Please install npm."
    exit 1
fi

# Check PostgreSQL
if command_exists psql; then
    POSTGRES_VERSION=$(psql --version)
    print_success "PostgreSQL found: $POSTGRES_VERSION"
else
    print_error "PostgreSQL is not installed. Please install PostgreSQL 14+ from https://www.postgresql.org/"
    exit 1
fi

# Check Git
if command_exists git; then
    GIT_VERSION=$(git --version)
    print_success "Git found: $GIT_VERSION"
else
    print_error "Git is not installed. Please install Git from https://git-scm.com/"
    exit 1
fi

echo ""
print_success "✅ All prerequisites found!"
echo ""

# Get current directory
PROJECT_DIR=$(pwd)
print_status "Working in directory: $PROJECT_DIR"
echo ""

# Database setup
echo "🗄️  Database Setup"
echo "=================="

# Prompt for database credentials
echo ""
print_status "Database configuration needed:"
read -p "PostgreSQL username (default: postgres): " DB_USER
DB_USER=${DB_USER:-postgres}

echo -n "PostgreSQL password for $DB_USER: "
read -s DB_PASSWORD
echo ""

read -p "Database name (default: spotify_mvp): " DB_NAME
DB_NAME=${DB_NAME:-spotify_mvp}

read -p "Database host (default: localhost): " DB_HOST
DB_HOST=${DB_HOST:-localhost}

read -p "Database port (default: 5432): " DB_PORT
DB_PORT=${DB_PORT:-5432}

DATABASE_URL="postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:$DB_PORT/$DB_NAME"

echo ""
print_status "Creating database if it doesn't exist..."

# Create database
export PGPASSWORD=$DB_PASSWORD
psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d postgres -c "CREATE DATABASE $DB_NAME;" 2>/dev/null || print_warning "Database might already exist"

# Import schema
if [ -f "database/schema.sql" ]; then
    print_status "Importing database schema..."
    psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f database/schema.sql
    print_success "Database schema imported successfully"
else
    print_error "database/schema.sql not found!"
    exit 1
fi

echo ""

# Backend setup
echo "⚙️  Backend Setup"
echo "================="

print_status "Setting up backend..."

if [ ! -d "backend" ]; then
    print_error "backend directory not found!"
    exit 1
fi

cd backend

print_status "Installing backend dependencies..."
npm install

print_status "Creating backend .env file..."
cat > .env << EOL
# Database Configuration
DATABASE_URL=$DATABASE_URL

# JWT Configuration
JWT_SECRET=$(openssl rand -base64 32)
JWT_EXPIRES_IN=24h
JWT_REFRESH_EXPIRES_IN=7d

# Server Configuration
NODE_ENV=development
PORT=3001
CORS_ORIGIN=http://localhost:3000

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# File Upload Configuration
UPLOAD_PATH=./uploads
MAX_FILE_SIZE=50MB

# Security
TRUST_PROXY=false
EOL

print_success "Backend .env file created"

# Create uploads directory
print_status "Creating uploads directory..."
mkdir -p uploads
print_success "Uploads directory created"

# Run database migrations/seeding if scripts exist
if npm run | grep -q "db:migrate"; then
    print_status "Running database migrations..."
    npm run db:migrate || print_warning "Migration script failed or doesn't exist"
fi

if npm run | grep -q "db:seed"; then
    print_status "Seeding database..."
    npm run db:seed || print_warning "Seed script failed or doesn't exist"
fi

cd ..
print_success "✅ Backend setup complete"
echo ""

# Frontend setup
echo "⚛️  Frontend Setup"
echo "=================="

print_status "Setting up frontend..."

if [ ! -d "frontend" ]; then
    print_error "frontend directory not found!"
    exit 1
fi

cd frontend

print_status "Installing frontend dependencies..."

# Check if pnpm is available, otherwise use npm
if command_exists pnpm; then
    print_status "Using pnpm for frontend dependencies..."
    pnpm install
else
    print_status "Using npm for frontend dependencies..."
    npm install
fi

print_status "Creating frontend .env file..."
cat > .env << EOL
# API Configuration
REACT_APP_API_URL=http://localhost:3001/api
REACT_APP_STREAM_URL=http://localhost:3001/api/stream

# App Configuration
REACT_APP_APP_NAME=Spotify MVP
REACT_APP_VERSION=1.0.0

# Development
GENERATE_SOURCEMAP=false
EOL

print_success "Frontend .env file created"

cd ..
print_success "✅ Frontend setup complete"
echo ""

# Sample music setup (optional)
if [ -d "sample-music" ] && [ "$(ls -A sample-music)" ]; then
    echo "🎵 Sample Music Setup"
    echo "===================="
    
    read -p "Do you want to copy sample music files? (y/N): " SETUP_MUSIC
    if [[ $SETUP_MUSIC =~ ^[Yy]$ ]]; then
        print_status "Copying sample music files..."
        cp sample-music/* backend/uploads/ 2>/dev/null || print_warning "Failed to copy some music files"
        chmod 644 backend/uploads/* 2>/dev/null || print_warning "Failed to set file permissions"
        
        if [ -f "setup-sample-music.sh" ]; then
            print_status "Running sample music database setup..."
            chmod +x setup-sample-music.sh
            ./setup-sample-music.sh || print_warning "Sample music setup script failed"
        fi
        
        print_success "✅ Sample music setup complete"
    else
        print_status "Skipping sample music setup"
    fi
    echo ""
fi

# Final instructions
echo "🚀 Setup Complete!"
echo "=================="
echo ""
print_success "Your Spotify MVP has been set up successfully!"
echo ""
echo "📋 Next Steps:"
echo ""
echo "1. Start the backend server:"
echo -e "   ${BLUE}cd backend && npm run dev${NC}"
echo ""
echo "2. In a new terminal, start the frontend:"
echo -e "   ${BLUE}cd frontend && npm run dev${NC}"
echo ""
echo "3. Open your browser and visit:"
echo -e "   ${GREEN}http://localhost:3000${NC}"
echo ""
echo "📊 Test Accounts (if seeded):"
echo "• Admin: admin@spotify-mvp.com / password123"
echo "• Demo: demo@spotify-mvp.com / password123"
echo ""
echo "🔗 Useful URLs:"
echo "• Frontend: http://localhost:3000"
echo "• Backend API: http://localhost:3001/api"
echo "• Health Check: http://localhost:3001/health"
echo ""
echo "📚 For more detailed instructions, see:"
echo "• LOCAL_DEPLOYMENT_GUIDE.md"
echo "• QUICK-START.md"
echo ""
print_success "🎉 Happy streaming!"
