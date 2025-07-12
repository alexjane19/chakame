# شکامه (Chakame) - Iranian Poetry Daily

A beautiful Flutter application for exploring Persian poetry with daily notifications, favorites management, and seamless integration with the Ganjoor.net API.

## Features

### 🎯 Core Features
- **Random Poetry Generator**: Beautiful, animated button to get random poems from famous Iranian poets
- **Favorites System**: Save and manage favorite poems with heart/star icons
- **Daily Notifications**: Receive daily poem excerpts with customizable timing
- **Offline Support**: Cache poems locally for offline access
- **Persian Typography**: Beautiful RTL text rendering with Persian fonts

### 📱 Main Screens
- **Home Screen**: Large, prominent random poem button with recent favorites
- **Poem Detail**: Full poem display with sharing and favorite options
- **Favorites Page**: Browse, search, and sort saved poems
- **Settings**: Customize notifications, themes, and fonts

### 🔍 Advanced Features
- **Search & Filter**: Search poems by title, poet, or content
- **Sort Options**: Sort favorites by date, poet name, or title
- **Poet Selection**: Browse poems by specific poets
- **Share Functionality**: Share poems with friends
- **Dark/Light Theme**: Toggle between appearance modes

## Poets Included

- حافظ (Hafez)
- فردوسی (Ferdowsi)
- مولوی (Rumi)
- سعدی (Saadi)
- خیام (Khayyam)
- نظامی (Nezami)
- رودکی (Rudaki)
- پروین اعتصامی (Parvin Etesami)
- And many more...

## Technical Stack

### Framework & Language
- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language

### State Management
- **Provider**: For app-wide state management
- **Riverpod**: Alternative state management solution

### Data & Storage
- **Hive**: Local storage for caching and favorites
- **HTTP**: API communication with Ganjoor.net
- **JSON Serialization**: Data parsing and serialization

### UI & Animations
- **Material Design 3**: Modern UI components
- **Animations**: Smooth transitions and micro-interactions
- **Persian Fonts**: Vazir, Sahel, and other Persian fonts
- **RTL Support**: Right-to-left text rendering

### External Services
- **Ganjoor.net API**: Poetry data source
- **Flutter Local Notifications**: Daily poem notifications
- **Share Plus**: Social sharing functionality

## API Integration

The app integrates with the Ganjoor.net public API:

```
Base URL: https://api.ganjoor.net/
```

### Main Endpoints:
- `GET /poets` - Get all poets
- `GET /poet/{id}/poems/random` - Get random poem from specific poet
- `GET /poem/{id}` - Get specific poem
- `GET /poems/search` - Search poems

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── poem_model.dart
│   ├── poet_model.dart
│   ├── favorite_model.dart
│   └── ganjoor_response.dart
├── services/                 # Business logic
│   ├── api_service.dart
│   ├── storage_service.dart
│   └── notification_service.dart
├── providers/                # State management
│   ├── poem_provider.dart
│   ├── favorites_provider.dart
│   └── settings_provider.dart
├── screens/                  # UI screens
│   ├── main_screen.dart
│   ├── poem_detail_screen.dart
│   ├── favorites_screen.dart
│   └── settings_screen.dart
├── widgets/                  # Reusable components
│   ├── random_poem_button.dart
│   ├── poem_card.dart
│   ├── favorite_button.dart
│   ├── poet_card.dart
│   └── search_bar.dart
└── utils/
    └── constants.dart        # App constants
