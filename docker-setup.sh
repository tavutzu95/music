#!/bin/bash

# Spotify MVP - Docker Setup Script
# Helps you quickly deploy using Docker with local source files

set -e  # Exit on any error

echo "🐳 Spotify MVP - Docker Setup"
echo "============================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info() {
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

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker from https://docker.com/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose."
    exit 1
fi

print_success "✅ Docker and Docker Compose found!"
echo ""

# Check current directory
if [ ! -d "spotify-mvp" ]; then
    print_error "spotify-mvp directory not found! Please run this script from the directory containing spotify-mvp/"
    exit 1
fi

print_info "Found spotify-mvp project directory"
echo ""

# Display deployment options
echo "🎯 Choose your deployment method:"
echo ""
echo "1. 🔧 Development (with local source files)"
echo "   - Your local code is mounted into containers"
echo "   - Changes reflect immediately"
echo "   - Perfect for development and testing"
echo ""
echo "2. 🏭 Production (built containers)"  
echo "   - Code is built into containers"
echo "   - Self-contained and portable"
echo "   - Better for production deployment"
echo ""
echo "3. 📋 View running containers"
echo ""
echo "4. 🛑 Stop all containers"
echo ""

read -p "Select option (1-4): " CHOICE

case $CHOICE in
    1)
        echo ""
        print_info "🔧 Starting Development Environment..."
        echo ""
        
        # Check if development compose file exists
        if [ ! -f "docker-compose.dev.yml" ]; then
            print_error "docker-compose.dev.yml not found!"
            exit 1
        fi
        
        print_info "Using docker-compose.dev.yml with local source mounts"
        print_info "Your local files will be mounted into containers"
        echo ""
        
        # Start development environment
        print_info "Starting containers..."
        docker-compose -f docker-compose.dev.yml up --build
        ;;
        
    2)
        echo ""
        print_info "🏭 Starting Production Environment..."
        echo ""
        
        cd spotify-mvp
        
        print_info "Using docker-compose.yml with built containers"
        print_info "Code will be built into containers"
        echo ""
        
        # Start production environment
        print_info "Building and starting containers..."
        docker-compose up --build
        ;;
        
    3)
        echo ""
        print_info "📋 Current Docker Status"
        echo "========================"
        echo ""
        
        # Show running containers
        echo "🐳 Running Containers:"
        docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
        echo ""
        
        echo "📊 Docker Compose Services:"
        if [ -f "spotify-mvp/docker-compose.yml" ]; then
            cd spotify-mvp && docker-compose ps
        else
            print_warning "No docker-compose.yml found in spotify-mvp/"
        fi
        echo ""
        
        echo "🌐 Service URLs:"
        echo "• Frontend: http://localhost:3000"
        echo "• Backend API: http://localhost:3001/api"
        echo "• Health Check: http://localhost:3001/health"
        echo "• Database: localhost:5432"
        ;;
        
    4)
        echo ""
        print_info "🛑 Stopping All Containers..."
        echo ""
        
        # Stop development containers
        if [ -f "docker-compose.dev.yml" ]; then
            print_info "Stopping development containers..."
            docker-compose -f docker-compose.dev.yml down || true
        fi
        
        # Stop production containers  
        if [ -f "spotify-mvp/docker-compose.yml" ]; then
            print_info "Stopping production containers..."
            cd spotify-mvp && docker-compose down || true
            cd ..
        fi
        
        print_success "✅ All containers stopped"
        
        # Ask if user wants to clean up volumes
        echo ""
        read -p "Do you want to remove volumes (database data will be lost)? (y/N): " CLEANUP
        if [[ $CLEANUP =~ ^[Yy]$ ]]; then
            print_info "Removing volumes..."
            docker volume prune -f || true
            print_warning "All data volumes removed"
        fi
        ;;
        
    *)
        print_error "Invalid option selected"
        exit 1
        ;;
esac

if [ $CHOICE -eq 1 ] || [ $CHOICE -eq 2 ]; then
    echo ""
    print_success "🎉 Deployment complete!"
    echo ""
    echo "🌐 Your Spotify MVP is available at:"
    echo "   • Frontend: http://localhost:3000"
    echo "   • Backend API: http://localhost:3001/api"
    echo "   • Health Check: http://localhost:3001/health"
    echo ""
    echo "🔐 Test Accounts:"
    echo "   • Admin: admin@spotify-mvp.com / password123"
    echo "   • Demo: demo@spotify-mvp.com / password123"
    echo ""
    echo "📊 Monitor with:"
    echo "   • docker-compose logs -f"
    echo "   • docker ps"
    echo ""
    echo "🛑 To stop:"
    echo "   • Press Ctrl+C in this terminal"
    echo "   • Or run: ./docker-setup.sh (option 4)"
fi

echo ""
print_info "For more details, see DOCKER_DEPLOYMENT_GUIDE.md"
