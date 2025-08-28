# 🎵 Spotify MVP - Local Deployment (No Docker)

A complete guide and scripts to deploy your Spotify MVP locally without Docker.

## 🚀 Quick Start (Automated)

If you want the automated setup experience:

```bash
# Make the setup script executable
chmod +x local-setup.sh

# Run the automated setup
./local-setup.sh

# Start both servers
chmod +x start-dev.sh
./start-dev.sh
```

That's it! Your Spotify MVP will be running at `http://localhost:3000`

## 📋 Manual Setup

If you prefer manual setup or the automated script doesn't work:

1. **Read the detailed guide**: [LOCAL_DEPLOYMENT_GUIDE.md](LOCAL_DEPLOYMENT_GUIDE.md)
2. Follow the step-by-step instructions
3. Set up PostgreSQL database
4. Configure backend and frontend
5. Start the servers manually

## 📁 Files Included

- **`LOCAL_DEPLOYMENT_GUIDE.md`** - Complete step-by-step manual setup guide
- **`local-setup.sh`** - Automated setup script
- **`start-dev.sh`** - Development server launcher
- **`spotify-mvp/`** - Complete application code

## 🔧 Prerequisites

- **Node.js 18+** 
- **PostgreSQL 14+**
- **Git**
- **npm or pnpm**

## 🎯 What You Get

- **Complete Music Streaming Platform**
- **User Authentication** (Free & Premium tiers)  
- **Music Player** with streaming
- **Search & Browse** functionality
- **Playlist Management**
- **Responsive Web Interface**

## 🌐 Access Points

Once running:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:3001/api  
- **Health Check**: http://localhost:3001/health

## 🔐 Test Accounts

- **Admin**: `admin@spotify-mvp.com` / `password123`
- **Demo User**: `demo@spotify-mvp.com` / `password123`

## 🆘 Need Help?

1. **Check the logs**: Look at `backend.log` and `frontend.log`
2. **Read troubleshooting**: See `LOCAL_DEPLOYMENT_GUIDE.md`
3. **Verify prerequisites**: Make sure all required software is installed
4. **Database issues**: Check PostgreSQL is running and accessible

## 📚 Documentation

- [LOCAL_DEPLOYMENT_GUIDE.md](LOCAL_DEPLOYMENT_GUIDE.md) - Complete setup guide
- [SPOTIFY_MVP_DEPLOYMENT_GUIDE.md](SPOTIFY_MVP_DEPLOYMENT_GUIDE.md) - Production deployment
- `spotify-mvp/QUICK-START.md` - Application quick start
- `spotify-mvp/README.md` - Project documentation

---

**Ready to stream music? Follow the Quick Start section above!** 🎉