#!/bin/bash

# Chakame Android Screenshots Generation Script
# This script automates taking screenshots of all app pages

set -e

echo "📱 Starting Chakame Android Screenshots Generation..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Check if adb is available
if ! command -v adb &> /dev/null; then
    print_error "ADB is not installed or not in PATH"
    exit 1
fi

# Check if we're in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "This script must be run from the Flutter project root directory"
    exit 1
fi

# Create screenshots directory
print_status "Creating screenshots directory..."
mkdir -p screenshots
mkdir -p screenshots/android

# Check for connected Android devices or emulators
print_status "Checking for Android devices..."
DEVICES=$(adb devices | grep -E "(device|emulator)" | wc -l)

if [ "$DEVICES" -eq 0 ]; then
    print_warning "No Android devices connected. Attempting to start emulator..."
    
    # Try to start an emulator
    EMULATORS=$(flutter emulators | grep -E "android" | head -n 1 | awk '{print $2}' | sed 's/•//')
    
    if [ -n "$EMULATORS" ]; then
        print_status "Starting emulator: $EMULATORS"
        flutter emulators --launch "$EMULATORS" &
        
        # Wait for emulator to boot
        print_status "Waiting for emulator to boot..."
        sleep 30
        
        # Check again
        DEVICES=$(adb devices | grep -E "(device|emulator)" | wc -l)
        if [ "$DEVICES" -eq 0 ]; then
            print_error "Failed to start emulator or device not ready"
            exit 1
        fi
    else
        print_error "No Android emulators found. Please start an emulator or connect a device."
        exit 1
    fi
fi

print_success "Android device/emulator detected"

# Build the app for Android
print_status "Building Android app..."
flutter build apk --debug

# Method 1: Using Flutter Driver (Automated)
print_status "Method 1: Attempting automated screenshots with Flutter Driver..."

# Add flutter_driver dependency temporarily
if ! grep -q "flutter_driver:" pubspec.yaml; then
    print_status "Adding flutter_driver dependency..."
    cat >> pubspec.yaml << EOF

# Temporary dependency for screenshots
dev_dependencies:
  flutter_driver:
    sdk: flutter
EOF
    flutter pub get
fi

# Run the screenshot test
print_status "Running automated screenshot test..."
if flutter drive --target=test_driver/app.dart --driver=test_driver/screenshot_test.dart; then
    print_success "Automated screenshots completed successfully!"
    
    # Move screenshots to android folder
    if [ -d "screenshots" ]; then
        mv screenshots/*.png screenshots/android/ 2>/dev/null || true
    fi
else
    print_warning "Automated screenshot test failed. Falling back to manual method..."
    
    # Method 2: Manual screenshots with ADB
    print_status "Method 2: Taking manual screenshots with ADB..."
    
    # Install and run the app
    print_status "Installing and running the app..."
    flutter install
    
    # Take basic screenshots
    print_status "Taking screenshots (you may need to navigate manually)..."
    
    # Wait for app to start
    sleep 5
    
    # Take initial screenshot
    adb shell screencap -p /sdcard/screenshot_01_main.png
    adb pull /sdcard/screenshot_01_main.png screenshots/android/01_main_screen.png
    print_status "Screenshot 1/4: Main screen captured"
    
    # Instructions for manual navigation
    echo
    print_warning "📱 MANUAL NAVIGATION REQUIRED:"
    echo -e "${YELLOW}Please manually navigate through the app and press ENTER after each screen:${NC}"
    
    echo -n "Navigate to Favorites screen and press ENTER..."
    read
    adb shell screencap -p /sdcard/screenshot_02_favorites.png
    adb pull /sdcard/screenshot_02_favorites.png screenshots/android/02_favorites_screen.png
    print_status "Screenshot 2/4: Favorites screen captured"
    
    echo -n "Navigate to Settings screen and press ENTER..."
    read
    adb shell screencap -p /sdcard/screenshot_03_settings.png
    adb pull /sdcard/screenshot_03_settings.png screenshots/android/03_settings_screen.png
    print_status "Screenshot 3/4: Settings screen captured"
    
    echo -n "Navigate to any poem detail screen and press ENTER..."
    read
    adb shell screencap -p /sdcard/screenshot_04_poem.png
    adb pull /sdcard/screenshot_04_poem.png screenshots/android/04_poem_detail.png
    print_status "Screenshot 4/4: Poem detail captured"
    
    # Clean up temporary files on device
    adb shell rm /sdcard/screenshot_*.png
fi

# Method 3: Alternative - Screen recording
print_status "Method 3: Creating screen recording (optional)..."
echo -n "Would you like to create a screen recording? (y/N): "
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    print_status "Starting 30-second screen recording..."
    print_warning "Please navigate through the app during recording..."
    
    adb shell screenrecord --time-limit 30 /sdcard/chakame_demo.mp4 &
    RECORD_PID=$!
    
    sleep 30
    
    print_status "Downloading screen recording..."
    adb pull /sdcard/chakame_demo.mp4 screenshots/android/app_demo.mp4
    adb shell rm /sdcard/chakame_demo.mp4
    
    print_success "Screen recording saved to screenshots/android/app_demo.mp4"
fi

# List generated screenshots
print_status "Generated screenshots:"
ls -la screenshots/android/

# Generate a simple HTML preview
print_status "Generating HTML preview..."
cat > screenshots/android/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Chakame Android Screenshots</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; }
        .screenshot { margin: 20px 0; text-align: center; }
        .screenshot img { max-width: 300px; height: auto; border: 1px solid #ddd; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .screenshot h3 { color: #333; margin-bottom: 10px; }
        .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        h1 { color: #2c3e50; text-align: center; }
        .info { background: #e8f4f8; padding: 15px; border-radius: 4px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌹 Chakame - Persian Poetry App Screenshots</h1>
        
        <div class="info">
            <strong>App:</strong> Chakame - Iranian Poetry Daily<br>
            <strong>Platform:</strong> Android<br>
            <strong>Generated:</strong> $(date)<br>
            <strong>Description:</strong> Random poems from famous Persian poets
        </div>
        
        <div class="grid">
EOF

# Add screenshots to HTML
for img in screenshots/android/*.png; do
    if [ -f "$img" ]; then
        basename=$(basename "$img" .png)
        title=$(echo "$basename" | sed 's/_/ /g' | sed 's/\b\w/\U&/g')
        cat >> screenshots/android/index.html << EOF
            <div class="screenshot">
                <h3>$title</h3>
                <img src="$(basename "$img")" alt="$title">
            </div>
EOF
    fi
done

cat >> screenshots/android/index.html << EOF
        </div>
        
        <div style="text-align: center; margin-top: 40px; color: #666;">
            <p>Generated with Flutter Screenshot Tool</p>
        </div>
    </div>
</body>
</html>
EOF

print_success "HTML preview generated: screenshots/android/index.html"

# Final summary
echo
print_success "✅ Screenshot generation completed!"
echo -e "${GREEN}📁 Screenshots location:${NC} screenshots/android/"
echo -e "${GREEN}🌐 HTML Preview:${NC} screenshots/android/index.html"
echo -e "${GREEN}📱 Platform:${NC} Android"
echo
echo -e "${BLUE}To view screenshots:${NC}"
echo -e "  Open screenshots/android/index.html in a web browser"
echo -e "  Or check individual PNG files in screenshots/android/"
echo