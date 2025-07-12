import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'چکامه';
  static const String appSubtitle = 'شعر روزانه پارسی';
  static const String appVersion = '1.0.0';
  
  static const String apiBaseUrl = 'https://api.ganjoor.net';
  static const Duration apiTimeout = Duration(seconds: 15);
  
  static const String ganjoorUrl = 'https://ganjoor.net';
  static const String ganjoorApiDocs = 'https://api.ganjoor.net/swagger/index.html';
  
  static const List<String> famousPoets = [
    'حافظ',
    'فردوسی',
    'مولوی',
    'سعدی',
    'خیام',
    'نظامی',
    'رودکی',
    'پروین اعتصامی',
  ];
  
  static const List<String> availableFonts = [
    'IranSans',
    'Vazir',
    'Tahoma',
    'Arial',
  ];
  
  static const Map<String, String> fontDisplayNames = {
    'IranSans': 'ایران سنس',
    'Vazir': 'وزیر',
    'Tahoma': 'تاهوما',
    'Arial': 'آریال',
  };
}

class AppColors {
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color primaryColorLight = Color(0xFF60AD5E);
  static const Color primaryColorDark = Color(0xFF005005);
  
  static const Color accentColor = Color(0xFFFF6F00);
  static const Color accentColorLight = Color(0xFFFF9F40);
  static const Color accentColorDark = Color(0xFFC43E00);
  
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color backgroundColorDark = Color(0xFF121212);
  
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color cardColorDark = Color(0xFF1E1E1E);
  
  static const Color textPrimary = Color(0xFF212121);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  
  static const Color textSecondary = Color(0xFF757575);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);
  
  static const Color favoriteColor = Color(0xFFE91E63);
  static const Color favoriteColorLight = Color(0xFFFF6090);
  
  static const Color dividerColor = Color(0xFFBDBDBD);
  static const Color dividerColorDark = Color(0xFF424242);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, primaryColorLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentColor, accentColorLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyText1 = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
    height: 1.8,
  );
  
  static const TextStyle bodyText2 = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.6,
  );
  
  static const TextStyle poemText = TextStyle(
    fontSize: 18,
    color: AppColors.textPrimary,
    height: 2.0,
    fontWeight: FontWeight.w400,
  );
  
  static const TextStyle poetName = TextStyle(
    fontSize: 16,
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle poemTitle = TextStyle(
    fontSize: 18,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;
  
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  static const double marginExtraLarge = 32.0;
  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusExtraLarge = 24.0;
  
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
  
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  
  static const double buttonHeight = 48.0;
  static const double buttonHeightLarge = 56.0;
  
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 60.0;
  
  static const double cardMinHeight = 120.0;
  static const double cardMaxHeight = 200.0;
  
  static const double randomButtonSize = 200.0;
  static const double randomButtonSizeLarge = 240.0;
}


class AppAnimations {
  static const Duration shortDuration = Duration(milliseconds: 200);
  static const Duration mediumDuration = Duration(milliseconds: 300);
  static const Duration longDuration = Duration(milliseconds: 500);
  static const Duration extraLongDuration = Duration(milliseconds: 800);
  
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceInCurve = Curves.bounceIn;
  static const Curve bounceOutCurve = Curves.bounceOut;
  static const Curve elasticInCurve = Curves.elasticIn;
  static const Curve elasticOutCurve = Curves.elasticOut;
}