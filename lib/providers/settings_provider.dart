import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

// Settings state class
class SettingsState {
  final bool darkMode;
  final bool notificationsEnabled;
  final String notificationTime;
  final String selectedFont;
  final String selectedLanguage;
  final bool isLoading;

  const SettingsState({
    required this.darkMode,
    required this.notificationsEnabled,
    required this.notificationTime,
    required this.selectedFont,
    required this.selectedLanguage,
    required this.isLoading,
  });

  SettingsState copyWith({
    bool? darkMode,
    bool? notificationsEnabled,
    String? notificationTime,
    String? selectedFont,
    String? selectedLanguage,
    bool? isLoading,
  }) {
    return SettingsState(
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationTime: notificationTime ?? this.notificationTime,
      selectedFont: selectedFont ?? this.selectedFont,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Settings StateNotifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  final StorageService _storageService = StorageService.instance;
  final NotificationService _notificationService = NotificationService.instance;

  SettingsNotifier() : super(const SettingsState(
    darkMode: false,
    notificationsEnabled: true,
    notificationTime: '09:00',
    selectedFont: 'Tahoma',
    selectedLanguage: 'fa',
    isLoading: false,
  )) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    state = state.copyWith(isLoading: true);

    try {
      final darkMode = _storageService.getDarkMode();
      final notificationsEnabled = _storageService.getNotificationsEnabled();
      final notificationTime = _storageService.getNotificationTime();
      final selectedFont = _storageService.getSelectedFont();
      final selectedLanguage = _storageService.getSelectedLanguage();

      state = state.copyWith(
        darkMode: darkMode,
        notificationsEnabled: notificationsEnabled,
        notificationTime: notificationTime,
        selectedFont: selectedFont,
        selectedLanguage: selectedLanguage,
        isLoading: false,
      );
    } catch (e) {
      debugPrint('Error loading settings: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> toggleDarkMode() async {
    final newDarkMode = !state.darkMode;
    state = state.copyWith(darkMode: newDarkMode);
    await _storageService.setDarkMode(newDarkMode);
  }

  Future<void> setDarkMode(bool enabled) async {
    if (state.darkMode == enabled) return;
    
    state = state.copyWith(darkMode: enabled);
    await _storageService.setDarkMode(enabled);
  }

  Future<void> toggleNotifications() async {
    final newEnabled = !state.notificationsEnabled;
    
    if (newEnabled) {
      final hasPermission = await _notificationService.requestPermissions();
      if (hasPermission) {
        state = state.copyWith(notificationsEnabled: true);
        await _storageService.setNotificationsEnabled(true);
        await _updateNotificationSchedule();
      } else {
        state = state.copyWith(notificationsEnabled: false);
        await _storageService.setNotificationsEnabled(false);
      }
    } else {
      state = state.copyWith(notificationsEnabled: false);
      await _storageService.setNotificationsEnabled(false);
      await _notificationService.cancelDailyNotification();
    }
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    if (state.notificationsEnabled == enabled) return;
    
    if (enabled) {
      final hasPermission = await _notificationService.requestPermissions();
      if (hasPermission) {
        state = state.copyWith(notificationsEnabled: true);
        await _storageService.setNotificationsEnabled(true);
        await _updateNotificationSchedule();
      } else {
        state = state.copyWith(notificationsEnabled: false);
        await _storageService.setNotificationsEnabled(false);
      }
    } else {
      state = state.copyWith(notificationsEnabled: false);
      await _storageService.setNotificationsEnabled(false);
      await _notificationService.cancelDailyNotification();
    }
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    
    if (state.notificationTime == timeString) return;
    
    state = state.copyWith(notificationTime: timeString);
    await _storageService.setNotificationTime(timeString);
    
    if (state.notificationsEnabled) {
      await _updateNotificationSchedule();
    }
  }

  Future<void> setSelectedFont(String font) async {
    if (state.selectedFont == font) return;
    
    state = state.copyWith(selectedFont: font);
    await _storageService.setSelectedFont(font);
  }

  Future<void> setSelectedLanguage(String language) async {
    if (state.selectedLanguage == language) return;
    
    state = state.copyWith(selectedLanguage: language);
    await _storageService.setSelectedLanguage(language);
  }

  Future<void> _updateNotificationSchedule({String? title, String? body}) async {
    if (!state.notificationsEnabled) return;
    
    final timeParts = state.notificationTime.split(':');
    final time = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
    
    await _notificationService.scheduleDailyNotification(time, title: title, body: body);
  }

  TimeOfDay getNotificationTimeOfDay() {
    final timeParts = state.notificationTime.split(':');
    return TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
  }

  String getNotificationTimeFormatted() {
    final timeOfDay = getNotificationTimeOfDay();
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> testNotification() async {
    await _notificationService.testNotification();
  }

  Future<bool> requestNotificationPermissions() async {
    return await _notificationService.requestPermissions();
  }

  Future<bool> hasScheduledNotifications() async {
    return await _notificationService.hasScheduledNotifications();
  }

  Future<void> resetSettings() async {
    const newState = SettingsState(
      darkMode: false,
      notificationsEnabled: true,
      notificationTime: '09:00',
      selectedFont: 'Tahoma',
      selectedLanguage: 'fa',
      isLoading: false,
    );

    state = newState;

    await _storageService.setDarkMode(newState.darkMode);
    await _storageService.setNotificationsEnabled(newState.notificationsEnabled);
    await _storageService.setNotificationTime(newState.notificationTime);
    await _storageService.setSelectedFont(newState.selectedFont);
    await _storageService.setSelectedLanguage(newState.selectedLanguage);

    if (newState.notificationsEnabled) {
      await _updateNotificationSchedule();
    }
  }

  Map<String, dynamic> getSettingsSummary() {
    return {
      'darkMode': state.darkMode,
      'notificationsEnabled': state.notificationsEnabled,
      'notificationTime': state.notificationTime,
      'selectedFont': state.selectedFont,
      'selectedLanguage': state.selectedLanguage,
    };
  }

  Future<void> importSettings(Map<String, dynamic> settings) async {
    try {
      if (settings.containsKey('darkMode')) {
        await setDarkMode(settings['darkMode'] as bool);
      }
      
      if (settings.containsKey('notificationsEnabled')) {
        await setNotificationsEnabled(settings['notificationsEnabled'] as bool);
      }
      
      if (settings.containsKey('notificationTime')) {
        final timeString = settings['notificationTime'] as String;
        final timeParts = timeString.split(':');
        final time = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
        await setNotificationTime(time);
      }
      
      if (settings.containsKey('selectedFont')) {
        await setSelectedFont(settings['selectedFont'] as String);
      }
      
      if (settings.containsKey('selectedLanguage')) {
        await setSelectedLanguage(settings['selectedLanguage'] as String);
      }
    } catch (e) {
      debugPrint('Error importing settings: $e');
    }
  }

  ThemeData getThemeData() {
    return state.darkMode ? _getDarkTheme() : _getLightTheme();
  }

  ThemeData _getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: Colors.green,
      fontFamily: state.selectedFont,
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontFamily: state.selectedFont),
        headlineMedium: TextStyle(fontFamily: state.selectedFont),
        headlineSmall: TextStyle(fontFamily: state.selectedFont),
        bodyLarge: TextStyle(fontFamily: state.selectedFont),
        bodyMedium: TextStyle(fontFamily: state.selectedFont),
        bodySmall: TextStyle(fontFamily: state.selectedFont),
      ),
    );
  }

  ThemeData _getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: Colors.green,
      fontFamily: state.selectedFont,
      textTheme: TextTheme(
        headlineLarge: TextStyle(fontFamily: state.selectedFont),
        headlineMedium: TextStyle(fontFamily: state.selectedFont),
        headlineSmall: TextStyle(fontFamily: state.selectedFont),
        bodyLarge: TextStyle(fontFamily: state.selectedFont),
        bodyMedium: TextStyle(fontFamily: state.selectedFont),
        bodySmall: TextStyle(fontFamily: state.selectedFont),
      ),
    );
  }
}

// Settings provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});