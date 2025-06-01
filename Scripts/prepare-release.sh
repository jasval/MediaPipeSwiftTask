#!/bin/bash
set -e

# Script to prepare MediaPipe frameworks for release
# This can be run locally or in CI to package frameworks

echo "🚀 Preparing MediaPipe frameworks for release..."

# Ensure we have the frameworks
if [ ! -d "Pods/MediaPipeTasksGenAI/frameworks" ]; then
    echo "❌ MediaPipe frameworks not found. Run 'pod install' first."
    exit 1
fi

# Create staging directory
mkdir -p staging
rm -rf staging/*

echo "📦 Copying frameworks..."
cp -r Pods/MediaPipeTasksGenAI/frameworks/MediaPipeTasksGenAI.xcframework staging/
cp -r Pods/MediaPipeTasksGenAIC/frameworks/MediaPipeTasksGenAIC.xcframework staging/

echo "🗜️  Creating archives..."
cd staging

# Create zip archives
zip -r -q MediaPipeTasksGenAI.xcframework.zip MediaPipeTasksGenAI.xcframework
zip -r -q MediaPipeTasksGenAIC.xcframework.zip MediaPipeTasksGenAIC.xcframework

echo "🔐 Generating checksums..."
shasum -a 256 MediaPipeTasksGenAI.xcframework.zip > MediaPipeTasksGenAI.checksum
shasum -a 256 MediaPipeTasksGenAIC.xcframework.zip > MediaPipeTasksGenAIC.checksum

echo "✅ Release preparation complete!"
echo ""
echo "📋 Checksums:"
echo "MediaPipeTasksGenAI: $(cat MediaPipeTasksGenAI.checksum | cut -d' ' -f1)"
echo "MediaPipeTasksGenAIC: $(cat MediaPipeTasksGenAIC.checksum | cut -d' ' -f1)"
echo ""
echo "📁 Files ready for upload:"
ls -la *.zip *.checksum

cd ..