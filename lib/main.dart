import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chakame/l10n/l10n.dart';

import 'providers/favorites_provider.dart';
import 'providers/settings_provider.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'services/platform_service.dart';
import 'services/responsive_service.dart';
import 'screens/main_screen.dart';
import 'screens/desktop_main_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await _initializeApp();
  
  runApp(const ProviderScope(child: ChakameApp()));
}

Future<void> _initializeApp() async {
  try {
    tz.initializeTimeZones();
    
    await StorageService.init();
    
    await NotificationService.instance.init();
    
    // Request notification permissions
    await NotificationService.instance.requestPermissions();
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    
  } catch (e) {
    debugPrint('Error initializing app: $e');
  }
}

class ChakameApp extends StatelessWidget {
  const ChakameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final settingsState = ref.watch(settingsProvider);
        
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: _buildLightTheme(settingsState.selectedFont),
          darkTheme: _buildDarkTheme(settingsState.selectedFont),
          themeMode: settingsState.darkMode ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(settingsState.selectedLanguage),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('fa', ''),
          ],
          builder: (context, child) {
            return Directionality(
              textDirection: settingsState.selectedLanguage == 'fa' 
                  ? ui.TextDirection.rtl 
                  : ui.TextDirection.ltr,
              child: child!,
            );
          },
          home: const PlatformAwareHome(),
          routes: {
            '/favorites': (context) => const FavoritesScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/privacy': (context) => const PrivacyPolicyScreen(),
          },
        );
      },
    );
  }

  ThemeData _buildLightTheme(String fontFamily) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.light,
      ),
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      cardColor: AppColors.cardColor,
      fontFamily: _getFontFamily(fontFamily),
      textTheme: _buildTextTheme(fontFamily, false),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: fontFamily,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLarge,
            vertical: AppDimensions.paddingMedium,
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: AppDimensions.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        color: AppColors.cardColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        contentPadding: const EdgeInsets.all(AppDimensions.paddingMedium),
      ),
    );
  }

  ThemeData _buildDarkTheme(String fontFamily) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: Brightness.dark,
      ),
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColorDark,
      cardColor: AppColors.cardColorDark,
      fontFamily: _getFontFamily(fontFamily),
      textTheme: _buildTextTheme(fontFamily, true),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: fontFamily,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingLarge,
            vertical: AppDimensions.paddingMedium,
          ),
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: fontFamily,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: AppDimensions.elevationMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        color: AppColors.cardColorDark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        contentPadding: const EdgeInsets.all(AppDimensions.paddingMedium),
      ),
    );
  }

  TextTheme _buildTextTheme(String fontFamily, bool isDark) {
    final baseColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: baseColor,
        fontFamily: fontFamily,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: baseColor,
        fontFamily: fontFamily,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: baseColor,
        fontFamily: fontFamily,
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: baseColor,
        fontFamily: fontFamily,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: baseColor,
        fontFamily: fontFamily,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: baseColor,
        fontFamily: fontFamily,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: baseColor,
        fontFamily: fontFamily,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: baseColor,
        fontFamily: fontFamily,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: baseColor,
        fontFamily: fontFamily,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: baseColor,
        height: 1.8,
        fontFamily: fontFamily,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: baseColor,
        height: 1.6,
        fontFamily: fontFamily,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: secondaryColor,
        height: 1.5,
        fontFamily: fontFamily,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: baseColor,
        fontFamily: fontFamily,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: baseColor,
        fontFamily: fontFamily,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
        fontFamily: _getFontFamily(fontFamily),
      ),
    );
  }

  String _getFontFamily(String fontFamily) {
    // Use system fonts as fallback for better cross-platform compatibility
    switch (fontFamily) {
      case 'IranSans':
      case 'Vazir':
        return fontFamily;
      case 'Tahoma':
        return 'Tahoma';
      case 'Arial':
        return 'Arial';
      default:
        return 'Tahoma'; // Default fallback
    }
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    const MainScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    // Notifications will be initialized through the settings provider
    await Future.delayed(Duration.zero);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: AppAnimations.shortDuration,
            curve: AppAnimations.defaultCurve,
          );
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.scaffoldBackgroundColor,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: AppLocalizations.of(context)!.appTitle,
          ),
          BottomNavigationBarItem(
            icon: Consumer(
              builder: (context, ref, child) {
                final favoritesState = ref.watch(favoritesProvider);
                return Stack(
                  children: [
                    Icon(
                      _currentIndex == 1 ? Icons.favorite : Icons.favorite_border,
                    ),
                    if (favoritesState.favoritesCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppColors.favoriteColor,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${favoritesState.favoritesCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: AppLocalizations.of(context)!.favorites,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _currentIndex == 2 ? Icons.settings : Icons.settings_outlined,
            ),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
    );
  }
}

class PlatformAwareHome extends StatelessWidget {
  const PlatformAwareHome({super.key});

  @override
  Widget build(BuildContext context) {
    final platformService = PlatformService.instance;
    final responsiveService = ResponsiveService.instance;

    // Use desktop layout for desktop platforms or large screens
    if (platformService.isDesktop || responsiveService.isDesktop(context)) {
      return const DesktopMainScreen();
    }

    // Use mobile layout for mobile platforms or small screens
    return const MainNavigator();
  }
}