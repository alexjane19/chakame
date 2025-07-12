// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'چکامه';

  @override
  String get favorites => 'علاقه‌مندی‌ها';

  @override
  String favoritesWithCount(int count) {
    return 'علاقه‌مندی‌ها ($count)';
  }

  @override
  String get searchInFavorites => 'جستجو در علاقه‌مندی‌ها';

  @override
  String get allPoets => 'همه شاعران';

  @override
  String get noFavorites => 'هیچ علاقه‌مندی‌ای نیست';

  @override
  String get noFavoritesDescription =>
      'با کلیک بر روی دکمه قلب، اشعار مورد علاقه خود را اضافه کنید';

  @override
  String get backToHome => 'بازگشت به صفحه اصلی';

  @override
  String get noSearchResults => 'نتیجه‌ای یافت نشد';

  @override
  String get changeSearchOrFilter => 'عبارت جستجو یا فیلتر شاعر را تغییر دهید';

  @override
  String get sort => 'مرتب‌سازی';

  @override
  String get newest => 'جدیدترین';

  @override
  String get oldest => 'قدیمی‌ترین';

  @override
  String get poetName => 'نام شاعر';

  @override
  String get poemTitle => 'عنوان شعر';

  @override
  String get deleteAll => 'حذف همه';

  @override
  String get export => 'صادر کردن';

  @override
  String get deleteAllFavorites => 'حذف همه علاقه‌مندی‌ها';

  @override
  String get deleteAllConfirmation =>
      'آیا از حذف همه علاقه‌مندی‌ها مطمئن هستید؟ این عمل غیرقابل بازگشت است.';

  @override
  String get cancel => 'انصراف';

  @override
  String get delete => 'حذف';

  @override
  String get favoritesExported => 'علاقه‌مندی‌ها صادر شد';

  @override
  String get removeFromFavorites => 'حذف از علاقه‌مندی‌ها';

  @override
  String removeFromFavoritesConfirmation(String title) {
    return 'آیا از حذف \"$title\" مطمئن هستید؟';
  }

  @override
  String get poemText => 'متن شعر';

  @override
  String get operations => 'عملیات';

  @override
  String get copyText => 'کپی متن';

  @override
  String get share => 'اشتراک‌گذاری';

  @override
  String get addToFavorites => 'افزودن به علاقه‌مندی‌ها';

  @override
  String get removeFromFavoritesShort => 'حذف از علاقه‌مندی‌ها';

  @override
  String get poemInfo => 'اطلاعات شعر';

  @override
  String get title => 'عنوان:';

  @override
  String get poet => 'شاعر:';

  @override
  String get category => 'دسته‌بندی:';

  @override
  String get verseCount => 'تعداد ابیات:';

  @override
  String versesText(int count) {
    return '$count بیت';
  }

  @override
  String get viewInGanjoor => 'مشاهده در گنجور';

  @override
  String get poemCopied => 'شعر کپی شد';

  @override
  String get poemAddedToFavorites => 'شعر به علاقه‌مندی‌ها اضافه شد';

  @override
  String get poemRemovedFromFavorites => 'شعر از علاقه‌مندی‌ها حذف شد';

  @override
  String get ganjoorSource => 'گنجور';

  @override
  String link(String url) {
    return 'لینک: $url';
  }

  @override
  String get copy => 'کپی';

  @override
  String get newPoem => 'شعر جدید';

  @override
  String get getRandomPoem => 'دریافت شعر تصادفی';

  @override
  String get loading => 'در حال دریافت...';

  @override
  String get retry => 'تلاش مجدد';

  @override
  String get poemLoadError => 'خطا در دریافت شعر';

  @override
  String get continuePoem => '... ادامه شعر';

  @override
  String get copyShort => 'کپی';

  @override
  String get todaysPoet => 'شاعر امروز';

  @override
  String get explorePoems => 'کاوش اشعار';

  @override
  String get searchPoems => 'جستجوی اشعار';

  @override
  String get poets => 'شاعران';

  @override
  String get settings => 'تنظیمات';

  @override
  String get recentPoems => 'اشعار اخیر';

  @override
  String get home => 'خانه';

  @override
  String get welcome => 'خوش آمدید';

  @override
  String get welcomeMessage => 'به دنیای زیبای شعر فارسی خوش آمدید';

  @override
  String get notifications => 'اعلان‌ها';

  @override
  String get about => 'درباره';

  @override
  String get darkMode => 'حالت تاریک';

  @override
  String get fontSelection => 'انتخاب فونت';

  @override
  String get notificationTime => 'زمان اعلان';

  @override
  String get testNotification => 'تست اعلان';

  @override
  String get ok => 'تأیید';

  @override
  String get all => 'همه';

  @override
  String get noFavoritesAdded => 'هنوز شعری به علاقه‌مندی‌ها اضافه نشده';

  @override
  String get searchPoemsTitle => 'جستجوی اشعار';

  @override
  String get randomPoemFromPoet => 'شعر تصادفی از این شاعر';

  @override
  String gettingPoemFromPoet(String poetName) {
    return 'در حال دریافت شعر از $poetName...';
  }

  @override
  String get dailyNotifications => 'اعلان‌های روزانه';

  @override
  String get sendTestNotification => 'ارسال اعلان آزمایشی';

  @override
  String get favoritesTitle => 'علاقه‌مندی‌ها';

  @override
  String poemsCount(int count) {
    return '$count شعر';
  }

  @override
  String get clearCache => 'پاک کردن حافظه موقت';

  @override
  String get clearCacheSubtitle => 'حذف اشعار کش شده';

  @override
  String get backup => 'پشتیبان‌گیری';

  @override
  String get backupSubtitle => 'صادر کردن تنظیمات و علاقه‌مندی‌ها';

  @override
  String aboutApp(String appName) {
    return 'درباره $appName';
  }

  @override
  String appVersion(String version) {
    return 'نسخه $version';
  }

  @override
  String version(String version) {
    return 'نسخه $version';
  }

  @override
  String get help => 'راهنما';

  @override
  String get helpSubtitle => 'نحوه استفاده از برنامه';

  @override
  String get dataSource => 'منبع داده‌ها';

  @override
  String get testNotificationSent => 'اعلان آزمایشی ارسال شد';

  @override
  String get storageStats => 'آمار ذخیره‌سازی';

  @override
  String cachedPoems(int count) {
    return 'اشعار کش شده: $count';
  }

  @override
  String favoritesCount(int count) {
    return 'علاقه‌مندی‌ها: $count';
  }

  @override
  String cachedPoets(int count) {
    return 'شاعران کش شده: $count';
  }

  @override
  String settingsCount(int count) {
    return 'تنظیمات: $count';
  }

  @override
  String get clearCacheTitle => 'پاک کردن حافظه موقت';

  @override
  String get clearCacheConfirmation =>
      'آیا از پاک کردن حافظه موقت مطمئن هستید؟';

  @override
  String get cacheCleared => 'حافظه موقت پاک شد';

  @override
  String get clear => 'پاک کردن';

  @override
  String get dataExported => 'داده‌ها صادر شد';

  @override
  String get appDescription =>
      'برنامه‌ای برای مطالعه شعر فارسی با اشعار از گنجور';

  @override
  String get features => 'امکانات:';

  @override
  String get randomPoemFeature => '• دریافت شعر تصادفی';

  @override
  String get favoritesFeature => '• علاقه‌مندی‌ها';

  @override
  String get notificationsFeature => '• اعلان‌های روزانه';

  @override
  String get searchFeature => '• جستجو و فیلتر';

  @override
  String get helpTitle => 'راهنما';

  @override
  String howToUse(String appName) {
    return 'نحوه استفاده از $appName:';
  }

  @override
  String get helpStep1 => '1. برای دریافت شعر تصادفی، روی دکمه بزرگ کلیک کنید';

  @override
  String get helpStep2 =>
      '2. با کلیک روی قلب، شعر را به علاقه‌مندی‌ها اضافه کنید';

  @override
  String get helpStep3 =>
      '3. در صفحه علاقه‌مندی‌ها می‌توانید اشعار را جستجو کنید';

  @override
  String get helpStep4 => '4. از تنظیمات، اعلان‌های روزانه را فعال کنید';

  @override
  String get helpStep5 => '5. شعرها را با دوستان خود به اشتراک بگذارید';

  @override
  String get dataSourceTitle => 'منبع داده‌ها';

  @override
  String get ganjoorDescription => 'این برنامه از API گنجور استفاده می‌کند.';

  @override
  String get ganjoorInfo =>
      'گنجور بزرگترین کتابخانه شعر فارسی است که توسط رضا امیرحسنی تأسیس شده است.';

  @override
  String get ganjoorWebsite => 'وب‌سایت: ganjoor.net';

  @override
  String get ganjoorApi => 'API: api.ganjoor.net';

  @override
  String get recentFavorites => 'علاقه‌مندی‌های اخیر';

  @override
  String get dailyPoemNotificationTitle => 'شکامه - شعر روز';

  @override
  String get dailyPoemNotificationBody => 'شعری زیبا برای شما آماده شده است';

  @override
  String get testNotificationTitle => 'تست اعلان';

  @override
  String get testNotificationBody => 'این یک پیام آزمایشی است';

  @override
  String get enabled => 'فعال';

  @override
  String get disabled => 'غیرفعال';

  @override
  String get viewAll => 'مشاهده همه';

  @override
  String get searchHint => 'جستجو کنید...';
}
