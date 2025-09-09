#!/bin/bash

# Render Deployment Script for DuanHpt9t9 + BotpressV12

echo "🎨 Render Deployment Setup"
echo "=========================="

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Please run this script from the workspace root directory"
    exit 1
fi

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "📝 Initializing git repository..."
    git init
    git config user.name "khpt1976-cloud"
    git config user.email "khpt1976@example.com"
fi

# Add all files to git
echo "📦 Adding files to git..."
git add .
git status

# Commit changes
echo "💾 Committing changes..."
git commit -m "Initial commit for Render deployment

- Added DuanHpt9t9 Next.js application with AdminBot integration
- Added BotpressV12 chatbot with Docker configuration
- Added Render deployment configuration (render.yaml)
- Added PostgreSQL database setup
- Added comprehensive documentation"

# Check if remote exists
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "🔗 Adding GitHub remote..."
    git remote add origin https://github.com/khpt1976-cloud/DuanHpt9t9.git
fi

# Push to GitHub
echo "🚀 Pushing to GitHub..."
echo "Using GitHub token for authentication..."

# Update remote URL with token (token should be set as environment variable)
git remote set-url origin https://${GITHUB_TOKEN}@github.com/khpt1976-cloud/DuanHpt9t9.git

# Push to main branch
git branch -M main
git push -u origin main

echo ""
echo "✅ Code pushed to GitHub successfully!"
echo ""
echo "🎨 Next steps for Render deployment:"
echo "=================================="
echo ""
echo "1. 🌐 Go to https://render.com and sign up/login"
echo ""
echo "2. 🔗 Connect your GitHub account:"
echo "   - Click 'New +' → 'Web Service'"
echo "   - Connect GitHub repository: khpt1976-cloud/DuanHpt9t9"
echo ""
echo "3. 📋 Create DuanHpt9t9 service:"
echo "   - Name: duanhpt9t9"
echo "   - Environment: Docker"
echo "   - Dockerfile Path: ./DuanHpt9t9/Dockerfile"
echo "   - Docker Context: ./DuanHpt9t9"
echo "   - Instance Type: Free"
echo ""
echo "4. ⚙️ Environment Variables for DuanHpt9t9:"
echo "   NODE_ENV=production"
echo "   DATABASE_URL=file:./prisma/dev.db"
echo "   BOTPRESS_URL=https://botpress-duanhpt9t9.onrender.com"
echo ""
echo "5. 📋 Create Botpress service:"
echo "   - Name: botpress-duanhpt9t9"
echo "   - Environment: Docker"
echo "   - Dockerfile Path: ./BotpressV12/Dockerfile"
echo "   - Docker Context: ./BotpressV12"
echo "   - Instance Type: Free"
echo ""
echo "6. ⚙️ Environment Variables for Botpress:"
echo "   NODE_ENV=production"
echo "   BP_HOST=0.0.0.0"
echo "   PORT=3000"
echo "   DATABASE_URL=\${{DATABASE_URL}} (from PostgreSQL service)"
echo ""
echo "7. 🗄️ Create PostgreSQL Database:"
echo "   - Click 'New +' → 'PostgreSQL'"
echo "   - Name: botpress-db"
echo "   - Database Name: botpress"
echo "   - User: botpress"
echo ""
echo "8. 🔗 Your public links will be:"
echo "   📱 DuanHpt9t9: https://duanhpt9t9.onrender.com"
echo "   🤖 Botpress: https://botpress-duanhpt9t9.onrender.com"
echo "   👨‍💼 AdminBot: https://duanhpt9t9.onrender.com/admin/adminbot"
echo ""
echo "⏱️ Deployment time: ~10-15 minutes"
echo "💰 Cost: FREE (with some limitations)"
echo ""
echo "🔧 Alternative: Use render.yaml for automatic setup"
echo "   - Just connect the repo and Render will read render.yaml automatically"
echo ""

# Create a summary file
cat > RENDER-DEPLOYMENT-SUMMARY.md << 'EOF'
# 🎨 Render Deployment Summary

## ✅ Completed Steps:
1. ✅ Git repository initialized and configured
2. ✅ All files committed to git
3. ✅ Code pushed to GitHub: https://github.com/khpt1976-cloud/DuanHpt9t9
4. ✅ Render configuration files created (render.yaml)

## 🚀 Next Steps (Manual):

### 1. Create Render Account
- Go to https://render.com
- Sign up with GitHub account

### 2. Connect Repository
- Click "New +" → "Web Service"
- Connect GitHub repo: `khpt1976-cloud/DuanHpt9t9`

### 3. Deploy Services

#### DuanHpt9t9 Service:
```
Name: duanhpt9t9
Environment: Docker
Dockerfile: ./DuanHpt9t9/Dockerfile
Context: ./DuanHpt9t9
Instance: Free

Environment Variables:
- NODE_ENV=production
- DATABASE_URL=file:./prisma/dev.db
- BOTPRESS_URL=https://botpress-duanhpt9t9.onrender.com
```

#### Botpress Service:
```
Name: botpress-duanhpt9t9
Environment: Docker
Dockerfile: ./BotpressV12/Dockerfile
Context: ./BotpressV12
Instance: Free

Environment Variables:
- NODE_ENV=production
- BP_HOST=0.0.0.0
- PORT=3000
- DATABASE_URL=${{DATABASE_URL}}
```

#### PostgreSQL Database:
```
Name: botpress-db
Database: botpress
User: botpress
```

## 🔗 Expected Public URLs:
- **DuanHpt9t9:** https://duanhpt9t9.onrender.com
- **Botpress:** https://botpress-duanhpt9t9.onrender.com
- **AdminBot:** https://duanhpt9t9.onrender.com/admin/adminbot

## ⚡ Alternative: Automatic Deployment
Render will automatically read `render.yaml` and create all services.

## 📞 Support
If you encounter issues:
1. Check Render dashboard logs
2. Verify environment variables
3. Check Dockerfile paths
4. Ensure database connection string is correct
EOF

echo "📄 Created RENDER-DEPLOYMENT-SUMMARY.md for reference"
echo ""
echo "🎉 Ready for Render deployment!"