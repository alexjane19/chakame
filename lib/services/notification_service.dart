import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/poem_model.dart';
import 'api_service.dart';
import 'storage_service.dart';
import 'platform_service.dart';

class NotificationService {
  static const int dailyNotificationId = 1001;
  static const String channelId = 'daily_poem_channel';
  static const String channelName = 'Daily Poem Notifications';
  static const String channelDescription = 'Daily notifications with Persian poetry';

  static NotificationService? _instance;
  static NotificationService get instance => _instance ??= NotificationService._internal();

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final platformService = PlatformService.instance;
    
    // Only initialize notifications on supported platforms
    if (!platformService.supportsNotifications) {
      return;
    }

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Tehran'));

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const linuxSettings = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      linux: linuxSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _createNotificationChannel();
  }

  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: Importance.high,
      showBadge: true,
      enableVibration: true,
      playSound: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      final payload = json.decode(notificationResponse.payload!);
      final poemId = payload['poem_id'] as int;
      
      // Navigate to poem detail screen
      // This will be handled by the main app navigation
    }
  }

  Future<bool> requestPermissions() async {
    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      return granted ?? false;
    }

    final iosPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    
    if (iosPlugin != null) {
      final granted = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return false;
  }

  Future<void> scheduleDailyNotification(TimeOfDay time, {String? title, String? body}) async {
    final storage = StorageService.instance;
    
    if (!storage.getNotificationsEnabled()) {
      return;
    }

    // Cancel existing notifications
    await cancelAllNotifications();

    // Schedule new notification
    final scheduledDate = _nextInstanceOfTime(time);
    
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      dailyNotificationId,
      title ?? 'Daily Poem',
      body ?? 'A beautiful poem is ready for you',
      scheduledDate,
      _getNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // Save notification time
    await storage.setNotificationTime('${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    return scheduledDate.isBefore(now) 
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  Future<void> showDailyPoemNotification({String? title, String? body, String? poetNameFormat}) async {
    try {
      final poem = await _getRandomPoemForNotification();
      
      if (poem != null) {
        final payload = json.encode({
          'poem_id': poem.id,
          'type': 'daily_poem',
        });

        await _flutterLocalNotificationsPlugin.show(
          dailyNotificationId,
          title ?? 'Daily Poem',
          '${poem.poetName}: ${poem.firstLine}',
          _getNotificationDetails(),
          payload: payload,
        );
      }
    } catch (e) {
      // Fallback notification
      await _flutterLocalNotificationsPlugin.show(
        dailyNotificationId,
        title ?? 'Daily Poem',
        body ?? 'A beautiful poem is ready for you',
        _getNotificationDetails(),
      );
    }
  }

  Future<Poem?> _getRandomPoemForNotification() async {
    final storage = StorageService.instance;
    final apiService = ApiService();

    try {
      // Try to get random poem from API
      final poem = await apiService.getRandomPoem();
      await storage.cachePoem(poem);
      return poem;
    } catch (e) {
      // Fallback to cached poems
      final cachedPoems = storage.getCachedPoems();
      if (cachedPoems.isNotEmpty) {
        final random = Random();
        return cachedPoems[random.nextInt(cachedPoems.length)];
      }
      
      // Fallback to favorites
      final favorites = storage.getFavorites();
      if (favorites.isNotEmpty) {
        final random = Random();
        final favorite = favorites[random.nextInt(favorites.length)];
        return Poem(
          id: favorite.poemId,
          title: favorite.poemTitle,
          plainText: favorite.poemText,
          htmlText: favorite.poemText,
          poetName: favorite.poetName,
          poetId: favorite.poetId,
          categoryName: favorite.categoryName,
          categoryId: 0,
          poemUrl: favorite.poemUrl,
          verses: favorite.poemText.split('\n').where((line) => line.trim().isNotEmpty).toList(),
        );
      }
      
      return null;
    }
  }

  NotificationDetails _getNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/ic_launcher',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation(''),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
      ),
    );
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelDailyNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(dailyNotificationId);
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  Future<bool> hasScheduledNotifications() async {
    final pendingNotifications = await getPendingNotifications();
    return pendingNotifications.isNotEmpty;
  }

  Future<void> updateDailyNotificationIfNeeded() async {
    final storage = StorageService.instance;
    
    if (storage.getNotificationsEnabled()) {
      final timeString = storage.getNotificationTime();
      final timeParts = timeString.split(':');
      final time = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      );
      
      await scheduleDailyNotification(time);
    } else {
      await cancelDailyNotification();
    }
  }

  Future<void> testNotification({String? title, String? body}) async {
    await _flutterLocalNotificationsPlugin.show(
      999,
      title ?? 'Test Notification',
      body ?? 'This is a test message',
      _getNotificationDetails(),
    );
  }
}