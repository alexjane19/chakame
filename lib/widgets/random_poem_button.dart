import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/poem_provider.dart';
import '../utils/constants.dart';

class RandomPoemButton extends ConsumerStatefulWidget {
  const RandomPoemButton({super.key});

  @override
  ConsumerState createState() => _RandomPoemButtonState();
}

class _RandomPoemButtonState extends ConsumerState<RandomPoemButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer(
      builder: (context, ref, child) {
        return AnimatedBuilder(
          animation: Listenable.merge([
            _pulseAnimation,
            _rotationAnimation,
            _scaleAnimation,
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: AppDimensions.randomButtonSize,
                  height: AppDimensions.randomButtonSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: _buildGradient(theme),
                    boxShadow: [
                      BoxShadow(
                        color: theme.primaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppDimensions.randomButtonSize / 2),
                      onTap: () => _onPressed(context, ref.watch(poemProvider)),
                      onTapDown: (_) => _scaleController.forward(),
                      onTapUp: (_) => _scaleController.reverse(),
                      onTapCancel: () => _scaleController.reverse(),
                      child: _buildButtonContent(context, ref.watch(poemProvider)),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildButtonContent(BuildContext context, PoemState poemState) {
    final theme = Theme.of(context);
    
    if (poemState.isLoading) {
      return _buildLoadingContent(theme);
    }

    return _buildDefaultContent(theme);
  }

  Widget _buildDefaultContent(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _rotationAnimation,
            child: Icon(
              Icons.auto_stories,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.marginSmall),
          Text(
            AppLocalizations.of(context)!.newPoem,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.marginSmall),
          Text(
            AppLocalizations.of(context)!.getRandomPoem,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
          const SizedBox(height: AppDimensions.marginMedium),
          Text(
            AppLocalizations.of(context)!.loading,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  LinearGradient _buildGradient(ThemeData theme) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        theme.primaryColor,
        theme.primaryColor.withOpacity(0.8),
        theme.colorScheme.secondary,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  Future<void> _onPressed(BuildContext context, PoemState poemState) async {
    if (poemState.isLoading) return;
    try {
      await _rotationController.forward();

      await ref.watch(poemProvider.notifier).loadRandomPoem();

      if (poemState.currentPoem != null) {
        _showSuccessAnimation();
      }
    } catch (e) {
      _showErrorSnackbar(context, e.toString());
    } finally {
      _rotationController.reset();
    }
  }

  void _showSuccessAnimation() {
    _pulseController.stop();
    _pulseController.reset();
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _pulseController.repeat(reverse: true);
      }
    });
  }

  void _showErrorSnackbar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error.contains('ApiException') 
              ? error.split(': ')[1]
              : AppLocalizations.of(context)!.poemLoadError,
        ),
        backgroundColor: AppColors.errorColor,
        action: SnackBarAction(
          label: AppLocalizations.of(context)!.retry,
          textColor: Colors.white,
          onPressed: () {
            final poemNotifier = ref.read(poemProvider.notifier);
            poemNotifier.loadRandomPoem();
          },
        ),
      ),
    );
  }
}