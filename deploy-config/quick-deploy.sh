#!/bin/bash

# Quick Deploy Script - Tạo link công khai nhanh chóng

echo "🚀 DuanHpt9t9 + BotpressV12 - Quick Public Deployment"
echo "=================================================="

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install ngrok
install_ngrok() {
    echo "📦 Installing ngrok..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
        echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
        sudo apt update && sudo apt install ngrok
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install ngrok/ngrok/ngrok
    else
        echo "❌ Please install ngrok manually: https://ngrok.com/download"
        exit 1
    fi
}

# Check dependencies
echo "🔍 Checking dependencies..."

if ! command_exists docker; then
    echo "❌ Docker not found. Please install Docker first."
    exit 1
fi

if ! command_exists ngrok; then
    echo "⚠️ Ngrok not found."
    read -p "Do you want to install ngrok? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_ngrok
    else
        echo "❌ Ngrok is required for public access."
        exit 1
    fi
fi

# Get ngrok auth token
echo "🔑 Ngrok setup..."
if [ ! -f ~/.ngrok2/ngrok.yml ]; then
    echo "Please get your auth token from: https://dashboard.ngrok.com/get-started/your-authtoken"
    read -p "Enter your ngrok auth token: " NGROK_TOKEN
    ngrok authtoken $NGROK_TOKEN
fi

# Start Docker containers
echo "🐳 Starting Docker containers..."
cd /workspace
docker compose -f docker-compose.yml up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Check if services are running
if ! docker compose ps | grep -q "Up"; then
    echo "❌ Services failed to start. Check logs:"
    docker compose logs
    exit 1
fi

# Start ngrok tunnels
echo "🌐 Creating public tunnels..."

# Start ngrok for DuanHpt9t9 (port 12000)
ngrok http 12000 --log=stdout > /tmp/ngrok-duanhpt9t9.log &
NGROK_PID1=$!

# Start ngrok for Botpress (port 12001) 
ngrok http 12001 --log=stdout > /tmp/ngrok-botpress.log &
NGROK_PID2=$!

# Wait for ngrok to start
sleep 10

# Get public URLs
echo "🔗 Getting public URLs..."

# Get DuanHpt9t9 URL
DUANHPT_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url' 2>/dev/null || echo "")
if [ -z "$DUANHPT_URL" ]; then
    DUANHPT_URL="Check ngrok dashboard at http://localhost:4040"
fi

# Get Botpress URL  
BOTPRESS_URL=$(curl -s http://localhost:4041/api/tunnels | jq -r '.tunnels[0].public_url' 2>/dev/null || echo "")
if [ -z "$BOTPRESS_URL" ]; then
    BOTPRESS_URL="Check ngrok dashboard"
fi

# Display results
echo ""
echo "✅ Deployment completed!"
echo "========================"
echo ""
echo "🌐 PUBLIC LINKS:"
echo "   DuanHpt9t9:  $DUANHPT_URL"
echo "   Botpress:    $BOTPRESS_URL"
echo ""
echo "📊 Monitoring:"
echo "   Ngrok Dashboard: http://localhost:4040"
echo "   Docker Status:   docker compose ps"
echo ""
echo "🛑 To stop:"
echo "   kill $NGROK_PID1 $NGROK_PID2"
echo "   docker compose down"
echo ""

# Keep script running
echo "Press Ctrl+C to stop all services..."
trap "echo 'Stopping services...'; kill $NGROK_PID1 $NGROK_PID2 2>/dev/null; docker compose down; exit" INT

# Wait for user interrupt
while true; do
    sleep 1
done