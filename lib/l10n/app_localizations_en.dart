// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Chakame';

  @override
  String get favorites => 'Favorites';

  @override
  String favoritesWithCount(int count) {
    return 'Favorites ($count)';
  }

  @override
  String get searchInFavorites => 'Search in favorites';

  @override
  String get allPoets => 'All Poets';

  @override
  String get noFavorites => 'No Favorites';

  @override
  String get noFavoritesDescription =>
      'Add your favorite poems by clicking the heart button';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get noSearchResults => 'No Results Found';

  @override
  String get changeSearchOrFilter => 'Change your search term or poet filter';

  @override
  String get sort => 'Sort';

  @override
  String get newest => 'Newest';

  @override
  String get oldest => 'Oldest';

  @override
  String get poetName => 'Poet Name';

  @override
  String get poemTitle => 'Poem Title';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get export => 'Export';

  @override
  String get deleteAllFavorites => 'Delete All Favorites';

  @override
  String get deleteAllConfirmation =>
      'Are you sure you want to delete all favorites? This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get favoritesExported => 'Favorites exported';

  @override
  String get removeFromFavorites => 'Remove from Favorites';

  @override
  String removeFromFavoritesConfirmation(String title) {
    return 'Are you sure you want to remove \"$title\" from favorites?';
  }

  @override
  String get poemText => 'Poem Text';

  @override
  String get operations => 'Operations';

  @override
  String get copyText => 'Copy Text';

  @override
  String get share => 'Share';

  @override
  String get addToFavorites => 'Add to Favorites';

  @override
  String get removeFromFavoritesShort => 'Remove from Favorites';

  @override
  String get poemInfo => 'Poem Information';

  @override
  String get title => 'Title:';

  @override
  String get poet => 'Poet:';

  @override
  String get category => 'Category:';

  @override
  String get verseCount => 'Verse Count:';

  @override
  String versesText(int count) {
    return '$count verses';
  }

  @override
  String get viewInGanjoor => 'View in Ganjoor';

  @override
  String get poemCopied => 'Poem copied to clipboard';

  @override
  String get poemAddedToFavorites => 'Poem added to favorites';

  @override
  String get poemRemovedFromFavorites => 'Poem removed from favorites';

  @override
  String get ganjoorSource => 'Ganjoor';

  @override
  String link(String url) {
    return 'Link: $url';
  }

  @override
  String get copy => 'Copy';

  @override
  String get newPoem => 'New Poem';

  @override
  String get getRandomPoem => 'Get Random Poem';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get poemLoadError => 'Error loading poem';

  @override
  String get continuePoem => '... continue poem';

  @override
  String get copyShort => 'Copy';

  @override
  String get todaysPoet => 'Today\'s Poet';

  @override
  String get explorePoems => 'Explore Poems';

  @override
  String get searchPoems => 'Search Poems';

  @override
  String get poets => 'Poets';

  @override
  String get settings => 'Settings';

  @override
  String get recentPoems => 'Recent Poems';

  @override
  String get home => 'Home';

  @override
  String get welcome => 'Welcome';

  @override
  String get welcomeMessage =>
      'Welcome to the beautiful world of Persian poetry';

  @override
  String get notifications => 'Notifications';

  @override
  String get about => 'About';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get fontSelection => 'Font Selection';

  @override
  String get notificationTime => 'Notification Time';

  @override
  String get testNotification => 'Test Notification';

  @override
  String get ok => 'OK';

  @override
  String get all => 'All';

  @override
  String get noFavoritesAdded => 'No poems have been added to favorites yet';

  @override
  String get searchPoemsTitle => 'Search Poems';

  @override
  String get randomPoemFromPoet => 'Random poem from this poet';

  @override
  String gettingPoemFromPoet(String poetName) {
    return 'Getting poem from $poetName...';
  }

  @override
  String get dailyNotifications => 'Daily Notifications';

  @override
  String get sendTestNotification => 'Send test notification';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String poemsCount(int count) {
    return '$count poems';
  }

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get clearCacheSubtitle => 'Delete cached poems';

  @override
  String get backup => 'Backup';

  @override
  String get backupSubtitle => 'Export settings and favorites';

  @override
  String aboutApp(String appName) {
    return 'About $appName';
  }

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String version(String version) {
    return 'Version $version';
  }

  @override
  String get help => 'Help';

  @override
  String get helpSubtitle => 'How to use the app';

  @override
  String get dataSource => 'Data Source';

  @override
  String get testNotificationSent => 'Test notification sent';

  @override
  String get storageStats => 'Storage Statistics';

  @override
  String cachedPoems(int count) {
    return 'Cached poems: $count';
  }

  @override
  String favoritesCount(int count) {
    return 'Favorites: $count';
  }

  @override
  String cachedPoets(int count) {
    return 'Cached poets: $count';
  }

  @override
  String settingsCount(int count) {
    return 'Settings: $count';
  }

  @override
  String get clearCacheTitle => 'Clear Cache';

  @override
  String get clearCacheConfirmation =>
      'Are you sure you want to clear the cache?';

  @override
  String get cacheCleared => 'Cache cleared';

  @override
  String get clear => 'Clear';

  @override
  String get dataExported => 'Data exported';

  @override
  String get appDescription =>
      'An app for reading Persian poetry with poems from Ganjoor';

  @override
  String get features => 'Features:';

  @override
  String get randomPoemFeature => '• Get random poems';

  @override
  String get favoritesFeature => '• Favorites';

  @override
  String get notificationsFeature => '• Daily notifications';

  @override
  String get searchFeature => '• Search and filter';

  @override
  String get helpTitle => 'Help';

  @override
  String howToUse(String appName) {
    return 'How to use $appName:';
  }

  @override
  String get helpStep1 => '1. Click the big button to get a random poem';

  @override
  String get helpStep2 => '2. Click the heart to add the poem to favorites';

  @override
  String get helpStep3 => '3. In the favorites page, you can search for poems';

  @override
  String get helpStep4 => '4. Enable daily notifications from settings';

  @override
  String get helpStep5 => '5. Share poems with your friends';

  @override
  String get dataSourceTitle => 'Data Source';

  @override
  String get ganjoorDescription => 'This app uses the Ganjoor API.';

  @override
  String get ganjoorInfo =>
      'Ganjoor is the largest Persian poetry library founded by Reza Amirhesni.';

  @override
  String get ganjoorWebsite => 'Website: ganjoor.net';

  @override
  String get ganjoorApi => 'API: api.ganjoor.net';

  @override
  String get recentFavorites => 'Recent Favorites';

  @override
  String get dailyPoemNotificationTitle => 'Chakame - Daily Poem';

  @override
  String get dailyPoemNotificationBody => 'A beautiful poem is ready for you';

  @override
  String get testNotificationTitle => 'Test Notification';

  @override
  String get testNotificationBody => 'This is a test message';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get viewAll => 'View All';

  @override
  String get searchHint => 'Search...';
}
