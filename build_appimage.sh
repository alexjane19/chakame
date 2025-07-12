#!/bin/bash

# Chakame Linux AppImage Build Script
# This script builds the Flutter app for Linux and creates an AppImage

set -e  # Exit on any error

echo "🚀 Starting Chakame Linux AppImage Build Process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    exit 1
fi

# Check if we're in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "This script must be run from the Flutter project root directory"
    exit 1
fi

# Get app version from pubspec.yaml
APP_VERSION=$(grep "version:" pubspec.yaml | cut -d' ' -f2 | cut -d'+' -f1)
print_status "Building Chakame version $APP_VERSION"

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean

# Get dependencies
print_status "Getting Flutter dependencies..."
flutter pub get

# Generate localization files
print_status "Generating localization files..."
flutter gen-l10n

# Build Linux release
print_status "Building Flutter Linux release..."
flutter build linux --release

# Check if build was successful
if [ ! -f "build/linux/x64/release/bundle/chakame" ]; then
    print_error "Linux build failed - executable not found"
    exit 1
fi

print_success "Linux build completed successfully"

# Download linuxdeploy if not present
LINUXDEPLOY_FILE="linuxdeploy-x86_64.AppImage"
if [ ! -f "$LINUXDEPLOY_FILE" ]; then
    print_status "Downloading linuxdeploy..."
    wget -q https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage
    chmod +x "$LINUXDEPLOY_FILE"
    print_success "linuxdeploy downloaded"
else
    print_status "Using existing linuxdeploy"
fi

# Clean up previous AppImage artifacts
print_status "Cleaning up previous AppImage artifacts..."
rm -rf AppDir
rm -f Chakame-*.AppImage

# Create AppImage directory structure
print_status "Creating AppImage directory structure..."
mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/lib
mkdir -p AppDir/usr/share/chakame
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/pixmaps

# Copy Flutter build files
print_status "Copying Flutter build files..."
cp -r build/linux/x64/release/bundle/* AppDir/usr/share/chakame/

# Create wrapper script
print_status "Creating wrapper script..."
cat > AppDir/usr/bin/chakame << 'EOF'
#!/bin/bash
# Chakame AppImage wrapper script

APPDIR="$(dirname "$(dirname "$(dirname "$(readlink -f "${0}")")")")"
export LD_LIBRARY_PATH="$APPDIR/usr/share/chakame/lib:$LD_LIBRARY_PATH"

exec "$APPDIR/usr/share/chakame/chakame" "$@"
EOF

chmod +x AppDir/usr/bin/chakame

# Create .desktop file
print_status "Creating .desktop file..."
cat > AppDir/usr/share/applications/chakame.desktop << EOF
[Desktop Entry]
Name=Chakame
Comment=Iranian Poetry Daily with random poems from famous Persian poets
Exec=chakame
Icon=chakame
Type=Application
Categories=Education;Literature;
StartupNotify=true
StartupWMClass=chakame
Keywords=poetry;persian;literature;poems;
EOF

# Copy icon
print_status "Copying application icon..."
cp assets/images/chakame.png AppDir/chakame.png
cp assets/images/chakame.png AppDir/usr/share/pixmaps/chakame.png

# Create AppRun file
print_status "Creating AppRun file..."
cat > AppDir/AppRun << 'EOF'
#!/bin/bash
# Chakame AppImage AppRun script

APPDIR="$(dirname "$(readlink -f "${0}")")"
export LD_LIBRARY_PATH="$APPDIR/usr/share/chakame/lib:$LD_LIBRARY_PATH"

exec "$APPDIR/usr/share/chakame/chakame" "$@"
EOF

chmod +x AppDir/AppRun

# Create symlink to desktop file in AppDir root
print_status "Creating desktop file symlink..."
ln -sf usr/share/applications/chakame.desktop AppDir/chakame.desktop

# Generate AppImage
print_status "Generating AppImage..."
export ARCH=x86_64
./linuxdeploy-x86_64.AppImage --appdir AppDir --output appimage

# Check if AppImage was created
APPIMAGE_FILE="Chakame-x86_64.AppImage"
if [ -f "$APPIMAGE_FILE" ]; then
    APP_SIZE=$(du -h "$APPIMAGE_FILE" | cut -f1)
    print_success "AppImage created successfully: $APPIMAGE_FILE ($APP_SIZE)"
    
    # Make it executable
    chmod +x "$APPIMAGE_FILE"
    
    # Test the AppImage
    print_status "Testing AppImage..."
    if ./"$APPIMAGE_FILE" --appimage-help > /dev/null 2>&1; then
        print_success "AppImage is working correctly"
    else
        print_warning "AppImage might have issues (basic test failed)"
    fi
else
    print_error "AppImage creation failed"
    exit 1
fi

# Clean up temporary files
print_status "Cleaning up temporary files..."
rm -rf AppDir

# Final output
echo
print_success "✅ Build process completed successfully!"
echo -e "${GREEN}📦 AppImage:${NC} $APPIMAGE_FILE"
echo -e "${GREEN}📏 Size:${NC} $APP_SIZE"
echo -e "${GREEN}🔧 Version:${NC} $APP_VERSION"
echo
echo -e "${BLUE}To run the AppImage:${NC}"
echo -e "  ./$APPIMAGE_FILE"
echo
echo -e "${BLUE}To distribute:${NC}"
echo -e "  The $APPIMAGE_FILE file is ready for distribution"
echo -e "  Users can download it and run it on any Linux system"
echo