```

## Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.13.5
  flutter_local_notifications: ^14.0.0
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  provider: ^6.0.5
  persian_fonts: ^1.0.0
  share_plus: ^6.3.4
  path_provider: ^2.0.15
  connectivity_plus: ^3.0.6
  animations: ^2.0.7
  shamsi_date: ^1.0.0
  json_annotation: ^4.8.1
  cached_network_image: ^3.2.3
  intl: ^0.18.1
  cupertino_icons: ^1.0.2
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Platform-specific requirements (see below)
- Git

### Platform-Specific Requirements

#### 🤖 Android
- Android Studio or VS Code with Flutter/Dart extensions
- Android SDK
- Java Development Kit (JDK)

#### 🍎 iOS
- Xcode (macOS only)
- iOS Simulator
- Apple Developer Account (for device deployment)

#### 🌐 Web
- Chrome browser (for debugging)
- Web server (for deployment)

#### 🖥️ Desktop (Windows, macOS, Linux)
- Platform-specific development tools
- **Windows**: Visual Studio 2022 or Visual Studio Build Tools
- **macOS**: Xcode command line tools
- **Linux**: GTK development libraries

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/chakame.git
cd chakame
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate model files:
```bash
flutter packages pub run build_runner build
```

### Running the App

#### 📱 Mobile (Android/iOS)
```bash
# Run on connected device or emulator
flutter run

# Run on specific device
flutter run -d <device_id>

# Build release APK (Android)
flutter build apk --release

# Build release IPA (iOS)
flutter build ios --release
```

#### 🌐 Web
```bash
# Run in development mode
flutter run -d chrome

# Build for web deployment
flutter build web

# Serve locally
flutter run -d web-server --web-hostname localhost --web-port 8080
```

#### 🖥️ Desktop

**Windows:**
```bash
# Run on Windows
flutter run -d windows

# Build Windows executable
flutter build windows --release
```

**macOS:**
```bash
# Run on macOS
flutter run -d macos

# Build macOS app
flutter build macos --release
```

**Linux:**
```bash
# Install required dependencies (Ubuntu/Debian)
sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev

# Run on Linux
flutter run -d linux

# Build Linux executable
flutter build linux --release
```

## Platform-Specific Features

### 📱 Mobile (Android/iOS)
- **Touch Gestures**: Swipe, pinch, and tap interactions
- **Push Notifications**: Daily poem notifications
- **Offline Mode**: Full offline functionality
- **Share Integration**: Native sharing with other apps
- **Biometric Authentication**: Optional security features
- **Background Sync**: Automatic poem updates

### 🌐 Web
- **Progressive Web App (PWA)**: Install on desktop/mobile
- **Responsive Design**: Adapts to all screen sizes
- **Keyboard Shortcuts**: Desktop-style navigation
- **URL Routing**: Deep linking support
- **Service Worker**: Offline caching
- **Web Share API**: Native browser sharing

### 🖥️ Desktop (Windows/macOS/Linux)
- **Native Window Controls**: Minimize, maximize, close
- **System Tray Integration**: Run in background
- **Keyboard Shortcuts**: Full keyboard navigation
- **File System Access**: Import/export functionality
- **Desktop Notifications**: System notification center
- **Multi-Window Support**: Multiple poem windows
- **Menu Bar Integration**: Native application menus

### 🎯 Cross-Platform Features
- **Unified UI**: Consistent experience across platforms
- **Theme Synchronization**: Settings sync across devices
- **Cloud Backup**: Optional cloud storage integration
- **Responsive Layout**: Adaptive UI for any screen size
- **Accessibility**: Screen reader and keyboard support
- **Multi-Language**: Persian/English interface

## Features Breakdown

### 🎨 UI/UX Design
- Persian-inspired color scheme with traditional elements
- Smooth animations and transitions
- Beautiful typography with Persian fonts
- Responsive design for different screen sizes
- Accessibility features

### 🔔 Notification System
- Daily poem notifications at user-selected time
- Background notification scheduling
- Rich notification content with poet name and first line
- Tap to open full poem

### ❤️ Favorites Management
- Add/remove poems from favorites
- Search through favorites
- Sort by date, poet, or title
- Export favorites
- Statistics and insights

### 📱 Offline Support
- Cache poems locally using Hive
- Fallback to cached content when offline
- Intelligent caching strategy
- Storage management

### 🌐 API Integration
- Robust error handling
- Network connectivity checks
- Rate limiting compliance
- Fallback mechanisms

## Configuration

### Notifications
- Enable/disable daily notifications
- Set custom notification time
- Test notification functionality

### Appearance
- Toggle dark/light theme
- Select Persian fonts
- Customize UI preferences

### Data Management
- Clear cache
- Export favorites
- Storage statistics

## Performance Optimizations

- **Lazy Loading**: Efficient list rendering
- **Image Caching**: Poet photos and images
- **Memory Management**: Proper disposal of resources
- **Network Optimization**: Efficient API calls
- **Storage Optimization**: Compact data storage

## Error Handling

- **Network Errors**: Graceful offline fallback
- **API Errors**: User-friendly error messages
- **Storage Errors**: Data corruption recovery
- **Notification Errors**: Permission handling

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- **Ganjoor.net**: For providing the comprehensive Persian poetry API
- **Reza Amirkhasany**: Founder of Ganjoor project
- **Flutter Community**: For the amazing framework and packages
- **Persian Poetry Masters**: For their timeless contributions to literature

## Support

For support, please open an issue in the GitHub repository or contact the maintainers.

## Deployment

### 📱 Mobile App Stores

**Google Play Store (Android):**
```bash
# Build release APK
flutter build apk --release

