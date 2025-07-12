import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:chakame/l10n/l10n.dart';
import '../models/poem_model.dart';
import '../providers/favorites_provider.dart';
import '../utils/constants.dart';
import 'favorite_button.dart';

class PoemCard extends ConsumerStatefulWidget {
  final Poem poem;
  final bool showFullText;
  final bool isCompact;
  final VoidCallback? onTap;

  const PoemCard({
    super.key,
    required this.poem,
    this.showFullText = false,
    this.isCompact = false,
    this.onTap,
  });

  @override
  ConsumerState createState() => _PoemCardState();
}

class _PoemCardState extends ConsumerState<PoemCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
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

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

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
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Card(
              elevation: AppDimensions.elevationMedium,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              ),
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: widget.isCompact ? 100 : AppDimensions.cardMinHeight,
                  ),
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildHeader(context, theme),
                      const SizedBox(height: AppDimensions.marginMedium),
                      _buildPoemContent(context, theme),
                      if (!widget.isCompact) ...[
                        const SizedBox(height: AppDimensions.marginMedium),
                        _buildActionButtons(context, theme),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.poem.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
                maxLines: widget.isCompact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimensions.marginSmall),
              Text(
                widget.poem.poetName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (!widget.isCompact)
          FavoriteButton(
            poem: widget.poem,
            size: AppDimensions.iconSizeLarge,
          ),
      ],
    );
  }

  Widget _buildPoemContent(BuildContext context, ThemeData theme) {
    final verses = widget.poem.verses;
    final displayVerses = widget.showFullText 
        ? verses 
        : verses.take(2).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
            ...displayVerses.map((verse) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.marginSmall),
              child: Text(
                verse,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.8,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                textAlign: TextAlign.justify,
                overflow: TextOverflow.visible,
                softWrap: true,
              ),
            )),
            if (!widget.showFullText && verses.length > 2)
              Padding(
                padding: const EdgeInsets.only(top: AppDimensions.marginSmall),
                child: Text(
                  AppLocalizations.of(context)!.continuePoem,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.primaryColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),

    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context,
          icon: Icons.copy,
          label: AppLocalizations.of(context)!.copyShort,
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
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: color ?? theme.primaryColor,
          ),
          style: IconButton.styleFrom(
            backgroundColor: (color ?? theme.primaryColor).withOpacity(0.1),
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
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
        ),
      ],
    );
  }

  void _copyToClipboard(BuildContext context) {
    final poemText = '''
${widget.poem.title}
${widget.poem.poetName}

${widget.poem.plainText}
''';
    
    Clipboard.setData(ClipboardData(text: poemText));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.poemCopied),
        backgroundColor: AppColors.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _sharePoem(BuildContext context) {
    final poemText = '''
${widget.poem.title}
${widget.poem.poetName}

${widget.poem.plainText}

${AppLocalizations.of(context)!.ganjoorSource}
${widget.poem.poemUrl}
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
        duration: const Duration(seconds: 2),
      ),
    );
  }
}