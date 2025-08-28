#!/bin/bash

# Spotify MVP - Development Server Starter
# This script starts both backend and frontend servers simultaneously

set -e

echo "🎵 Starting Spotify MVP Development Servers"
echo "==========================================="
echo ""

# Colors for output
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

# Check if we're in the right directory
if [ ! -f "package.json" ] || [ ! -d "backend" ] || [ ! -d "frontend" ]; then
    echo "❌ Error: Please run this script from the spotify-mvp root directory"
    echo "   Make sure you have backend/ and frontend/ directories"
    exit 1
fi

# Check if dependencies are installed
if [ ! -d "backend/node_modules" ]; then
    print_warning "Backend dependencies not found. Installing..."
    cd backend && npm install && cd ..
fi

if [ ! -d "frontend/node_modules" ]; then
    print_warning "Frontend dependencies not found. Installing..."
    cd frontend && npm install && cd ..
fi

# Check if environment files exist
if [ ! -f "backend/.env" ]; then
    print_warning "Backend .env file not found. Please run local-setup.sh first."
    echo "Or create backend/.env manually with database configuration."
    exit 1
fi

if [ ! -f "frontend/.env" ]; then
    print_warning "Frontend .env file not found. Creating basic configuration..."
    cat > frontend/.env << EOL
REACT_APP_API_URL=http://localhost:3001/api
REACT_APP_STREAM_URL=http://localhost:3001/api/stream
REACT_APP_APP_NAME=Spotify MVP
REACT_APP_VERSION=1.0.0
GENERATE_SOURCEMAP=false
EOL
fi

print_info "Starting development servers..."
echo ""

# Function to handle cleanup
cleanup() {
    echo ""
    print_info "Shutting down servers..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
    wait $BACKEND_PID $FRONTEND_PID 2>/dev/null || true
    print_success "Servers stopped"
    exit 0
}

# Set up signal handling
trap cleanup SIGINT SIGTERM

# Start backend server in background
print_info "Starting backend server on port 3001..."
cd backend
npm run dev > ../backend.log 2>&1 &
BACKEND_PID=$!
cd ..

# Wait a moment for backend to start
sleep 3

# Check if backend started successfully
if kill -0 $BACKEND_PID 2>/dev/null; then
    print_success "✅ Backend server started (PID: $BACKEND_PID)"
else
    echo "❌ Backend server failed to start. Check backend.log for details:"
    tail -n 20 backend.log
    exit 1
fi

# Start frontend server in background
print_info "Starting frontend server on port 3000..."
cd frontend
npm run dev > ../frontend.log 2>&1 &
FRONTEND_PID=$!
cd ..

# Wait a moment for frontend to start
sleep 5

# Check if frontend started successfully
if kill -0 $FRONTEND_PID 2>/dev/null; then
    print_success "✅ Frontend server started (PID: $FRONTEND_PID)"
else
    echo "❌ Frontend server failed to start. Check frontend.log for details:"
    tail -n 20 frontend.log
    kill $BACKEND_PID 2>/dev/null || true
    exit 1
fi

echo ""
print_success "🎉 Both servers are running!"
echo ""
echo "📱 Application URLs:"
echo "   • Frontend: http://localhost:3000"
echo "   • Backend API: http://localhost:3001/api"
echo "   • Health Check: http://localhost:3001/health"
echo ""
echo "📊 Logs:"
echo "   • Backend: tail -f backend.log"
echo "   • Frontend: tail -f frontend.log"
echo ""
echo "⚡ To stop servers: Press Ctrl+C"
echo ""

# Keep script running and show real-time logs
print_info "Showing combined logs (Ctrl+C to stop):"
echo "========================================"

# Function to show logs with prefixes
show_logs() {
    tail -f backend.log frontend.log 2>/dev/null | while read line; do
        if [[ $line == =*backend.log* ]]; then
            echo -e "${BLUE}[BACKEND]${NC} ${line#*==> backend.log <==}"
        elif [[ $line == =*frontend.log* ]]; then
            echo -e "${GREEN}[FRONTEND]${NC} ${line#*==> frontend.log <==}"
        else
            echo "$line"
        fi
    done
}

# Start showing logs
show_logs &
LOGS_PID=$!

# Wait for interrupt
wait $BACKEND_PID $FRONTEND_PID 2>/dev/null || cleanup
