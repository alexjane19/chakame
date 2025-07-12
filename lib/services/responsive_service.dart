import 'package:flutter/material.dart';
import 'platform_service.dart';

enum ScreenSize {
  small,   // Mobile phones
  medium,  // Tablets
  large,   // Desktop and large tablets
  xlarge,  // Very large screens
}

enum LayoutType {
  mobile,
  tablet,
  desktop,
}

class ResponsiveService {
  static ResponsiveService? _instance;
  static ResponsiveService get instance => _instance ??= ResponsiveService._internal();
  
  ResponsiveService._internal();

  // Breakpoints
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1024.0;
  static const double desktopBreakpoint = 1440.0;

  ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < mobileBreakpoint) {
      return ScreenSize.small;
    } else if (width < tabletBreakpoint) {
      return ScreenSize.medium;
    } else if (width < desktopBreakpoint) {
      return ScreenSize.large;
    } else {
      return ScreenSize.xlarge;
    }
  }

  LayoutType getLayoutType(BuildContext context) {
    final platformService = PlatformService.instance;
    final screenSize = getScreenSize(context);
    
    if (platformService.isDesktop) {
      return LayoutType.desktop;
    } else if (screenSize == ScreenSize.medium || screenSize == ScreenSize.large) {
      return LayoutType.tablet;
    } else {
      return LayoutType.mobile;
    }
  }

  bool isMobile(BuildContext context) {
    return getLayoutType(context) == LayoutType.mobile;
  }

  bool isTablet(BuildContext context) {
    return getLayoutType(context) == LayoutType.tablet;
  }

  bool isDesktop(BuildContext context) {
    return getLayoutType(context) == LayoutType.desktop;
  }

  bool isSmallScreen(BuildContext context) {
    return getScreenSize(context) == ScreenSize.small;
  }

  bool isLargeScreen(BuildContext context) {
    final screenSize = getScreenSize(context);
    return screenSize == ScreenSize.large || screenSize == ScreenSize.xlarge;
  }

  // Layout configurations
  int getColumnsForGrid(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 1;
      case ScreenSize.medium:
        return 2;
      case ScreenSize.large:
        return 3;
      case ScreenSize.xlarge:
        return 4;
    }
  }

  int getColumnsForPoetGrid(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 1;
      case ScreenSize.medium:
        return 2;
      case ScreenSize.large:
        return 3;
      case ScreenSize.xlarge:
        return 4;
    }
  }

  double getContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenSize = getScreenSize(context);
    
    switch (screenSize) {
      case ScreenSize.small:
        return screenWidth;
      case ScreenSize.medium:
        return screenWidth * 0.9;
      case ScreenSize.large:
        return screenWidth * 0.8;
      case ScreenSize.xlarge:
        return screenWidth * 0.7;
    }
  }

  double getMaxContentWidth(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return double.infinity;
      case ScreenSize.medium:
        return 800.0;
      case ScreenSize.large:
        return 1200.0;
      case ScreenSize.xlarge:
        return 1400.0;
    }
  }

  // Padding and margins
  double getHorizontalPadding(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 16.0;
      case ScreenSize.medium:
        return 24.0;
      case ScreenSize.large:
        return 32.0;
      case ScreenSize.xlarge:
        return 48.0;
    }
  }

  double getVerticalPadding(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 16.0;
      case ScreenSize.medium:
        return 20.0;
      case ScreenSize.large:
        return 24.0;
      case ScreenSize.xlarge:
        return 32.0;
    }
  }

  double getCardPadding(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 16.0;
      case ScreenSize.medium:
        return 20.0;
      case ScreenSize.large:
        return 24.0;
      case ScreenSize.xlarge:
        return 28.0;
    }
  }

  // Typography scaling
  double getFontScale(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 1.0;
      case ScreenSize.medium:
        return 1.1;
      case ScreenSize.large:
        return 1.2;
      case ScreenSize.xlarge:
        return 1.3;
    }
  }

  double getHeadlineFontSize(BuildContext context) {
    final baseSize = 24.0;
    return baseSize * getFontScale(context);
  }

  double getBodyFontSize(BuildContext context) {
    final baseSize = 16.0;
    return baseSize * getFontScale(context);
  }

  double getPoemFontSize(BuildContext context) {
    final baseSize = 18.0;
    return baseSize * getFontScale(context);
  }

  // Button and component sizes
  double getButtonHeight(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 48.0;
      case ScreenSize.medium:
        return 52.0;
      case ScreenSize.large:
        return 56.0;
      case ScreenSize.xlarge:
        return 60.0;
    }
  }

  double getRandomButtonSize(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 200.0;
      case ScreenSize.medium:
        return 240.0;
      case ScreenSize.large:
        return 280.0;
      case ScreenSize.xlarge:
        return 320.0;
    }
  }

  double getIconSize(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 24.0;
      case ScreenSize.medium:
        return 28.0;
      case ScreenSize.large:
        return 32.0;
      case ScreenSize.xlarge:
        return 36.0;
    }
  }

  // Layout helpers
  bool shouldUseBottomNavigation(BuildContext context) {
    return isMobile(context) || isTablet(context);
  }

  bool shouldUseSideNavigation(BuildContext context) {
    return isDesktop(context) && isLargeScreen(context);
  }

  bool shouldUseDrawer(BuildContext context) {
    return isMobile(context) || (isTablet(context) && !isLargeScreen(context));
  }

  bool shouldUseExpandedLayout(BuildContext context) {
    return isDesktop(context) || isLargeScreen(context);
  }

  bool shouldUseCompactLayout(BuildContext context) {
    return isMobile(context) || isSmallScreen(context);
  }

  // Specific layout configurations
  EdgeInsets getPagePadding(BuildContext context) {
    final horizontal = getHorizontalPadding(context);
    final vertical = getVerticalPadding(context);
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  EdgeInsets getCardMargin(BuildContext context) {
    final padding = getHorizontalPadding(context) / 2;
    return EdgeInsets.all(padding);
  }

  BorderRadius getCardBorderRadius(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return BorderRadius.circular(12.0);
      case ScreenSize.medium:
        return BorderRadius.circular(16.0);
      case ScreenSize.large:
        return BorderRadius.circular(20.0);
      case ScreenSize.xlarge:
        return BorderRadius.circular(24.0);
    }
  }

  // AppBar configurations
  double getAppBarHeight(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 56.0;
      case ScreenSize.medium:
        return 64.0;
      case ScreenSize.large:
        return 72.0;
      case ScreenSize.xlarge:
        return 80.0;
    }
  }

  bool shouldUseExpandedAppBar(BuildContext context) {
    return isDesktop(context) || isLargeScreen(context);
  }

  // Responsive widget builders
  Widget buildResponsiveLayout({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    final layoutType = getLayoutType(context);
    
    switch (layoutType) {
      case LayoutType.mobile:
        return mobile;
      case LayoutType.tablet:
        return tablet ?? mobile;
      case LayoutType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  T buildResponsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final layoutType = getLayoutType(context);
    
    switch (layoutType) {
      case LayoutType.mobile:
        return mobile;
      case LayoutType.tablet:
        return tablet ?? mobile;
      case LayoutType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  // Grid configurations
  SliverGridDelegate getGridDelegate(BuildContext context, {int? forceColumns}) {
    final columns = forceColumns ?? getColumnsForGrid(context);
    final spacing = getHorizontalPadding(context) / 2;
    
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: isDesktop(context) ? 1.2 : 1.0,
    );
  }

  // Navigation configurations
  double getNavigationWidth(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return 280.0;
      case ScreenSize.medium:
        return 320.0;
      case ScreenSize.large:
        return 360.0;
      case ScreenSize.xlarge:
        return 400.0;
    }
  }

  // Debug information
  Map<String, dynamic> getResponsiveInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return {
      'screenSize': getScreenSize(context).toString(),
      'layoutType': getLayoutType(context).toString(),
      'width': size.width,
      'height': size.height,
      'columns': getColumnsForGrid(context),
      'contentWidth': getContentWidth(context),
      'horizontalPadding': getHorizontalPadding(context),
      'shouldUseBottomNav': shouldUseBottomNavigation(context),
      'shouldUseSideNav': shouldUseSideNavigation(context),
      'shouldUseDrawer': shouldUseDrawer(context),
    };
  }
}