# Build App Bundle (recommended)
flutter build appbundle --release
```

**Apple App Store (iOS):**
```bash
# Build for iOS
flutter build ios --release

# Archive in Xcode for App Store submission
```

### 🌐 Web Deployment

**Static Hosting (GitHub Pages, Netlify, Vercel):**
```bash
# Build for web
flutter build web --release

# Deploy the build/web directory to your hosting provider
```

**Docker Container:**
```dockerfile
FROM nginx:alpine
COPY build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### 🖥️ Desktop Distribution

**Windows:**
```bash
# Build Windows executable
flutter build windows --release

# Package with installer (using Inno Setup or similar)
```

**macOS:**
```bash
# Build macOS app
flutter build macos --release

# Notarize for App Store or create DMG
```

**Linux:**
```bash
# Build Linux executable
flutter build linux --release

# Package as AppImage, Snap, or Flatpak
```

### 📦 Distribution Packages

**Snap Package (Linux):**
```yaml
# snapcraft.yaml
name: chakame
version: '1.0.0'
summary: Iranian Poetry Daily
description: Beautiful Persian poetry app with daily notifications
```

**Flatpak (Linux):**
```yaml
# com.cilix.chakame.yaml
app-id: com.cilix.chakame
runtime: org.freedesktop.Platform
runtime-version: '22.08'
sdk: org.freedesktop.Sdk
```

**Chocolatey (Windows):**
```powershell
# Install via Chocolatey
choco install chakame
```

**Homebrew (macOS):**
```bash
# Install via Homebrew
brew install --cask chakame
```

## Performance Optimization

### 🚀 Build Optimizations
```bash
# Optimize for size
flutter build <platform> --release --obfuscate --split-debug-info=debug-symbols

# Tree shaking
flutter build <platform> --release --tree-shake-icons

# Enable R8 (Android)
flutter build apk --release --shrink
```

### 🔧 Runtime Optimizations
- **Lazy Loading**: Components load on demand
- **Image Caching**: Efficient image management
- **Database Optimization**: Indexed queries
- **Memory Management**: Proper disposal of resources

---

**شکامه** - تجربه‌ای نو از شعر فارسی 🌹

## Quick Start Commands

```bash
# Check Flutter installation
flutter doctor

# Enable platforms
flutter config --enable-web
flutter config --enable-windows-desktop
flutter config --enable-macos-desktop
flutter config --enable-linux-desktop

# List available devices
flutter devices

# Run on all platforms
flutter run -d chrome          # Web
flutter run -d windows         # Windows
flutter run -d macos           # macOS
flutter run -d linux           # Linux
flutter run                    # Mobile (default device)
```

# Run the AppImage
./Chakame-x86_64.AppImage

# Extract contents (if needed)
./Chakame-x86_64.AppImage --appimage-extract

# Create portable home directory
./Chakame-x86_64.AppImage --appimage-portable-home
