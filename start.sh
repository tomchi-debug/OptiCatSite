#!/usr/bin/env bash
# Start script for OptiCat Astro development server

set -e

echo "🚀 Starting OptiCat development server..."

# Check if we're in the right directory
if [[ ! -f "package.json" ]]; then
    echo "❌ package.json not found. Run this script from the project root."
    exit 1
fi

# Install dependencies if needed
if [[ ! -d "node_modules" || "$1" == "--force-install" ]]; then
    echo "📦 Installing dependencies..."
    npm install
else
    echo "✅ Dependencies already installed"
fi

# Create .env from example if missing
if [[ ! -f ".env" ]]; then
    if [[ -f ".env.example" ]]; then
        echo "📝 Creating .env from .env.example..."
        cp .env.example .env
        echo "⚠️  Please edit .env and add your Stripe keys!"
    else
        echo "⚠️  .env.example not found, skipping .env creation"
    fi
else
    echo "✅ .env already exists"
fi

# Start dev server
echo "🌐 Starting Astro dev server..."
if [[ "$1" == "--no-open" || "$2" == "--no-open" ]]; then
    npx astro dev
else
    npx astro dev --open
fi