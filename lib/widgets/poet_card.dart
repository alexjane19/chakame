import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chakame/l10n/l10n.dart';
import '../models/poet_model.dart';
import '../providers/poem_provider.dart';
import '../utils/constants.dart';

class PoetCard extends ConsumerStatefulWidget {
  final Poet poet;
  final bool isCompact;
  final VoidCallback? onTap;

  const PoetCard({
    super.key,
    required this.poet,
    this.isCompact = false,
    this.onTap,
  });

  @override
  ConsumerState createState() => _PoetCardState();
}

class _PoetCardState extends ConsumerState<PoetCard> with SingleTickerProviderStateMixin {
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
                onTap: widget.onTap ?? () => _getRandomPoemFromPoet(context),
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.paddingLarge),
                  child: widget.isCompact
                      ? _buildCompactLayout(context, theme)
                      : _buildFullLayout(context, theme),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullLayout(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildPoetAvatar(context, theme),
            const SizedBox(width: AppDimensions.marginMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPoetName(context, theme),
                  const SizedBox(height: AppDimensions.marginSmall),
                  _buildPoetInfo(context, theme),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.marginMedium),
        _buildPoetDescription(context, theme),
        const SizedBox(height: AppDimensions.marginMedium),
        _buildActionButton(context, theme),
      ],
    );
  }

  Widget _buildCompactLayout(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        _buildPoetAvatar(context, theme, size: 50),
        const SizedBox(width: AppDimensions.marginMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPoetName(context, theme),
              const SizedBox(height: AppDimensions.marginSmall),
              _buildPoetInfo(context, theme),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios,
          size: AppDimensions.iconSizeSmall,
          color: theme.primaryColor,
        ),
      ],
    );
  }

  Widget _buildPoetAvatar(BuildContext context, ThemeData theme, {double size = 80}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor.withOpacity(0.8),
            theme.primaryColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: widget.poet.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: '${AppConstants.apiBaseUrl}${widget.poet.imageUrl!}',
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildAvatarPlaceholder(theme, size),
                errorWidget: (context, url, error) => _buildAvatarPlaceholder(theme, size),
              )
            : _buildAvatarPlaceholder(theme, size),
      ),
    );
  }

  Widget _buildAvatarPlaceholder(ThemeData theme, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.primaryColor.withOpacity(0.8),
            theme.primaryColor,
          ],
        ),
      ),
      child: Center(
        child: Text(
          widget.poet.displayName.isNotEmpty 
              ? widget.poet.displayName[0]
              : '؟',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPoetName(BuildContext context, ThemeData theme) {
    return Text(
      widget.poet.displayName,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.primaryColor,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPoetInfo(BuildContext context, ThemeData theme) {
    final List<String> infoItems = [];
    
    if (widget.poet.birthYearInLHijri != null) {
      infoItems.add('${widget.poet.birthYearInLHijri} ه.ق');
    }
    
    if (widget.poet.birthLocation != null) {
      infoItems.add(widget.poet.birthLocation!);
    }
    
    if (infoItems.isEmpty) {
      infoItems.add('شاعر بزرگ ایران');
    }

    return Text(
      infoItems.join(' • '),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.secondary,
        fontWeight: FontWeight.w500,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPoetDescription(BuildContext context, ThemeData theme) {
    return Text(
       '${widget.poet.description}',
      style: theme.textTheme.bodyMedium?.copyWith(
        height: 1.6,
        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildActionButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _getRandomPoemFromPoet(context),
        icon: const Icon(Icons.shuffle),
        label: Text(AppLocalizations.of(context)!.randomPoemFromPoet),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingMedium,
            horizontal: AppDimensions.paddingLarge,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
        ),
      ),
    );
  }

  void _getRandomPoemFromPoet(BuildContext context) {
    final poemNotifier = ref.read(poemProvider.notifier);
    poemNotifier.loadRandomPoemFromPoet(widget.poet.id);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.gettingPoemFromPoet(widget.poet.displayName)),
        backgroundColor: Theme.of(context).primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class PoetListTile extends ConsumerWidget {
  final Poet poet;
  final VoidCallback? onTap;

  const PoetListTile({
    super.key,
    required this.poet,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.primaryColor,
        backgroundImage: poet.imageUrl != null 
            ? CachedNetworkImageProvider('${AppConstants.apiBaseUrl}${poet.imageUrl!}')
            : null,
        child: poet.imageUrl == null
            ? Text(
                poet.displayName.isNotEmpty ? poet.displayName[0] : '؟',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
      title: Text(
        poet.displayName,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '${poet.description}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: AppDimensions.iconSizeSmall,
        color: theme.primaryColor,
      ),
      onTap: onTap,
    );
  }
}

class PoetChip extends ConsumerWidget {
  final Poet poet;
  final bool isSelected;
  final VoidCallback? onTap;

  const PoetChip({
    super.key,
    required this.poet,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onTap?.call(),
      label: Text(poet.displayName),
      avatar: CircleAvatar(
        backgroundColor: isSelected ? Colors.white : theme.primaryColor,
        backgroundImage: poet.imageUrl != null 
            ? CachedNetworkImageProvider('${AppConstants.apiBaseUrl}${poet.imageUrl!}')
            : null,
        child: poet.imageUrl == null
            ? Text(
                poet.displayName.isNotEmpty ? poet.displayName[0] : '؟',
                style: TextStyle(
                  color: isSelected ? theme.primaryColor : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              )
            : null,
      ),
      selectedColor: theme.primaryColor,
      backgroundColor: Colors.grey[100],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : theme.primaryColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}