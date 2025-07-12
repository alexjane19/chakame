import 'package:chakame/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';

class PrivacyPolicyScreen extends ConsumerStatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  ConsumerState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends ConsumerState<PrivacyPolicyScreen>
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
        title: Text(AppLocalizations.of(context)!.privacyPolicy),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: _buildPrivacyPolicyContent(context, theme),
          );
        },
      ),
    );
  }

  Widget _buildPrivacyPolicyContent(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            context,
            theme,
            AppLocalizations.of(context)!.privacyPolicyTitle,
            AppLocalizations.of(context)!.privacyPolicyIntro,
          ),
          const SizedBox(height: AppDimensions.marginLarge),
          
          _buildSectionCard(
            context,
            theme,
            AppLocalizations.of(context)!.dataCollectionTitle,
            AppLocalizations.of(context)!.dataCollectionContent,
          ),
          const SizedBox(height: AppDimensions.marginLarge),
          
          _buildSectionCard(
            context,
            theme,
            AppLocalizations.of(context)!.dataUsageTitle,
            AppLocalizations.of(context)!.dataUsageContent,
          ),
          const SizedBox(height: AppDimensions.marginLarge),
          
          _buildSectionCard(
            context,
            theme,
            AppLocalizations.of(context)!.dataSharingTitle,
            AppLocalizations.of(context)!.dataSharingContent,
          ),
          const SizedBox(height: AppDimensions.marginLarge),
          
          _buildSectionCard(
            context,
            theme,
            AppLocalizations.of(context)!.dataStorageTitle,
            AppLocalizations.of(context)!.dataStorageContent,
          ),
          const SizedBox(height: AppDimensions.marginLarge),
          
          _buildSectionCard(
            context,
            theme,
            AppLocalizations.of(context)!.userRightsTitle,
            AppLocalizations.of(context)!.userRightsContent,
          ),
          const SizedBox(height: AppDimensions.marginLarge),
          
          _buildSectionCard(
            context,
            theme,
            AppLocalizations.of(context)!.contactTitle,
            AppLocalizations.of(context)!.contactContent,
          ),
          const SizedBox(height: AppDimensions.marginLarge),
          
          _buildLastUpdatedCard(context, theme),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, ThemeData theme, String title, String content) {
    return Card(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.marginMedium),
            Text(
              content,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastUpdatedCard(BuildContext context, ThemeData theme) {
    return Card(
      elevation: AppDimensions.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Row(
          children: [
            Icon(
              Icons.update,
              color: theme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: AppDimensions.marginSmall),
            Text(
              AppLocalizations.of(context)!.lastUpdated,
              style: theme.textTheme.bodySmall?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}