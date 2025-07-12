import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';

class PlatformService {
  static PlatformService? _instance;
  static PlatformService get instance => _instance ??= PlatformService._internal();
  
  PlatformService._internal();

  bool get isWeb => kIsWeb;
  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  bool get isDesktop => !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isMacOS => !kIsWeb && Platform.isMacOS;
  bool get isLinux => !kIsWeb && Platform.isLinux;

  String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  String get operatingSystem {
    if (kIsWeb) return 'Web';
    return Platform.operatingSystem;
  }

  String get operatingSystemVersion {
    if (kIsWeb) return 'Web';
    return Platform.operatingSystemVersion;
  }

  bool get supportsNotifications => !kIsWeb;
  bool get supportsFileSystem => !kIsWeb;
  bool get supportsBackgroundTasks => isMobile;
  bool get supportsWindowManagement => isDesktop;
  bool get supportsDesktopNotifications => isDesktop;
  bool get supportsLocalStorage => true;
  bool get supportsClipboard => true;
  bool get supportsSharing => true;
  bool get supportsUrlLaunching => true;

  // Platform-specific feature availability
  bool get canScheduleNotifications => supportsNotifications;
  bool get canAccessFileSystem => supportsFileSystem;
  bool get canMinimizeToTray => isDesktop;
  bool get canSetWindowTitle => isDesktop;
  bool get canResizeWindow => isDesktop;
  bool get canSetAppIcon => isDesktop;

  // Screen size categories
  bool get isSmallScreen => false; // Will be set based on actual screen size
  bool get isMediumScreen => false;
  bool get isLargeScreen => false;

  // Platform-specific UI configurations
  double get defaultWindowWidth {
    if (isDesktop) return 1280.0;
    return 375.0; // Mobile default
  }

  double get defaultWindowHeight {
    if (isDesktop) return 720.0;
    return 667.0; // Mobile default
  }

  double get minWindowWidth {
    if (isDesktop) return 800.0;
    return 320.0;
  }

  double get minWindowHeight {
    if (isDesktop) return 600.0;
    return 480.0;
  }

  // Platform-specific settings
  bool get shouldUseNativeScrollbars => isDesktop;
  bool get shouldShowWindowControls => isDesktop;
  bool get shouldUseContextMenus => isDesktop;
  bool get shouldUseDragAndDrop => isDesktop;
  bool get shouldUseKeyboardShortcuts => isDesktop;
  bool get shouldUseSystemTitleBar => isDesktop;
  bool get shouldUseTabletLayout => false; // Will be determined by screen size

  // Platform-specific storage paths
  String get defaultStoragePath {
    if (isDesktop) return 'Documents/Chakame';
    return 'chakame_data';
  }

  String get defaultCachePath {
    if (isDesktop) return 'Cache/Chakame';
    return 'chakame_cache';
  }

  // Platform-specific networking
  Map<String, String> get defaultHttpHeaders {
    return {
      'User-Agent': 'Chakame/${getPlatformIdentifier()}',
      'Accept': 'application/json',
      'Content-Type': 'application/json; charset=utf-8',
    };
  }

  String getPlatformIdentifier() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  // Platform-specific error handling
  String formatErrorForPlatform(String error) {
    if (isWeb) {
      return 'خطای وب: $error';
    } else if (isMobile) {
      return 'خطای موبایل: $error';
    } else if (isDesktop) {
      return 'خطای دسکتاپ: $error';
    }
    return 'خطا: $error';
  }

  // Platform-specific feature toggles
  bool shouldShowFeature(String featureName) {
    switch (featureName) {
      case 'notifications':
        return supportsNotifications;
      case 'file_export':
        return supportsFileSystem;
      case 'background_sync':
        return supportsBackgroundTasks;
      case 'window_controls':
        return supportsWindowManagement;
      case 'desktop_notifications':
        return supportsDesktopNotifications;
      case 'keyboard_shortcuts':
        return shouldUseKeyboardShortcuts;
      case 'drag_drop':
        return shouldUseDragAndDrop;
      case 'context_menus':
        return shouldUseContextMenus;
      default:
        return true;
    }
  }

  // Platform-specific UI adaptations
  double getScaleFactorForPlatform() {
    if (isDesktop) return 1.0;
    if (isWeb) return 1.0;
    return 1.0; // Will be determined by device pixel ratio
  }

  // Platform-specific performance optimizations
  bool shouldUseCaching() => true;
  bool shouldUseImageCaching() => true;
  bool shouldUseNetworkCaching() => true;
  bool shouldUseLazyLoading() => true;
  bool shouldUseVirtualization() => isDesktop || isWeb;

  // Platform-specific accessibility
  bool get supportsScreenReader => true;
  bool get supportsHighContrast => true;
  bool get supportsVoiceOver => isIOS;
  bool get supportsTalkBack => isAndroid;

  // Platform-specific theming
  bool get shouldFollowSystemTheme => true;
  bool get supportsSystemAccentColor => isWindows || isMacOS;
  bool get supportsTransparency => isDesktop;
  bool get supportsBlur => isDesktop || isIOS;

  // Debug information
  Map<String, dynamic> getPlatformInfo() {
    return {
      'platform': platformName,
      'isWeb': isWeb,
      'isMobile': isMobile,
      'isDesktop': isDesktop,
      'operatingSystem': operatingSystem,
      'operatingSystemVersion': kIsWeb ? 'N/A' : operatingSystemVersion,
      'supportsNotifications': supportsNotifications,
      'supportsFileSystem': supportsFileSystem,
      'supportsBackgroundTasks': supportsBackgroundTasks,
      'supportsWindowManagement': supportsWindowManagement,
      'defaultWindowSize': '${defaultWindowWidth}x${defaultWindowHeight}',
      'minWindowSize': '${minWindowWidth}x${minWindowHeight}',
    };
  }

  @override
  String toString() {
    return 'PlatformService(platform: $platformName, isWeb: $isWeb, isMobile: $isMobile, isDesktop: $isDesktop)';
  }
}