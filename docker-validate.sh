#!/bin/bash

# Spotify MVP - Docker Validation Script
# Checks if all required files are present for Docker deployment

echo "🔍 Spotify MVP - Docker Setup Validation"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_check() {
    if [ "$2" = "true" ]; then
        echo -e "${GREEN}[✓]${NC} $1"
    else
        echo -e "${RED}[✗]${NC} $1"
    fi
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check Docker prerequisites
echo "🐳 Docker Prerequisites"
echo "======================"
DOCKER_OK="false"
DOCKER_COMPOSE_OK="false"

if command -v docker &> /dev/null; then
    DOCKER_OK="true"
fi

if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE_OK="true"
fi

print_check "Docker installed" $DOCKER_OK
print_check "Docker Compose installed" $DOCKER_COMPOSE_OK
echo ""

# Check required files
echo "📁 Required Files"
echo "================"

# Core project files
PROJECT_DIR_OK="false"
BACKEND_DIR_OK="false"
FRONTEND_DIR_OK="false"
DATABASE_SCHEMA_OK="false"
DOCKER_DEV_CONFIG_OK="false"
DOCKER_PROD_CONFIG_OK="false"

if [ -d "spotify-mvp" ]; then
    PROJECT_DIR_OK="true"
fi

if [ -d "spotify-mvp/backend" ]; then
    BACKEND_DIR_OK="true"
fi

if [ -d "spotify-mvp/frontend" ]; then
    FRONTEND_DIR_OK="true"
fi

if [ -f "spotify-mvp/database/schema.sql" ]; then
    DATABASE_SCHEMA_OK="true"
fi

if [ -f "docker-compose.dev.yml" ]; then
    DOCKER_DEV_CONFIG_OK="true"
fi

if [ -f "spotify-mvp/docker-compose.yml" ]; then
    DOCKER_PROD_CONFIG_OK="true"
fi

print_check "Project directory (spotify-mvp/)" $PROJECT_DIR_OK
print_check "Backend source code (spotify-mvp/backend/)" $BACKEND_DIR_OK
print_check "Frontend source code (spotify-mvp/frontend/)" $FRONTEND_DIR_OK
print_check "Database schema (spotify-mvp/database/schema.sql)" $DATABASE_SCHEMA_OK
print_check "Development Docker config (docker-compose.dev.yml)" $DOCKER_DEV_CONFIG_OK
print_check "Production Docker config (spotify-mvp/docker-compose.yml)" $DOCKER_PROD_CONFIG_OK

echo ""

# Check package.json files
echo "📦 Package Configuration"
echo "======================="

BACKEND_PACKAGE_OK="false"
FRONTEND_PACKAGE_OK="false"

if [ -f "spotify-mvp/backend/package.json" ]; then
    BACKEND_PACKAGE_OK="true"
fi

if [ -f "spotify-mvp/frontend/package.json" ]; then
    FRONTEND_PACKAGE_OK="true"
fi

print_check "Backend package.json" $BACKEND_PACKAGE_OK
print_check "Frontend package.json" $FRONTEND_PACKAGE_OK
echo ""

# Check environment templates
echo "⚙️ Environment Templates"
echo "======================="

BACKEND_ENV_TEMPLATE_OK="false"
FRONTEND_ENV_TEMPLATE_OK="false"
DOCKER_ENV_OK="false"

if [ -f "spotify-mvp/backend/.env.example" ]; then
    BACKEND_ENV_TEMPLATE_OK="true"
fi

if [ -f "spotify-mvp/frontend/.env.example" ]; then
    FRONTEND_ENV_TEMPLATE_OK="true"
fi

if [ -f ".env.docker" ]; then
    DOCKER_ENV_OK="true"
fi

print_check "Backend .env.example" $BACKEND_ENV_TEMPLATE_OK
print_check "Frontend .env.example" $FRONTEND_ENV_TEMPLATE_OK
print_check "Docker .env template" $DOCKER_ENV_OK
echo ""

# Check optional files
echo "🎵 Optional Components"
echo "==================="

SAMPLE_MUSIC_OK="false"
SETUP_SCRIPT_OK="false"
DOCKER_GUIDE_OK="false"

if [ -d "sample-music" ] && [ "$(ls -A sample-music 2>/dev/null)" ]; then
    SAMPLE_MUSIC_OK="true"
fi

if [ -f "docker-setup.sh" ]; then
    SETUP_SCRIPT_OK="true"
fi

if [ -f "DOCKER_DEPLOYMENT_GUIDE.md" ]; then
    DOCKER_GUIDE_OK="true"
fi

print_check "Sample music files (sample-music/)" $SAMPLE_MUSIC_OK
print_check "Docker setup script (docker-setup.sh)" $SETUP_SCRIPT_OK
print_check "Docker deployment guide" $DOCKER_GUIDE_OK
echo ""

# Summary
echo "📊 Validation Summary"
echo "==================="

TOTAL_REQUIRED=8
PASSED_REQUIRED=0

[ "$DOCKER_OK" = "true" ] && ((PASSED_REQUIRED++))
[ "$DOCKER_COMPOSE_OK" = "true" ] && ((PASSED_REQUIRED++))
[ "$PROJECT_DIR_OK" = "true" ] && ((PASSED_REQUIRED++))
[ "$BACKEND_DIR_OK" = "true" ] && ((PASSED_REQUIRED++))
[ "$FRONTEND_DIR_OK" = "true" ] && ((PASSED_REQUIRED++))
[ "$DATABASE_SCHEMA_OK" = "true" ] && ((PASSED_REQUIRED++))
[ "$DOCKER_DEV_CONFIG_OK" = "true" ] && ((PASSED_REQUIRED++))
[ "$DOCKER_PROD_CONFIG_OK" = "true" ] && ((PASSED_REQUIRED++))

echo "Required checks passed: $PASSED_REQUIRED/$TOTAL_REQUIRED"

if [ $PASSED_REQUIRED -eq $TOTAL_REQUIRED ]; then
    echo -e "${GREEN}🎉 All required components are present!${NC}"
    echo ""
    echo "✅ You're ready to deploy with Docker!"
    echo ""
    echo "🚀 Next Steps:"
    echo "1. Run: ./docker-setup.sh"
    echo "2. Choose option 1 for development"
    echo "3. Access your app at http://localhost:3000"
    echo ""
else
    echo -e "${RED}❌ Missing required components!${NC}"
    echo ""
    echo "🔧 To fix issues:"
    
    if [ "$DOCKER_OK" = "false" ]; then
        echo "• Install Docker: https://docker.com/"
    fi
    
    if [ "$DOCKER_COMPOSE_OK" = "false" ]; then
        echo "• Install Docker Compose: https://docs.docker.com/compose/"
    fi
    
    if [ "$PROJECT_DIR_OK" = "false" ]; then
        echo "• Ensure you have the spotify-mvp/ directory"
    fi
    
    if [ "$BACKEND_DIR_OK" = "false" ] || [ "$FRONTEND_DIR_OK" = "false" ]; then
        echo "• Make sure backend/ and frontend/ directories exist in spotify-mvp/"
    fi
    
    if [ "$DATABASE_SCHEMA_OK" = "false" ]; then
        echo "• Ensure database/schema.sql exists in spotify-mvp/"
    fi
    
    if [ "$DOCKER_DEV_CONFIG_OK" = "false" ] || [ "$DOCKER_PROD_CONFIG_OK" = "false" ]; then
        echo "• Make sure Docker Compose files are present"
    fi
    
    echo ""
fi

# Show current directory structure
echo "📁 Current Directory Structure:"
echo "=============================="
if command -v tree &> /dev/null; then
    tree -L 3 -I node_modules
else
    find . -type d -name node_modules -prune -o -type f -print | head -20
    echo "... (install 'tree' command for better directory visualization)"
fi
