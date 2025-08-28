# 🐳 Spotify MVP - Docker with Local Files

Deploy your Spotify MVP using Docker with your local source files mounted as volumes for development.

## 🚀 Quick Start

### **Option 1: Automated Setup (Recommended)**
```bash
# Make the setup script executable  
chmod +x docker-setup.sh

# Run the interactive setup
./docker-setup.sh

# Choose option 1 for development with local files
```

### **Option 2: Manual Setup**
```bash
# Start development environment with local file mounting
docker-compose -f docker-compose.dev.yml up --build

# Your app will be available at:
# Frontend: http://localhost:3000
# Backend: http://localhost:3001/api
```

---

## 🎯 What You Get

✅ **Live Development** - Edit files locally, see changes immediately in containers  
✅ **Hot Reloading** - Both backend and frontend auto-restart on changes  
✅ **Persistent Database** - PostgreSQL data survives container restarts  
✅ **Audio Streaming** - Upload and stream music files  
✅ **Complete MVP** - Authentication, playlists, search, user management  

---

## 📁 File Structure

```
spotify-mvp/              # Your project files (mounted into containers)
├── backend/              # Node.js API (mounted to /app in container)
├── frontend/             # React app (mounted to /app in container)  
├── database/             # PostgreSQL schema
├── sample-music/         # Demo audio files
└── docker-compose.yml    # Production Docker config

docker-compose.dev.yml    # Development config (with volume mounts)
docker-setup.sh          # Interactive setup script
DOCKER_DEPLOYMENT_GUIDE.md # Complete documentation
```

---

## ⚙️ Development vs Production

### **Development Mode** (`docker-compose.dev.yml`)
- **Local files mounted** as volumes into containers
- **Hot reloading** enabled for both backend and frontend  
- **Node modules** persisted in named volumes
- **Perfect for** coding, testing, debugging

### **Production Mode** (`spotify-mvp/docker-compose.yml`)  
- **Code built into** containers during build
- **Optimized** for deployment and distribution
- **Self-contained** containers with all dependencies
- **Perfect for** production deployment

---

## 🔧 Common Commands

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up

# Start in background  
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose -f docker-compose.dev.yml logs -f

# Stop everything
docker-compose -f docker-compose.dev.yml down

# Rebuild containers
docker-compose -f docker-compose.dev.yml up --build
```

---

## 🎵 Adding Your Music

```bash
# Add your MP3 files to the backend uploads directory
mkdir -p spotify-mvp/backend/uploads
cp your-music/* spotify-mvp/backend/uploads/

# Files are immediately available in the running containers
```

---

## 🔐 Test Accounts

- **Admin**: `admin@spotify-mvp.com` / `password123`
- **Demo User**: `demo@spotify-mvp.com` / `password123`

---

## 📊 Service URLs

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001/api  
- **Health Check**: http://localhost:3001/health
- **Database**: localhost:5432 (postgres/spotify_user:spotify_password)

---

## 🆘 Troubleshooting

### **Containers won't start**
```bash
# Check if ports are available
lsof -i :3000
lsof -i :3001

# Clear Docker cache
docker system prune -a
```

### **Database issues**
```bash
# Check database container
docker logs spotify-mvp-db

# Connect to database
docker exec -it spotify-mvp-db psql -U spotify_user -d spotify_mvp
```

### **File permission issues (Linux/Mac)**
```bash
# Fix permissions
chmod -R 755 spotify-mvp/
chown -R $USER:$USER spotify-mvp/
```

---

## 📚 Documentation

- **[DOCKER_DEPLOYMENT_GUIDE.md](DOCKER_DEPLOYMENT_GUIDE.md)** - Complete setup and troubleshooting guide
- **[LOCAL_DEPLOYMENT_GUIDE.md](LOCAL_DEPLOYMENT_GUIDE.md)** - Non-Docker local setup
- **[SPOTIFY_MVP_DEPLOYMENT_GUIDE.md](SPOTIFY_MVP_DEPLOYMENT_GUIDE.md)** - Production deployment options

---

## 🎉 Ready to Stream!

Your Spotify MVP will run in Docker containers with your local source files mounted, giving you the best of both worlds - containerized consistency with local development flexibility.

**Happy coding!** 🎶