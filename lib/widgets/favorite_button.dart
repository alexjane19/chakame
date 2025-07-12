import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/poem_model.dart';
import '../providers/favorites_provider.dart';
import '../utils/constants.dart';

class FavoriteButton extends ConsumerStatefulWidget {
  final Poem poem;
  final double size;
  final bool showAnimation;

  const FavoriteButton({
    super.key,
    required this.poem,
    this.size = 24.0,
    this.showAnimation = true,
  });

  @override
  ConsumerState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

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
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isFavorite = ref.read(favoritesProvider.notifier).isFavorite(widget.poem.id);
        
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value,
                child: IconButton(
                  onPressed: () => _toggleFavorite(context, ref.watch(favoritesProvider)),
                  icon: AnimatedSwitcher(
                    duration: AppAnimations.shortDuration,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(isFavorite),
                      size: widget.size,
                      color: isFavorite 
                          ? AppColors.favoriteColor 
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: isFavorite
                        ? AppColors.favoriteColor.withOpacity(0.1)
                        : Theme.of(context).primaryColor.withOpacity(0.1),
                    padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _toggleFavorite(BuildContext context, FavoritesState favoritesState) {
    final wasInFavorites = ref.read(favoritesProvider.notifier).isFavorite(widget.poem.id);
    
    ref.read(favoritesProvider.notifier).toggleFavorite(widget.poem);
    
    if (widget.showAnimation) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }
    
    final isNowInFavorites = ref.read(favoritesProvider.notifier).isFavorite(widget.poem.id);
    final message = isNowInFavorites 
        ? AppLocalizations.of(context)!.poemAddedToFavorites 
        : AppLocalizations.of(context)!.poemRemovedFromFavorites;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isNowInFavorites 
            ? AppColors.successColor 
            : AppColors.warningColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
      ),
    );
  }
}

class AnimatedFavoriteIcon extends ConsumerStatefulWidget {
  final bool isFavorite;
  final double size;
  final Color? color;
  final VoidCallback? onPressed;

  const AnimatedFavoriteIcon({
    super.key,
    required this.isFavorite,
    this.size = 24.0,
    this.color,
    this.onPressed,
  });

  @override
  ConsumerState createState() => _AnimatedFavoriteIconState();
}

class _AnimatedFavoriteIconState extends ConsumerState<AnimatedFavoriteIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.mediumDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedFavoriteIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFavorite != widget.isFavorite) {
      _controller.forward().then((_) {
        _controller.reverse();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                size: widget.size,
                color: widget.color ?? 
                    (widget.isFavorite 
                        ? AppColors.favoriteColor 
                        : Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FavoriteFloatingActionButton extends ConsumerStatefulWidget {
  final Poem poem;
  final VoidCallback? onPressed;

  const FavoriteFloatingActionButton({
    super.key,
    required this.poem,
    this.onPressed,
  });

  @override
  ConsumerState createState() => _FavoriteFloatingActionButtonState();
}

class _FavoriteFloatingActionButtonState extends ConsumerState<FavoriteFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.shortDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final isFavorite = ref.read(favoritesProvider.notifier).isFavorite(widget.poem.id);
        
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: FloatingActionButton(
                onPressed: () => _handlePress(context, ref.watch(favoritesProvider)),
                backgroundColor: isFavorite 
                    ? AppColors.favoriteColor 
                    : Theme.of(context).primaryColor,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handlePress(BuildContext context, FavoritesState favoritesState) {
    _controller.forward().then((_) {
      _controller.reverse();
    });

    ref.read(favoritesProvider.notifier).toggleFavorite(widget.poem);
    
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }
}