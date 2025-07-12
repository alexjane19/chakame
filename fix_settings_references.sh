#!/bin/bash

# Fix remaining references in settings_screen.dart
file="lib/screens/settings_screen.dart"

# Fix the build method call
sed -i 's/_buildSettingsContent(context, theme, settingsProvider)/_buildSettingsContent(context, theme, settingsState)/g' "$file"

# Fix settingsProvider usage in methods to use ref.read or ref.watch
sed -i 's/settingsProvider\.darkMode/settingsState.darkMode/g' "$file"
sed -i 's/settingsProvider\.selectedFont/settingsState.selectedFont/g' "$file"
sed -i 's/settingsProvider\.notificationsEnabled/settingsState.notificationsEnabled/g' "$file"
sed -i 's/settingsProvider\.getNotificationTimeOfDay/ref.read(settingsProvider.notifier).getNotificationTimeOfDay/g' "$file"
sed -i 's/settingsProvider\.testNotification/ref.read(settingsProvider.notifier).testNotification/g' "$file"
sed -i 's/settingsProvider\.setNotificationTime/ref.read(settingsProvider.notifier).setNotificationTime/g' "$file"
sed -i 's/settingsProvider\.setSelectedFont/ref.read(settingsProvider.notifier).setSelectedFont/g' "$file"
sed -i 's/settingsProvider\.toggleDarkMode/ref.read(settingsProvider.notifier).toggleDarkMode/g' "$file"
sed -i 's/settingsProvider\.toggleNotifications/ref.read(settingsProvider.notifier).toggleNotifications/g' "$file"

echo "Fixed settings_screen.dart references"