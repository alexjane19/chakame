import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/poem_model.dart';
import '../providers/favorites_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../widgets/favorite_button.dart';

class PoemDetailScreen extends ConsumerStatefulWidget {
  final Poem poem;

  const PoemDetailScreen({
    super.key,
    required this.poem,
  });

  @override
  ConsumerState createState() => _PoemDetailScreenState();
}

class _PoemDetailScreenState extends ConsumerState<PoemDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: AppAnimations.mediumDuration,
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: AppAnimations.longDuration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: AppAnimations.defaultCurve,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scrollController.dispose();
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
      body: AnimatedBuilder(
        animation: Listenable.merge([_slideController, _fadeController]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _buildSliverAppBar(context, theme),
                  _buildPoemContent(context, theme),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FavoriteFloatingActionButton(
        poem: widget.poem,
        onPressed: () => _showFavoriteConfirmation(context),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: theme.primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.share,
            color: Colors.white,
          ),
          onPressed: () => _sharePoem(context),
        ),
        IconButton(
          icon: Icon(
            Icons.copy,
            color: Colors.white,
          ),
          onPressed: () => _copyToClipboard(context),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primaryColor,
                theme.primaryColor.withOpacity(0.8),
                theme.colorScheme.secondary,
              ],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.only(
              left: AppDimensions.paddingLarge,
              right: AppDimensions.paddingLarge,
              bottom: AppDimensions.paddingLarge,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.poem.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.marginSmall),
                Text(
                  widget.poem.poetName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimensions.marginSmall),
                Text(
                  widget.poem.categoryName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPoemContent(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPoemText(context, theme),
            const SizedBox(height: AppDimensions.marginExtraLarge),
            _buildPoemActions(context, theme),
            const SizedBox(height: AppDimensions.marginExtraLarge),
            _buildPoemInfo(context, theme),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildPoemText(BuildContext context, ThemeData theme) {
    final settingsState = ref.watch(settingsProvider);
    final verses = widget.poem.verses;

    return Card(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.poemText,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.marginLarge),
            ...verses.asMap().entries.map((entry) {
              final index = entry.key;
              final verse = entry.value;
              
              return AnimatedContainer(
                duration: AppAnimations.shortDuration,
                margin: const EdgeInsets.only(bottom: AppDimensions.marginMedium),
                child: Text(
                  verse,
                  style: TextStyle(
                    fontSize: 18,
                    height: 2.0,
                    color: theme.textTheme.bodyLarge?.color,
                    fontFamily: settingsState.selectedFont,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.justify,
                  textDirection: TextDirection.rtl,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPoemActions(BuildContext context, ThemeData theme) {
    return Card(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.operations,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.marginLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.copy,
                  label: AppLocalizations.of(context)!.copyText,
                  onPressed: () => _copyToClipboard(context),
                ),
                _buildActionButton(
                  context,
                  icon: Icons.share,
                  label: AppLocalizations.of(context)!.share,
                  onPressed: () => _sharePoem(context),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final isFavorite = ref.read(favoritesProvider.notifier).isFavorite(widget.poem.id);
                    return _buildActionButton(
                      context,
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      label: isFavorite ? AppLocalizations.of(context)!.removeFromFavoritesShort : AppLocalizations.of(context)!.addToFavorites,
                      onPressed: () => _toggleFavorite(context, ref.watch(favoritesProvider)),
                      color: isFavorite ? AppColors.favoriteColor : null,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    final theme = Theme.of(context);
    
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: (color ?? theme.primaryColor).withOpacity(0.1),
              foregroundColor: color ?? theme.primaryColor,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              elevation: 0,
            ),
            child: Icon(
              icon,
              size: AppDimensions.iconSizeLarge,
            ),
          ),
          const SizedBox(height: AppDimensions.marginSmall),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color ?? theme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildPoemInfo(BuildContext context, ThemeData theme) {
    return Card(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.poemInfo,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.marginLarge),
            _buildInfoRow(
              context,
              AppLocalizations.of(context)!.title,
              widget.poem.title,
            ),
            _buildInfoRow(
              context,
              AppLocalizations.of(context)!.poet,
              widget.poem.poetName,
            ),
            _buildInfoRow(
              context,
              AppLocalizations.of(context)!.category,
              widget.poem.categoryName,
            ),
            _buildInfoRow(
              context,
              AppLocalizations.of(context)!.verseCount,
              AppLocalizations.of(context)!.versesText(widget.poem.verses.length),
            ),
            const SizedBox(height: AppDimensions.marginMedium),
            ElevatedButton.icon(
              onPressed: () => _openInGanjoor(context),
              icon: const Icon(Icons.open_in_new),
              label: Text(AppLocalizations.of(context)!.viewInGanjoor),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.marginSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    final poemText = '''
${widget.poem.title}
${widget.poem.poetName}

${widget.poem.plainText}

${AppLocalizations.of(context)!.ganjoorSource}
${AppConstants.ganjoorUrl}${widget.poem.poemUrl}
''';
    
    Clipboard.setData(ClipboardData(text: poemText));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.poemCopied),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),
    );
  }

  void _sharePoem(BuildContext context) {
    final poemText = '''
${widget.poem.title}
${widget.poem.poetName}

${widget.poem.plainText}

${AppLocalizations.of(context)!.ganjoorSource}
${AppConstants.ganjoorUrl}${widget.poem.poemUrl}
''';
    
    Share.share(poemText, subject: widget.poem.title);
  }

  void _toggleFavorite(BuildContext context, FavoritesState favoritesState) {
    ref.read(favoritesProvider.notifier).toggleFavorite(widget.poem);
    
    final isFavorite = ref.read(favoritesProvider.notifier).isFavorite(widget.poem.id);
    final message = isFavorite 
        ? AppLocalizations.of(context)!.poemAddedToFavorites 
        : AppLocalizations.of(context)!.poemRemovedFromFavorites;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isFavorite ? AppColors.successColor : AppColors.warningColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),
    );
  }

  void _showFavoriteConfirmation(BuildContext context) {
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    final isFavorite = ref.read(favoritesProvider.notifier).isFavorite(widget.poem.id);
    
    if (isFavorite) {
      _showRemoveFavoriteDialog(context, favoritesNotifier);
    } else {
      favoritesNotifier.addToFavorites(widget.poem);
      _showAddedToFavoritesSnackBar(context);
    }
  }

  void _showRemoveFavoriteDialog(BuildContext context, FavoritesNotifier favoritesNotifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.removeFromFavorites),
        content: Text(AppLocalizations.of(context)!.removeFromFavoritesConfirmation('this poem')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              favoritesNotifier.removeFromFavorites(widget.poem.id);
              _showRemovedFromFavoritesSnackBar(context);
            },
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );
  }

  void _showAddedToFavoritesSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.poemAddedToFavorites),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),
    );
  }

  void _showRemovedFromFavoritesSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.poemRemovedFromFavorites),
        backgroundColor: AppColors.warningColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),
    );
  }

  void _openInGanjoor(BuildContext context) async {
    final url = AppConstants.ganjoorUrl + widget.poem.poemUrl;
    
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback: copy to clipboard and show message
        Clipboard.setData(ClipboardData(text: url));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.link(url)),
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.copy,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: url));
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Error handling: copy to clipboard and show message
      Clipboard.setData(ClipboardData(text: url));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.link(url)),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.copy,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: url));
            },
          ),
        ),
      );
    }
  }
}