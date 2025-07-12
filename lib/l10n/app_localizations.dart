import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Chakame'**
  String get appTitle;

  /// Favorites menu item
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Favorites title with count
  ///
  /// In en, this message translates to:
  /// **'Favorites ({count})'**
  String favoritesWithCount(int count);

  /// Search placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search in favorites'**
  String get searchInFavorites;

  /// Filter option for all poets
  ///
  /// In en, this message translates to:
  /// **'All Poets'**
  String get allPoets;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'No Favorites'**
  String get noFavorites;

  /// Description for empty favorites state
  ///
  /// In en, this message translates to:
  /// **'Add your favorite poems by clicking the heart button'**
  String get noFavoritesDescription;

  /// Back to home button
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No search results message
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get noSearchResults;

  /// No search results description
  ///
  /// In en, this message translates to:
  /// **'Change your search term or poet filter'**
  String get changeSearchOrFilter;

  /// Sort button
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// Sort by newest
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// Sort by oldest
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get oldest;

  /// Sort by poet name
  ///
  /// In en, this message translates to:
  /// **'Poet Name'**
  String get poetName;

  /// Sort by poem title
  ///
  /// In en, this message translates to:
  /// **'Poem Title'**
  String get poemTitle;

  /// Delete all favorites
  ///
  /// In en, this message translates to:
  /// **'Delete All'**
  String get deleteAll;

  /// Export favorites
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Delete all favorites dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete All Favorites'**
  String get deleteAllFavorites;

  /// Delete all favorites confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all favorites? This action cannot be undone.'**
  String get deleteAllConfirmation;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Favorites exported message
  ///
  /// In en, this message translates to:
  /// **'Favorites exported'**
  String get favoritesExported;

  /// Remove from favorites dialog title
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavorites;

  /// Remove from favorites confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove \"{title}\" from favorites?'**
  String removeFromFavoritesConfirmation(String title);

  /// Poem text section title
  ///
  /// In en, this message translates to:
  /// **'Poem Text'**
  String get poemText;

  /// Operations section title
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get operations;

  /// Copy text button
  ///
  /// In en, this message translates to:
  /// **'Copy Text'**
  String get copyText;

  /// Share button
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Add to favorites button
  ///
  /// In en, this message translates to:
  /// **'Add to Favorites'**
  String get addToFavorites;

  /// Remove from favorites button
  ///
  /// In en, this message translates to:
  /// **'Remove from Favorites'**
  String get removeFromFavoritesShort;

  /// Poem information section title
  ///
  /// In en, this message translates to:
  /// **'Poem Information'**
  String get poemInfo;

  /// Title label
  ///
  /// In en, this message translates to:
  /// **'Title:'**
  String get title;

  /// Poet label
  ///
  /// In en, this message translates to:
  /// **'Poet:'**
  String get poet;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category:'**
  String get category;

  /// Verse count label
  ///
  /// In en, this message translates to:
  /// **'Verse Count:'**
  String get verseCount;

  /// Verses count text
  ///
  /// In en, this message translates to:
  /// **'{count} verses'**
  String versesText(int count);

  /// View in Ganjoor button
  ///
  /// In en, this message translates to:
  /// **'View in Ganjoor'**
  String get viewInGanjoor;

  /// Poem copied message
  ///
  /// In en, this message translates to:
  /// **'Poem copied to clipboard'**
  String get poemCopied;

  /// Poem added to favorites message
  ///
  /// In en, this message translates to:
  /// **'Poem added to favorites'**
  String get poemAddedToFavorites;

  /// Poem removed from favorites message
  ///
  /// In en, this message translates to:
  /// **'Poem removed from favorites'**
  String get poemRemovedFromFavorites;

  /// Ganjoor data source
  ///
  /// In en, this message translates to:
  /// **'Ganjoor'**
  String get ganjoorSource;

  /// Link text with URL
  ///
  /// In en, this message translates to:
  /// **'Link: {url}'**
  String link(String url);

  /// Copy button
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// New poem button text
  ///
  /// In en, this message translates to:
  /// **'New Poem'**
  String get newPoem;

  /// Get random poem button description
  ///
  /// In en, this message translates to:
  /// **'Get Random Poem'**
  String get getRandomPoem;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Retry button
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Error loading poem message
  ///
  /// In en, this message translates to:
  /// **'Error loading poem'**
  String get poemLoadError;

  /// Continue poem text
  ///
  /// In en, this message translates to:
  /// **'... continue poem'**
  String get continuePoem;

  /// Short copy button text
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyShort;

  /// Today's poet section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Poet'**
  String get todaysPoet;

  /// Explore poems section title
  ///
  /// In en, this message translates to:
  /// **'Explore Poems'**
  String get explorePoems;

  /// Search poems title
  ///
  /// In en, this message translates to:
  /// **'Search Poems'**
  String get searchPoems;

  /// Poets menu item
  ///
  /// In en, this message translates to:
  /// **'Poets'**
  String get poets;

  /// Settings menu item
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Recent poems section title
  ///
  /// In en, this message translates to:
  /// **'Recent Poems'**
  String get recentPoems;

  /// Home menu item
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Welcome title
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Welcome message text
  ///
  /// In en, this message translates to:
  /// **'Welcome to the beautiful world of Persian poetry'**
  String get welcomeMessage;

  /// Notifications settings section
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// About settings section
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Dark mode setting
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Font selection setting
  ///
  /// In en, this message translates to:
  /// **'Font Selection'**
  String get fontSelection;

  /// Notification time setting
  ///
  /// In en, this message translates to:
  /// **'Notification Time'**
  String get notificationTime;

  /// Test notification button
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotification;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No favorites added message
  ///
  /// In en, this message translates to:
  /// **'No poems have been added to favorites yet'**
  String get noFavoritesAdded;

  /// Search poems dialog title
  ///
  /// In en, this message translates to:
  /// **'Search Poems'**
  String get searchPoemsTitle;

  /// Random poem from poet button
  ///
  /// In en, this message translates to:
  /// **'Random poem from this poet'**
  String get randomPoemFromPoet;

  /// Getting poem from poet message
  ///
  /// In en, this message translates to:
  /// **'Getting poem from {poetName}...'**
  String gettingPoemFromPoet(String poetName);

  /// Daily notifications setting
  ///
  /// In en, this message translates to:
  /// **'Daily Notifications'**
  String get dailyNotifications;

  /// Send test notification subtitle
  ///
  /// In en, this message translates to:
  /// **'Send test notification'**
  String get sendTestNotification;

  /// Favorites section title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// Poems count text
  ///
  /// In en, this message translates to:
  /// **'{count} poems'**
  String poemsCount(int count);

  /// Clear cache setting
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// Clear cache subtitle
  ///
  /// In en, this message translates to:
  /// **'Delete cached poems'**
  String get clearCacheSubtitle;

  /// Backup setting
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// Backup subtitle
  ///
  /// In en, this message translates to:
  /// **'Export settings and favorites'**
  String get backupSubtitle;

  /// About app title
  ///
  /// In en, this message translates to:
  /// **'About {appName}'**
  String aboutApp(String appName);

  /// App version text
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// Version text
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version(String version);

  /// Help section
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Help subtitle
  ///
  /// In en, this message translates to:
  /// **'How to use the app'**
  String get helpSubtitle;

  /// Data source section
  ///
  /// In en, this message translates to:
  /// **'Data Source'**
  String get dataSource;

  /// Test notification sent message
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  String get testNotificationSent;

  /// Storage statistics title
  ///
  /// In en, this message translates to:
  /// **'Storage Statistics'**
  String get storageStats;

  /// Cached poems count
  ///
  /// In en, this message translates to:
  /// **'Cached poems: {count}'**
  String cachedPoems(int count);

  /// Favorites count
  ///
  /// In en, this message translates to:
  /// **'Favorites: {count}'**
  String favoritesCount(int count);

  /// Cached poets count
  ///
  /// In en, this message translates to:
  /// **'Cached poets: {count}'**
  String cachedPoets(int count);

  /// Settings count
  ///
  /// In en, this message translates to:
  /// **'Settings: {count}'**
  String settingsCount(int count);

  /// Clear cache dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCacheTitle;

  /// Clear cache confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the cache?'**
  String get clearCacheConfirmation;

  /// Cache cleared message
  ///
  /// In en, this message translates to:
  /// **'Cache cleared'**
  String get cacheCleared;

  /// Clear button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Data exported message
  ///
  /// In en, this message translates to:
  /// **'Data exported'**
  String get dataExported;

  /// App description
  ///
  /// In en, this message translates to:
  /// **'An app for reading Persian poetry with poems from Ganjoor'**
  String get appDescription;

  /// Features title
  ///
  /// In en, this message translates to:
  /// **'Features:'**
  String get features;

  /// Random poem feature
  ///
  /// In en, this message translates to:
  /// **'• Get random poems'**
  String get randomPoemFeature;

  /// Favorites feature
  ///
  /// In en, this message translates to:
  /// **'• Favorites'**
  String get favoritesFeature;

  /// Notifications feature
  ///
  /// In en, this message translates to:
  /// **'• Daily notifications'**
  String get notificationsFeature;

  /// Search and filter feature
  ///
  /// In en, this message translates to:
  /// **'• Search and filter'**
  String get searchFeature;

  /// Help dialog title
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// How to use app text
  ///
  /// In en, this message translates to:
  /// **'How to use {appName}:'**
  String howToUse(String appName);

  /// Help step 1
  ///
  /// In en, this message translates to:
  /// **'1. Click the big button to get a random poem'**
  String get helpStep1;

  /// Help step 2
  ///
  /// In en, this message translates to:
  /// **'2. Click the heart to add the poem to favorites'**
  String get helpStep2;

  /// Help step 3
  ///
  /// In en, this message translates to:
  /// **'3. In the favorites page, you can search for poems'**
  String get helpStep3;

  /// Help step 4
  ///
  /// In en, this message translates to:
  /// **'4. Enable daily notifications from settings'**
  String get helpStep4;

  /// Help step 5
  ///
  /// In en, this message translates to:
  /// **'5. Share poems with your friends'**
  String get helpStep5;

  /// Data source dialog title
  ///
  /// In en, this message translates to:
  /// **'Data Source'**
  String get dataSourceTitle;

  /// Ganjoor API description
  ///
  /// In en, this message translates to:
  /// **'This app uses the Ganjoor API.'**
  String get ganjoorDescription;

  /// Ganjoor information
  ///
  /// In en, this message translates to:
  /// **'Ganjoor is the largest Persian poetry library founded by Reza Amirhesni.'**
  String get ganjoorInfo;

  /// Ganjoor website
  ///
  /// In en, this message translates to:
  /// **'Website: ganjoor.net'**
  String get ganjoorWebsite;

  /// Ganjoor API
  ///
  /// In en, this message translates to:
  /// **'API: api.ganjoor.net'**
  String get ganjoorApi;

  /// Recent favorites title
  ///
  /// In en, this message translates to:
  /// **'Recent Favorites'**
  String get recentFavorites;

  /// Daily poem notification title
  ///
  /// In en, this message translates to:
  /// **'Chakame - Daily Poem'**
  String get dailyPoemNotificationTitle;

  /// Daily poem notification body
  ///
  /// In en, this message translates to:
  /// **'A beautiful poem is ready for you'**
  String get dailyPoemNotificationBody;

  /// Test notification title
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotificationTitle;

  /// Test notification body
  ///
  /// In en, this message translates to:
  /// **'This is a test message'**
  String get testNotificationBody;

  /// Enabled status
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// Disabled status
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// View all button text
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Search field hint text
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
