#!/bin/bash

# Chakame - Dependency Check Script
# This script checks if all required dependencies are available

echo "🔍 Checking Chakame dependencies..."

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
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check Flutter installation
print_status "Checking Flutter installation..."
if command_exists flutter; then
    print_success "Flutter is installed"
    flutter --version
else
    print_error "Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check Flutter doctor
print_status "Running Flutter doctor..."
flutter doctor

# Check if platforms are enabled
print_status "Checking enabled platforms..."

# Check Web
if flutter config | grep -q "enable-web: true"; then
    print_success "Web platform is enabled"
else
    print_warning "Web platform is not enabled"
    echo "Run: flutter config --enable-web"
fi

# Check Windows (if on Windows)
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    if flutter config | grep -q "enable-windows-desktop: true"; then
        print_success "Windows desktop platform is enabled"
    else
        print_warning "Windows desktop platform is not enabled"
        echo "Run: flutter config --enable-windows-desktop"
    fi
fi

# Check macOS (if on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if flutter config | grep -q "enable-macos-desktop: true"; then
        print_success "macOS desktop platform is enabled"
    else
        print_warning "macOS desktop platform is not enabled"
        echo "Run: flutter config --enable-macos-desktop"
    fi
fi

# Check Linux (if on Linux)
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if flutter config | grep -q "enable-linux-desktop: true"; then
        print_success "Linux desktop platform is enabled"
    else
        print_warning "Linux desktop platform is not enabled"
        echo "Run: flutter config --enable-linux-desktop"
    fi
fi

# Check project dependencies
print_status "Checking project dependencies..."

if [ -f "pubspec.yaml" ]; then
    print_success "pubspec.yaml found"
    
    # Check if flutter packages get was run
    if [ -f "pubspec.lock" ]; then
        print_success "pubspec.lock found (dependencies fetched)"
    else
        print_warning "pubspec.lock not found"
        echo "Run: flutter pub get"
    fi
    
    # Check if build_runner was run
    if [ -f "lib/models/poem_model.g.dart" ]; then
        print_success "Generated files found"
    else
        print_warning "Generated files not found"
        echo "Run: flutter packages pub run build_runner build"
    fi
    
else
    print_error "pubspec.yaml not found"
    echo "Make sure you're in the project root directory"
    exit 1
fi

# Check available devices
print_status "Checking available devices..."
flutter devices

# Platform-specific checks
print_status "Platform-specific checks..."

# Check for Chrome (Web)
if command_exists google-chrome || command_exists chromium-browser || command_exists chrome; then
    print_success "Chrome browser found (needed for web development)"
else
    print_warning "Chrome browser not found"
    echo "Install Chrome or Chromium for web development"
fi

# Check for Android tools
if command_exists adb; then
    print_success "Android Debug Bridge (adb) found"
else
    print_warning "Android Debug Bridge (adb) not found"
    echo "Install Android SDK for Android development"
fi

# Check for iOS tools (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if command_exists xcodebuild; then
        print_success "Xcode command line tools found"
    else
        print_warning "Xcode command line tools not found"
        echo "Install Xcode for iOS development"
    fi
fi

# Check for Git
if command_exists git; then
    print_success "Git is installed"
else
    print_warning "Git is not installed"
    echo "Install Git for version control"
fi

# Check for Linux desktop dependencies
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    print_status "Checking Linux desktop dependencies..."
    
    # Check for required packages
    if dpkg -l | grep -q clang; then
        print_success "clang found"
    else
        print_warning "clang not found"
        echo "Install: sudo apt-get install clang"
    fi
    
    if dpkg -l | grep -q cmake; then
        print_success "cmake found"
    else
        print_warning "cmake not found"
        echo "Install: sudo apt-get install cmake"
    fi
    
    if dpkg -l | grep -q ninja-build; then
        print_success "ninja-build found"
    else
        print_warning "ninja-build not found"
        echo "Install: sudo apt-get install ninja-build"
    fi
    
    if dpkg -l | grep -q pkg-config; then
        print_success "pkg-config found"
    else
        print_warning "pkg-config not found"
        echo "Install: sudo apt-get install pkg-config"
    fi
    
    if dpkg -l | grep -q libgtk-3-dev; then
        print_success "libgtk-3-dev found"
    else
        print_warning "libgtk-3-dev not found"
        echo "Install: sudo apt-get install libgtk-3-dev"
    fi
fi

# Summary
echo ""
print_status "Dependency check complete!"
echo ""
echo "📋 Summary:"
echo "✅ If all checks passed, you're ready to build Chakame!"
echo "⚠️  If there are warnings, some platforms may not work properly"
echo "❌ If there are errors, please fix them before proceeding"
echo ""
echo "🚀 Quick start commands:"
echo "  flutter pub get                    # Install dependencies"
echo "  flutter packages pub run build_runner build  # Generate model files"
echo "  flutter run                        # Run on default device"
echo "  flutter run -d chrome              # Run on web"
echo "  flutter run -d windows             # Run on Windows"
echo "  flutter run -d macos               # Run on macOS"
echo "  flutter run -d linux               # Run on Linux"
echo ""
echo "📖 For more information, see README.md"