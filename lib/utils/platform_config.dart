import 'package:flutter/material.dart';
import '../services/platform_service.dart';

class PlatformConfig {
  static final PlatformService _platformService = PlatformService.instance;

  // Window configurations
  static const Size defaultWindowSize = Size(1280, 720);
  static const Size minWindowSize = Size(800, 600);
  static const Size maxWindowSize = Size(1920, 1080);

  // Platform-specific settings
  static Map<String, dynamic> get platformSettings {
    return {
      'window': {
        'defaultSize': defaultWindowSize,
        'minSize': minWindowSize,
        'maxSize': maxWindowSize,
        'resizable': _platformService.isDesktop,
        'center': true,
        'title': 'شکامه - شعر روزانه ایران',
        'titleBarStyle': _platformService.isDesktop ? 'normal' : 'hidden',
      },
      'features': {
        'notifications': _platformService.supportsNotifications,
        'fileSystem': _platformService.supportsFileSystem,
        'clipboard': _platformService.supportsClipboard,
        'sharing': _platformService.supportsSharing,
        'urlLaunching': _platformService.supportsUrlLaunching,
        'backgroundTasks': _platformService.supportsBackgroundTasks,
        'windowManagement': _platformService.supportsWindowManagement,
        'desktopNotifications': _platformService.supportsDesktopNotifications,
      },
      'ui': {
        'showBottomNavigation': _platformService.isMobile,
        'showSideNavigation': _platformService.isDesktop,
        'showAppBar': true,
        'showFab': _platformService.isMobile,
        'useNativeScrollbars': _platformService.isDesktop,
        'showWindowControls': _platformService.isDesktop,
        'useContextMenus': _platformService.isDesktop,
        'supportsDragDrop': _platformService.isDesktop,
        'supportsKeyboardShortcuts': _platformService.isDesktop,
        'useSystemTitleBar': _platformService.isDesktop,
      },
      'performance': {
        'useCaching': true,
        'useImageCaching': true,
        'useNetworkCaching': true,
        'useLazyLoading': true,
        'useVirtualization': _platformService.isDesktop || _platformService.isWeb,
        'maxCacheSize': _platformService.isDesktop ? 500 : 100, // MB
        'maxImageCacheSize': _platformService.isDesktop ? 200 : 50, // MB
      },
      'storage': {
        'defaultPath': _platformService.defaultStoragePath,
        'cachePath': _platformService.defaultCachePath,
        'maxStorageSize': _platformService.isDesktop ? 1000 : 200, // MB
        'autoBackup': _platformService.isDesktop,
        'encryptData': false,
      },
      'network': {
        'timeout': 15000, // ms
        'retryCount': 3,
        'headers': _platformService.defaultHttpHeaders,
        'userAgent': 'Chakame/${_platformService.getPlatformIdentifier()}',
        'enableCaching': true,
        'offlineMode': true,
      },
      'accessibility': {
        'screenReader': _platformService.supportsScreenReader,
        'highContrast': _platformService.supportsHighContrast,
        'voiceOver': _platformService.supportsVoiceOver,
        'talkBack': _platformService.supportsTalkBack,
        'keyboardNavigation': _platformService.isDesktop,
      },
      'theming': {
        'followSystemTheme': _platformService.shouldFollowSystemTheme,
        'supportsAccentColor': _platformService.supportsSystemAccentColor,
        'supportsTransparency': _platformService.supportsTransparency,
        'supportsBlur': _platformService.supportsBlur,
        'defaultTheme': 'light',
        'availableThemes': ['light', 'dark', 'system'],
      },
    };
  }

  // Keyboard shortcuts
  static Map<String, String> get keyboardShortcuts {
    if (!_platformService.isDesktop) return {};
    
    return {
      'ctrl+n': 'new_poem',
      'ctrl+f': 'search',
      'ctrl+d': 'add_to_favorites',
      'ctrl+s': 'share',
      'ctrl+c': 'copy',
      'ctrl+r': 'refresh',
      'ctrl+,': 'settings',
      'ctrl+h': 'home',
      'ctrl+shift+f': 'favorites',
      'f11': 'fullscreen',
      'ctrl+q': 'quit',
      'ctrl+w': 'close_window',
      'ctrl+shift+n': 'new_window',
      'ctrl+t': 'new_tab',
      'ctrl+shift+t': 'reopen_tab',
      'ctrl+1': 'tab_1',
      'ctrl+2': 'tab_2',
      'ctrl+3': 'tab_3',
      'ctrl+9': 'last_tab',
      'ctrl+tab': 'next_tab',
      'ctrl+shift+tab': 'previous_tab',
      'space': 'play_pause',
      'left': 'previous_poem',
      'right': 'next_poem',
      'up': 'scroll_up',
      'down': 'scroll_down',
      'home': 'go_to_top',
      'end': 'go_to_bottom',
      'pageup': 'page_up',
      'pagedown': 'page_down',
      'escape': 'close_dialog',
      'enter': 'confirm',
      'f1': 'help',
      'f5': 'refresh',
      'f12': 'developer_tools',
    };
  }

