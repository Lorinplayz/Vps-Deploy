#!/bin/bash

echo " 

██╗     ░█████╗░██████╗░██╗███╗░░██╗██████╗░██╗░░░░░░█████╗░██╗░░░██╗███████╗
██║░░░░░██╔══██╗██╔══██╗██║████╗░██║██╔══██╗██║░░░░░██╔══██╗╚██╗░██╔╝╚════██║
██║░░░░░██║░░██║██████╔╝██║██╔██╗██║██████╔╝██║░░░░░███████║░╚████╔╝░░░███╔═╝
██║░░░░░██║░░██║██╔══██╗██║██║╚████║██╔═══╝░██║░░░░░██╔══██║░░╚██╔╝░░██╔══╝░░
███████╗╚█████╔╝██║░░██║██║██║░╚███║██║░░░░░███████╗██║░░██║░░░██║░░░███████╗
╚══════╝░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░╚══╝╚═╝░░░░░╚══════╝╚═╝░░╚═╝░░░╚═╝░░░╚══════╝  v1.0"

echo "    ✨ LORINPLAYZ VPS Creator - Make your own Free VPS Hosting ✨"
echo "    ⚠️  DON'T ALLOW MINING - Respect the Terms of Service ⚠️"
echo "    🔗 Credit: Made by LORINPLAYZ"

echo ""
read -p "📋 Do you agree to not allow mining on created VPS? (y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Installation aborted. You must agree to the terms."
    exit 1
fi

cd ~

echo "📦 Installing required packages (python3-pip, docker.io)..."
sudo apt update
sudo apt install -y python3-pip docker.io > /dev/null 2>&1
echo "✅ Packages installed successfully"

echo "🐳 Writing Dockerfile..."
cat <<EOF > Dockerfile
FROM ubuntu:22.04

RUN apt update && apt install -y tmate nano htop curl wget
RUN apt clean

CMD ["tmate"]
EOF

echo "✅ Dockerfile created"

echo "🏗️ Building Docker Image (ubuntu-22.04-with-tmate)..."
sudo docker build -t ubuntu-22.04-with-tmate . > /dev/null 2>&1
echo "✅ Docker image built successfully"

echo "📥 Downloading main.py from repository..."
wget -q -O main.py https://raw.githubusercontent.com/katy-the-kat/discord-vps-creator/refs/heads/main/v3ds
if [ $? -eq 0 ]; then
    echo "✅ main.py downloaded successfully"
else
    echo "❌ Failed to download main.py"
    exit 1
fi

echo "🐍 Installing Python packages (discord.py, docker)..."
pip3 install discord.py docker > /dev/null 2>&1
echo "✅ Python packages installed"

echo ""
echo "🤖 Discord Bot Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📌 Create a bot at: https://discord.com/developers/applications"
echo "📌 You DON'T need any privileged intents"
echo "📌 Copy the bot token from the Bot section"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "🔑 Enter your Discord Bot Token: " DISCORD_TOKEN

if [ -z "$DISCORD_TOKEN" ]; then
    echo "❌ Token cannot be empty!"
    exit 1
fi

echo "✏️ Updating main.py with your token..."
sed -i "s/TOKEN = ''/TOKEN = '$DISCORD_TOKEN'/" main.py
echo "✅ Configuration complete"

echo ""
echo "🚀 Starting Discord Bot..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "💡 To run the bot in the future: python3 main.py"
echo "💡 To keep bot running 24/7: nohup python3 main.py &"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

python3 main.py
