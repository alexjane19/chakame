import 'package:chakame/l10n/l10n.dart';
import 'package:chakame/models/poet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import '../providers/poem_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import '../widgets/random_poem_button.dart';
import '../widgets/poem_card.dart';
import '../widgets/poet_card.dart';
import 'poem_detail_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _loadInitialData());
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: AppAnimations.extraLongDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.defaultCurve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.defaultCurve,
    ));

    _animationController.forward();
  }

  void _loadInitialData() {
    final poemNotifier = ref.read(poemProvider.notifier);
    poemNotifier.loadPoets();
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
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: _buildMainContent(context, theme),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ThemeData theme) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(context, theme),
        _buildRandomPoemSection(context),
        _buildTodaysPoetSection(context),
        _buildQuickActionsSection(context),
        _buildRecentFavoritesSection(context),
      ],
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          AppConstants.appName,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.primaryColor.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppConstants.appSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRandomPoemSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.marginLarge),
            const RandomPoemButton(),
            const SizedBox(height: AppDimensions.marginMedium),
            Consumer(
              builder: (context, ref, child) {
                final poemState = ref.watch(poemProvider);
                if (poemState.currentPoem != null) {
                  return OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    openBuilder: (context, action) {
                      return PoemDetailScreen(poem: poemState.currentPoem!);
                    },
                    closedBuilder: (context, action) {
                      return PoemCard(
                        poem: poemState.currentPoem!,
                        showFullText: false,
                      );
                    },
                    closedElevation: AppDimensions.elevationMedium,
                    closedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysPoetSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer(
        builder: (context, ref, child) {
          final poemState = ref.watch(poemProvider);
          if (poemState.isLoadingPoets) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingLarge),
                child: CircularProgressIndicator(),
              ),
            );
          }

          return FutureBuilder<Poet>(
            future: ref.read(poemProvider.notifier).getRandomPoet(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.paddingLarge),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (snapshot.hasError || !snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final todaysPoet = snapshot.data!;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                  vertical: AppDimensions.paddingMedium,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.todaysPoet,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                  const SizedBox(height: AppDimensions.marginMedium),
                  PoetCard(poet: todaysPoet),
                ],
              ));
            },
          );
        },
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.explorePoems,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: AppDimensions.marginMedium),
            _buildQuickActionsGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final theme = Theme.of(context);
    
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppDimensions.marginMedium,
      mainAxisSpacing: AppDimensions.marginMedium,
      childAspectRatio: 1.5,
      children: [
        _buildQuickActionCard(
          context,
          icon: Icons.search,
          title: AppLocalizations.of(context)!.searchPoems,
          onTap: () => _showSearchDialog(context),
        ),
        _buildQuickActionCard(
          context,
          icon: Icons.person,
          title: AppLocalizations.of(context)!.poets,
          onTap: () => _showPoetsDialog(context),
        ),
        _buildQuickActionCard(
          context,
          icon: Icons.favorite,
          title: AppLocalizations.of(context)!.favorites,
          onTap: () => _navigateToFavorites(context),
        ),
        _buildQuickActionCard(
          context,
          icon: Icons.settings,
          title: AppLocalizations.of(context)!.settings,
          onTap: () => _navigateToSettings(context),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingMedium),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: AppDimensions.iconSizeLarge,
                color: theme.primaryColor,
              ),
              const SizedBox(height: AppDimensions.marginSmall),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentFavoritesSection(BuildContext context) {
    return SliverToBoxAdapter(
      child: Consumer(
        builder: (context, ref, child) {
          final favoritesState = ref.watch(favoritesProvider);
          if (favoritesState.isEmpty) {
            return const SizedBox.shrink();
          }

          final recentFavorites = ref.read(favoritesProvider.notifier).getRecentFavorites(limit: 3);

          return Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.recentPoems,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _navigateToFavorites(context),
                      child: Text(
                        AppLocalizations.of(context)!.viewAll,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.marginMedium),
                ...recentFavorites.map((favorite) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.marginSmall),
                  child: _buildFavoriteItem(context, favorite),
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoriteItem(BuildContext context, favorite) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: AppDimensions.elevationSmall,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: ListTile(
        leading: Icon(
          Icons.favorite,
          color: AppColors.favoriteColor,
        ),
        title: Text(
          favorite.poemTitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          favorite.poetName,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.primaryColor,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: AppDimensions.iconSizeSmall,
        ),
        onTap: () {
          // Navigate to poem detail
        },
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.searchPoems),
        content: TextField(
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchHint,
            border: OutlineInputBorder(),
          ),
          onSubmitted: (query) {
            Navigator.pop(context);
            if (query.isNotEmpty) {
              final poemNotifier = ref.read(poemProvider.notifier);
              poemNotifier.searchPoems(query);
            }
          },
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

  void _showPoetsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.poets),
        content: Consumer(
          builder: (context, ref, child) {
            final poemPro = ref.read(poemProvider.notifier);
            final poets = poemPro.getPublishedPoets();
            
            return SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: poets.length,
                itemBuilder: (context, index) {
                  final poet = poets[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(poet.displayName[0]),
                    ),
                    title: Text(poet.displayName),
                    // subtitle: Text('${poet.description}', maxLines: 2),
                    onTap: () {
                      Navigator.pop(context);
                      poemPro.loadRandomPoemFromPoet(poet.id);
                    },
                  );
                },
              ),
            );
          },
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

  void _navigateToFavorites(BuildContext context) {
    Navigator.pushNamed(context, '/favorites');
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings');
  }
}