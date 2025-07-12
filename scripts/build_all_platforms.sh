#!/bin/bash

# Chakame - Build All Platforms Script
# This script builds the app for all supported platforms

echo "🚀 Building Chakame for all platforms..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check Flutter installation
if ! command_exists flutter; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

print_status "Flutter version:"
flutter --version

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean
flutter pub get

# Generate model files
print_status "Generating model files..."
flutter packages pub run build_runner build

# Create build directory
mkdir -p build/releases

# Build for Web
print_status "Building for Web..."
if flutter build web --release; then
    print_success "Web build completed"
    # Create archive
    cd build/web
    tar -czf ../releases/chakame-web.tar.gz .
    cd ../..
else
    print_error "Web build failed"
fi

# Build for Android
print_status "Building for Android..."
if flutter build apk --release; then
    print_success "Android APK build completed"
    cp build/app/outputs/flutter-apk/app-release.apk build/releases/chakame-android.apk
else
    print_error "Android build failed"
fi

# Build Android App Bundle
print_status "Building Android App Bundle..."
if flutter build appbundle --release; then
    print_success "Android App Bundle build completed"
    cp build/app/outputs/bundle/release/app-release.aab build/releases/chakame-android.aab
else
    print_error "Android App Bundle build failed"
fi

# Build for iOS (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_status "Building for iOS..."
    if flutter build ios --release --no-codesign; then
        print_success "iOS build completed"
    else
        print_error "iOS build failed"
    fi
else
    print_warning "iOS build skipped (requires macOS)"
fi

# Build for Windows
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    print_status "Building for Windows..."
    if flutter build windows --release; then
        print_success "Windows build completed"
        # Create archive
        cd build/windows/runner/Release
        zip -r ../../../releases/chakame-windows.zip .
        cd ../../../..
    else
        print_error "Windows build failed"
    fi
else
    print_warning "Windows build skipped (requires Windows)"
fi

# Build for macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_status "Building for macOS..."
    if flutter build macos --release; then
        print_success "macOS build completed"
        # Create archive
        cd build/macos/Build/Products/Release
        tar -czf ../../../../releases/chakame-macos.tar.gz Chakame.app
        cd ../../../../..
    else
        print_error "macOS build failed"
    fi
else
    print_warning "macOS build skipped (requires macOS)"
fi

# Build for Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    print_status "Building for Linux..."
    if flutter build linux --release; then
        print_success "Linux build completed"
        # Create archive
        cd build/linux/x64/release/bundle
        tar -czf ../../../../releases/chakame-linux.tar.gz .
        cd ../../../../..
    else
        print_error "Linux build failed"
    fi
else
    print_warning "Linux build skipped (requires Linux)"
fi

# Summary
print_status "Build summary:"
echo "📦 Build artifacts are in: build/releases/"
ls -la build/releases/ 2>/dev/null || echo "No release files found"

print_success "Build process completed!"
echo ""
echo "🎉 Chakame has been built for all available platforms!"
echo "📋 Check the build/releases/ directory for the output files."
echo ""
echo "📱 Mobile: chakame-android.apk, chakame-android.aab"
echo "🌐 Web: chakame-web.tar.gz"
echo "🖥️  Desktop: chakame-windows.zip, chakame-macos.tar.gz, chakame-linux.tar.gz"