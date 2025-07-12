import 'package:chakame/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../providers/favorites_provider.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../utils/constants.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppAnimations.mediumDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.defaultCurve,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsState = ref.watch(settingsProvider);
    
    return Scaffold(
      backgroundColor: settingsState.darkMode 
          ? AppColors.backgroundColorDark 
          : AppColors.backgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildSettingsContent(context, theme, settingsState),
          );
        },
      ),
    );
  }

  Widget _buildSettingsContent(BuildContext context, ThemeData theme, SettingsState settingsState) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      children: [
        _buildSectionTitle(context, AppLocalizations.of(context)!.settings),
        _buildAppearanceSection(context, theme, settingsState),
        const SizedBox(height: AppDimensions.marginExtraLarge),
        
        _buildSectionTitle(context, AppLocalizations.of(context)!.notifications),
        _buildNotificationsSection(context, theme, settingsState),
        const SizedBox(height: AppDimensions.marginExtraLarge),
        
        _buildSectionTitle(context, AppLocalizations.of(context)!.dataSource),
        _buildDataSection(context, theme),
        const SizedBox(height: AppDimensions.marginExtraLarge),
        
        _buildSectionTitle(context, AppLocalizations.of(context)!.about),
        _buildAboutSection(context, theme),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.marginMedium),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context, ThemeData theme, SettingsState settingsState) {
    return Card(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Column(
        children: [
          SwitchListTile(
            secondary: Icon(
              settingsState.darkMode ? Icons.dark_mode : Icons.light_mode,
              color: theme.primaryColor,
            ),
            title: Text(AppLocalizations.of(context)!.darkMode),
            subtitle: Text(
              settingsState.darkMode 
                  ? AppLocalizations.of(context)!.enabled 
                  : AppLocalizations.of(context)!.disabled,
              style: TextStyle(
                color: settingsState.darkMode ? Colors.green : Colors.grey,
              ),
            ),
            value: settingsState.darkMode,
            onChanged: (value) => ref.read(settingsProvider.notifier).toggleDarkMode(),
            activeColor: theme.primaryColor,
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.font_download,
              color: theme.primaryColor,
            ),
            title: Text(AppLocalizations.of(context)!.fontSelection),
            subtitle: Text(
              AppConstants.fontDisplayNames[settingsState.selectedFont] ?? 
              settingsState.selectedFont,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showFontSelectionDialog(context, settingsState),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(BuildContext context, ThemeData theme, SettingsState settingsState) {
    return Card(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Column(
        children: [
          SwitchListTile(
            secondary: Icon(
              settingsState.notificationsEnabled ? Icons.notifications : Icons.notifications_off,
              color: theme.primaryColor,
            ),
            title: Text(AppLocalizations.of(context)!.dailyNotifications),
            subtitle: Text(
              settingsState.notificationsEnabled 
                  ? AppLocalizations.of(context)!.enabled 
                  : AppLocalizations.of(context)!.disabled,
              style: TextStyle(
                color: settingsState.notificationsEnabled ? Colors.green : Colors.grey,
              ),
            ),
            value: settingsState.notificationsEnabled,
            onChanged: (value) => ref.read(settingsProvider.notifier).toggleNotifications(),
            activeColor: theme.primaryColor,
          ),
          if (settingsState.notificationsEnabled) ...[
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.access_time,
                color: theme.primaryColor,
              ),
              title: Text(AppLocalizations.of(context)!.notificationTime),
              subtitle: Text(ref.read(settingsProvider.notifier).getNotificationTimeFormatted()),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showTimePicker(context),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.science,
                color: theme.primaryColor,
              ),
              title: Text(AppLocalizations.of(context)!.testNotification),
              subtitle: Text(AppLocalizations.of(context)!.sendTestNotification),
              trailing: const Icon(Icons.send),
              onTap: () => _testNotification(context),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataSection(BuildContext context, ThemeData theme) {
    return Card(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Column(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final favoritesState = ref.watch(favoritesProvider);
              return ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: AppColors.favoriteColor,
                ),
                title: Text(AppLocalizations.of(context)!.favoritesTitle),
                subtitle: Text(AppLocalizations.of(context)!.poemsCount(favoritesState.favoritesCount)),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showStorageStats(context),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.clear_all,
              color: theme.primaryColor,
            ),
            title: Text(AppLocalizations.of(context)!.clearCache),
            subtitle: Text(AppLocalizations.of(context)!.clearCacheSubtitle),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _clearCache(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.backup,
              color: theme.primaryColor,
            ),
            title: Text(AppLocalizations.of(context)!.backup),
            subtitle: Text(AppLocalizations.of(context)!.backupSubtitle),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _exportData(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, ThemeData theme) {
    return Card(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.info,
              color: theme.primaryColor,
            ),
            title: Text(AppLocalizations.of(context)!.aboutApp(AppConstants.appName)),
            subtitle: Text(AppLocalizations.of(context)!.version(AppConstants.appVersion)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showAboutDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.help,
              color: theme.primaryColor,
            ),
            title: Text(AppLocalizations.of(context)!.help),
            subtitle: Text(AppLocalizations.of(context)!.helpSubtitle),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showHelpDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.code,
              color: theme.primaryColor,
            ),
            title: Text(AppLocalizations.of(context)!.dataSource),
            subtitle: Text(AppLocalizations.of(context)!.ganjoorSource),
            trailing: const Icon(Icons.open_in_new),
            onTap: () => _showDataSourceInfo(context),
          ),
        ],
      ),
    );
  }

  void _showFontSelectionDialog(BuildContext context, SettingsState settingsState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.fontSelection),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.availableFonts.map((font) {
            return RadioListTile<String>(
              title: Text(
                AppConstants.fontDisplayNames[font] ?? font,
                style: TextStyle(fontFamily: font),
              ),
              value: font,
              groupValue: settingsState.selectedFont,
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setSelectedFont(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
        ],
      ),
    );
  }

  void _showTimePicker(BuildContext context) async {
    final currentTime = ref.read(settingsProvider.notifier).getNotificationTimeOfDay();
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      ref.read(settingsProvider.notifier).setNotificationTime(selectedTime);
    }
  }

  void _testNotification(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    await NotificationService.instance.testNotification(
      title: localizations.testNotificationTitle,
      body: localizations.testNotificationBody,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.testNotificationSent),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  void _showStorageStats(BuildContext context) {
    final stats = StorageService.instance.getStorageStats();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.storageStats),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.cachedPoems(stats['cached_poems'])),
            Text(AppLocalizations.of(context)!.favoritesCount(stats['favorites_count'])),
            Text(AppLocalizations.of(context)!.cachedPoets(stats['cached_poets'])),
            Text(AppLocalizations.of(context)!.settingsCount(stats['settings_count'])),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  void _clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearCacheTitle),
        content: Text(AppLocalizations.of(context)!.clearCacheConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await StorageService.instance.clearPoemCache();
              await StorageService.instance.clearPoetsCache();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.cacheCleared),
                  backgroundColor: AppColors.successColor,
                ),
              );
            },
            child: Text(AppLocalizations.of(context)!.clear),
          ),
        ],
      ),
    );
  }

  void _exportData(BuildContext context) async {
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    await favoritesNotifier.exportFavorites();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.dataExported),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.aboutApp(AppConstants.appName)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppConstants.appName} - ${AppConstants.appSubtitle}'),
            SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.version(AppConstants.appVersion)),
            SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.appDescription),
            SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.features),
            Text(AppLocalizations.of(context)!.randomPoemFeature),
            Text(AppLocalizations.of(context)!.favoritesFeature),
            Text(AppLocalizations.of(context)!.notificationsFeature),
            Text(AppLocalizations.of(context)!.searchFeature),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.helpTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.howToUse(AppConstants.appName), 
                   style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.helpStep1),
              SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.helpStep2),
              SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.helpStep3),
              SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.helpStep4),
              SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.helpStep5),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  void _showDataSourceInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.dataSourceTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.ganjoorDescription),
            SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.ganjoorInfo),
            SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.ganjoorWebsite),
            SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.ganjoorApi),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }
}