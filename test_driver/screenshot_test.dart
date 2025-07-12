import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' hide find;
import 'package:flutter_driver/flutter_driver.dart';

void main() {
  group('Chakame App Screenshots', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      
      // Create screenshots directory
      final screenshotsDir = Directory('screenshots');
      if (!screenshotsDir.existsSync()) {
        screenshotsDir.createSync();
      }
    });

    tearDownAll(() async {
      await driver.close();
    });

    test('Take screenshots of all app pages', () async {
      print('Starting screenshot capture...');

      // 1. Home/Main Screen
      await driver.waitFor(find.text('Chakame'));
      await takeScreenshot(driver, 'screenshots/01_home_screen.png');
      await Future.delayed(Duration(seconds: 2));

      // 2. Random Poem Button (if exists)
      try {
        final randomPoemButton = find.text('شعر جدید');
        await driver.waitFor(randomPoemButton, timeout: Duration(seconds: 5));
        await driver.tap(randomPoemButton);
        await Future.delayed(Duration(seconds: 3));
        await takeScreenshot(driver, 'screenshots/02_random_poem.png');
        
        // Go back
        await driver.tap(find.byType('BackButton'));
        await Future.delayed(Duration(seconds: 1));
      } catch (e) {
        print('Random poem button not found or not accessible');
      }

      // 3. Navigate to Favorites
      try {
        final favoritesTab = find.text('علاقه‌مندی‌ها');
        await driver.waitFor(favoritesTab, timeout: Duration(seconds: 5));
        await driver.tap(favoritesTab);
        await Future.delayed(Duration(seconds: 2));
        await takeScreenshot(driver, 'screenshots/03_favorites_screen.png');
      } catch (e) {
        print('Favorites tab not found, trying alternative');
        try {
          await driver.tap(find.byIcon(Icons.favorite));
          await Future.delayed(Duration(seconds: 2));
          await takeScreenshot(driver, 'screenshots/03_favorites_screen.png');
        } catch (e2) {
          print('Could not navigate to favorites');
        }
      }

      // 4. Navigate to Settings
      try {
        final settingsTab = find.text('تنظیمات');
        await driver.waitFor(settingsTab, timeout: Duration(seconds: 5));
        await driver.tap(settingsTab);
        await Future.delayed(Duration(seconds: 2));
        await takeScreenshot(driver, 'screenshots/04_settings_screen.png');
      } catch (e) {
        print('Settings tab not found, trying alternative');
        try {
          await driver.tap(find.byIcon(Icons.settings));
          await Future.delayed(Duration(seconds: 2));
          await takeScreenshot(driver, 'screenshots/04_settings_screen.png');
        } catch (e2) {
          print('Could not navigate to settings');
        }
      }

      // 5. Test dark mode toggle (if accessible)
      try {
        final darkModeSwitch = find.text('حالت تاریک');
        await driver.waitFor(darkModeSwitch, timeout: Duration(seconds: 3));
        await driver.tap(darkModeSwitch);
        await Future.delayed(Duration(seconds: 2));
        await takeScreenshot(driver, 'screenshots/05_dark_mode.png');
      } catch (e) {
        print('Dark mode toggle not found or accessible');
      }

      // 6. Go back to home
      try {
        final homeTab = find.text('خانه');
        await driver.waitFor(homeTab, timeout: Duration(seconds: 5));
        await driver.tap(homeTab);
        await Future.delayed(Duration(seconds: 2));
        await takeScreenshot(driver, 'screenshots/06_home_final.png');
      } catch (e) {
        print('Could not return to home');
      }

      print('Screenshot capture completed. Check the screenshots/ directory.');
    });
  });
}

Future<void> takeScreenshot(FlutterDriver driver, String path) async {
  try {
    final pixels = await driver.screenshot();
    final file = File(path);
    await file.writeAsBytes(pixels);
    print('Screenshot saved: $path');
  } catch (e) {
    print('Failed to take screenshot $path: $e');
  }
}