#!/bin/bash

# Heroku Deployment Script for DuanHpt9t9 + BotpressV12

echo "🚀 Setting up Heroku deployment..."

# Check if Heroku CLI is installed
if ! command -v heroku &> /dev/null; then
    echo "❌ Heroku CLI not found. Please install it first:"
    echo "https://devcenter.heroku.com/articles/heroku-cli"
    exit 1
fi

# Login to Heroku
echo "📝 Please login to Heroku..."
heroku login

# Create Heroku apps
echo "🏗️ Creating Heroku applications..."
heroku create duanhpt9t9-app --region us
heroku create botpress-duanhpt9t9 --region us

# Add PostgreSQL addon for Botpress
echo "🗄️ Adding PostgreSQL database..."
heroku addons:create heroku-postgresql:mini -a botpress-duanhpt9t9

# Set environment variables for DuanHpt9t9
echo "⚙️ Setting environment variables for DuanHpt9t9..."
heroku config:set NODE_ENV=production -a duanhpt9t9-app
heroku config:set DATABASE_URL="file:./prisma/dev.db" -a duanhpt9t9-app
heroku config:set BOTPRESS_URL="https://botpress-duanhpt9t9.herokuapp.com" -a duanhpt9t9-app

# Set environment variables for Botpress
echo "⚙️ Setting environment variables for Botpress..."
heroku config:set NODE_ENV=production -a botpress-duanhpt9t9
heroku config:set BP_HOST=0.0.0.0 -a botpress-duanhpt9t9
heroku config:set PORT=\$PORT -a botpress-duanhpt9t9

# Set container stack
heroku stack:set container -a duanhpt9t9-app
heroku stack:set container -a botpress-duanhpt9t9

echo "✅ Heroku setup completed!"
echo ""
echo "📋 Next steps:"
echo "1. Deploy DuanHpt9t9:"
echo "   cd DuanHpt9t9"
echo "   git init"
echo "   heroku git:remote -a duanhpt9t9-app"
echo "   git add ."
echo "   git commit -m 'Initial deployment'"
echo "   git push heroku main"
echo ""
echo "2. Deploy Botpress:"
echo "   cd ../BotpressV12"
echo "   git init"
echo "   heroku git:remote -a botpress-duanhpt9t9"
echo "   git add ."
echo "   git commit -m 'Initial deployment'"
echo "   git push heroku main"
echo ""
echo "🌐 Your apps will be available at:"
echo "   DuanHpt9t9: https://duanhpt9t9-app.herokuapp.com"
echo "   Botpress: https://botpress-duanhpt9t9.herokuapp.com"