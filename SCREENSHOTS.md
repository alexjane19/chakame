# 📱 Chakame Android Screenshots Guide

This guide explains how to generate screenshots of all pages from the Chakame Android app.

## 🚀 Quick Start

### Method 1: Automated Screenshots (Recommended)
```bash
# Run the full automated screenshot script
./take_screenshots.sh
```

### Method 2: Quick Manual Screenshots
```bash
# Run the simple manual screenshot script
./quick_screenshots.sh
```

## 📋 Prerequisites

1. **Android Setup:**
   - Android Studio installed
   - ADB available in PATH
   - Android device connected OR emulator running

2. **Flutter Setup:**
   - Flutter SDK installed
   - Project dependencies installed (`flutter pub get`)

3. **Device/Emulator:**
   - Android device in developer mode with USB debugging enabled
   - OR Android emulator running

## 🛠️ Available Scripts

### 1. `take_screenshots.sh` - Full Automated Script

**Features:**
- ✅ Automatic emulator detection and startup
- ✅ Automated app navigation using Flutter Driver
- ✅ Fallback to manual screenshots if automation fails
- ✅ Screen recording option
- ✅ HTML preview generation
- ✅ Comprehensive error handling

**Usage:**
```bash
chmod +x take_screenshots.sh
./take_screenshots.sh
```

**Output:**
- Screenshots in `screenshots/android/`
- HTML preview at `screenshots/android/index.html`
- Optional screen recording (`app_demo.mp4`)

### 2. `quick_screenshots.sh` - Simple Manual Script

**Features:**
- ✅ Simple ADB-based screenshot capture
- ✅ Manual navigation prompts
- ✅ Quick setup and execution
- ✅ No additional dependencies

**Usage:**
```bash
chmod +x quick_screenshots.sh
./quick_screenshots.sh
```

**Process:**
1. Start the script
2. Launch Chakame app manually
3. Navigate to each screen when prompted
4. Press ENTER to capture each screenshot

## 📸 Screenshots Captured

The scripts will capture these key screens:

1. **Home/Main Screen** - App landing page with random poem button
2. **Random Poem** - Display of a Persian poem
3. **Favorites (Empty)** - Empty favorites state
4. **Favorites (With Content)** - Favorites with saved poems
5. **Settings Screen** - App settings and preferences
6. **Dark Mode** - App in dark theme (if available)
7. **Notification Settings** - Notification preferences
8. **About Screen** - App information and credits

## 📁 Output Structure

```
screenshots/
└── android/
    ├── 01_home_screen.png
    ├── 02_random_poem.png
    ├── 03_favorites_empty.png
    ├── 04_favorites_with_content.png
    ├── 05_settings_screen.png
    ├── 06_dark_mode.png
    ├── 07_notification_settings.png
    ├── 08_about_screen.png
    ├── app_demo.mp4 (if screen recording was created)
    └── index.html (HTML preview)
```

## 🔧 Manual Screenshot Methods

If the automated scripts don't work, you can take screenshots manually:

### Using ADB Command Line:
```bash
# Take screenshot
adb shell screencap -p /sdcard/screenshot.png

# Download screenshot
adb pull /sdcard/screenshot.png ./screenshot.png

# Clean up
adb shell rm /sdcard/screenshot.png
```

### Using Android Studio:
1. Open Device Manager
2. Click on device/emulator
3. Click camera icon to take screenshot
4. Save to desired location

### Using Device Physical Buttons:
- **Most Android devices:** Power + Volume Down
- Screenshots saved to device gallery

## 🛡️ Troubleshooting

### Common Issues:

**1. "No devices found"**
- Ensure USB debugging is enabled
- Check device connection with `adb devices`
- Try `adb kill-server && adb start-server`

**2. "App not responding during automation"**
- The app might need manual interaction
- Use the quick manual script instead
- Check if app is in correct language (Persian/English)

**3. "Permission denied"**
- Make scripts executable: `chmod +x *.sh`
- Check ADB permissions on device

**4. "Flutter Driver connection failed"**
- Ensure app is built in debug mode
- Check that test_driver files exist
- Try manual screenshot method

### Getting Help:

1. Check device connection: `adb devices`
2. Verify app is running: `adb shell pm list packages | grep chakame`
3. Check Flutter setup: `flutter doctor`
4. View script logs for detailed error messages

## 🎯 Usage Tips

1. **For App Store:** Use high-resolution device/emulator (1080p+)
2. **For Documentation:** Include captions describing each screen
3. **For Marketing:** Capture screens with attractive content
4. **For Bug Reports:** Include relevant error states

## 📱 Recommended Devices/Emulators

- **Pixel 6** (API 33) - Modern Android
- **Pixel 4** (API 30) - Standard size
- **Nexus 5X** (API 28) - Older Android support
- **Tablet** (API 33) - Tablet layout testing

## 🌐 HTML Preview

The automated script generates an HTML preview file that allows you to:
- View all screenshots in a web browser
- Share screenshots easily
- Get an overview of the entire app flow
- Export to PDF for documentation

Open `screenshots/android/index.html` in any web browser to view the preview.

## 📝 Notes

- Screenshots are saved in PNG format for best quality
- Dark mode screenshots help showcase theme support
- Persian text screenshots demonstrate proper RTL layout
- Screen recordings provide dynamic app flow demonstration

---

**Happy Screenshot Taking! 📸**