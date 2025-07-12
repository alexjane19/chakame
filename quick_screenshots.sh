#!/bin/bash

# Quick Android Screenshots Script
# Simple script to take screenshots using ADB

echo "📱 Quick Android Screenshots for Chakame"
echo "========================================"

# Check if adb is available
if ! command -v adb &> /dev/null; then
    echo "❌ ADB is not installed or not in PATH"
    exit 1
fi

# Check for connected devices
DEVICES=$(adb devices | grep -E "(device|emulator)" | wc -l)
if [ "$DEVICES" -eq 0 ]; then
    echo "❌ No Android devices connected. Please connect a device or start an emulator."
    exit 1
fi

# Create screenshots directory
mkdir -p screenshots/android

echo "✅ Android device detected"
echo "📸 Ready to take screenshots"
echo ""
echo "Instructions:"
echo "1. Make sure Chakame app is running on your device"
echo "2. Navigate to each screen manually"
echo "3. Press ENTER to capture each screen"
echo ""

# Function to take screenshot
take_screenshot() {
    local name=$1
    local description=$2
    
    echo -n "📱 $description - Press ENTER to capture..."
    read
    
    adb shell screencap -p /sdcard/temp_screenshot.png
    adb pull /sdcard/temp_screenshot.png "screenshots/android/${name}.png"
    adb shell rm /sdcard/temp_screenshot.png
    
    echo "✅ Screenshot saved: screenshots/android/${name}.png"
    echo ""
}

# Take screenshots
echo "Starting screenshot capture..."
echo ""

take_screenshot "01_home_screen" "Navigate to HOME/MAIN screen"
take_screenshot "02_random_poem" "Show a RANDOM POEM or poem detail"
take_screenshot "03_favorites_empty" "Navigate to FAVORITES (empty state)"
take_screenshot "04_favorites_with_content" "FAVORITES with some poems (if available)"
take_screenshot "05_settings_screen" "Navigate to SETTINGS screen"
take_screenshot "06_dark_mode" "Toggle DARK MODE (if available)"
take_screenshot "07_notification_settings" "NOTIFICATION settings (if available)"
take_screenshot "08_about_screen" "ABOUT screen (if available)"

echo "🎉 Screenshot capture completed!"
echo ""
echo "📁 Screenshots saved in: screenshots/android/"
echo "📋 Files created:"
ls -la screenshots/android/*.png 2>/dev/null || echo "No screenshots found"

echo ""
echo "💡 Tip: You can view the screenshots or use them for:"
echo "   - App store listings"
echo "   - Documentation"
echo "   - Marketing materials"
echo "   - Bug reports"