  // Context menu items
  static List<String> get contextMenuItems {
    if (!_platformService.isDesktop) return [];
    
    return [
      'copy',
      'select_all',
      'share',
      'add_to_favorites',
      'search_selection',
      'translate',
      'copy_link',
      'save_as',
      'print',
      'inspect_element',
    ];
  }

  // File associations
  static Map<String, List<String>> get fileAssociations {
    if (!_platformService.isDesktop) return {};
    
    return {
      'poem': ['.poem', '.txt'],
      'export': ['.json', '.csv', '.pdf'],
      'backup': ['.backup', '.bak'],
      'settings': ['.config', '.settings'],
    };
  }

  // URL schemes
  static List<String> get urlSchemes {
    return [
      'chakame://',
      'chakame-poem://',
      'chakame-poet://',
      'chakame-favorite://',
    ];
  }

  // Platform capabilities
  static bool canUseFeature(String feature) {
    final features = platformSettings['features'] as Map<String, dynamic>;
    return features[feature] as bool? ?? false;
  }

  // Get platform-specific configuration
  static T getPlatformValue<T>(String key, {T? defaultValue}) {
    final parts = key.split('.');
    dynamic current = platformSettings;
    
    for (final part in parts) {
      if (current is Map<String, dynamic> && current.containsKey(part)) {
        current = current[part];
      } else {
        return defaultValue as T;
      }
    }
    
    return current as T? ?? defaultValue as T;
  }

  // Window management
  static Map<String, dynamic> get windowConfig {
    return {
      'defaultWidth': defaultWindowSize.width,
      'defaultHeight': defaultWindowSize.height,
      'minWidth': minWindowSize.width,
      'minHeight': minWindowSize.height,
      'maxWidth': maxWindowSize.width,
      'maxHeight': maxWindowSize.height,
      'resizable': _platformService.isDesktop,
      'minimizable': _platformService.isDesktop,
      'maximizable': _platformService.isDesktop,
      'closable': true,
      'alwaysOnTop': false,
      'center': true,
      'skipTaskbar': false,
      'titleBarStyle': _platformService.isDesktop ? 'normal' : 'hidden',
      'backgroundColor': '#2E7D32',
      'hasShadow': true,
      'opacity': 1.0,
      'transparent': false,
      'frame': true,
      'thickFrame': true,
      'vibrancy': null,
      'visualEffectState': 'active',
    };
  }

  // App metadata
  static Map<String, String> get appMetadata {
    return {
      'name': 'شکامه',
      'displayName': 'شکامه - شعر روزانه ایران',
      'description': 'کاوش در دنیای زیبای شعر فارسی',
      'version': '1.0.0',
      'buildNumber': '1',
      'packageName': 'com.example.chakame',
      'bundleId': 'com.example.chakame',
      'publisher': 'Chakame Team',
      'copyright': '© 2024 Chakame. All rights reserved.',
      'website': 'https://chakame.app',
      'supportEmail': 'support@chakame.app',
      'privacyPolicy': 'https://chakame.app/privacy',
      'termsOfService': 'https://chakame.app/terms',
      'sourceCode': 'https://github.com/chakame/chakame',
      'issueTracker': 'https://github.com/chakame/chakame/issues',
      'license': 'MIT',
      'category': 'Education',
      'keywords': "'persian', 'poetry', 'literature', 'hafez', 'rumi'",
    };
  }

  // Debug information
  static Map<String, dynamic> get debugInfo {
    return {
      'platform': _platformService.platformName,
      'version': _platformService.operatingSystemVersion,
      'isDebug': true, // This would be set based on build mode
      'supportedFeatures': platformSettings['features'],
      'capabilities': {
        'canUseNotifications': canUseFeature('notifications'),
        'canUseFileSystem': canUseFeature('fileSystem'),
        'canUseClipboard': canUseFeature('clipboard'),
        'canUseSharing': canUseFeature('sharing'),
        'canUseUrlLaunching': canUseFeature('urlLaunching'),
        'canUseBackgroundTasks': canUseFeature('backgroundTasks'),
        'canUseWindowManagement': canUseFeature('windowManagement'),
        'canUseDesktopNotifications': canUseFeature('desktopNotifications'),
      },
    };
  }
}