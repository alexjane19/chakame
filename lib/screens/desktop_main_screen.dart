import 'package:chakame/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/favorites_provider.dart';
import '../providers/poem_provider.dart';
import '../services/responsive_service.dart';
import '../utils/constants.dart';
import '../widgets/poem_card.dart';
import '../widgets/poet_card.dart';
import '../widgets/random_poem_button.dart';
import '../widgets/search_bar.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class DesktopMainScreen extends ConsumerStatefulWidget {
  const DesktopMainScreen({super.key});

  @override
  ConsumerState createState() => _DesktopMainScreenState();
}

class _DesktopMainScreenState extends ConsumerState<DesktopMainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  void _loadInitialData() {
    final poemNotifier = ref.read(poemProvider.notifier);
    poemNotifier.loadPoets();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsiveService = ResponsiveService.instance;
    // final platformService = PlatformService.instance;

    return Scaffold(
      key: _scaffoldKey,
      body: Row(
        children: [
          // Side Navigation
          _buildSideNavigation(context, theme, responsiveService),

          // Main Content Area
          Expanded(
            child: _buildMainContent(context, theme, responsiveService),
          ),

          // Right Sidebar (if needed)
          if (responsiveService.isLargeScreen(context))
            _buildRightSidebar(context, theme, responsiveService),
        ],
      ),
    );
  }

  Widget _buildSideNavigation(BuildContext context, ThemeData theme,
      ResponsiveService responsiveService) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              children: [
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.marginSmall),
                Text(
                  AppConstants.appSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingMedium),
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  title: AppLocalizations.of(context)!.home,
                  index: 0,
                ),
                _buildNavItem(
                  icon: Icons.favorite,
                  title: AppLocalizations.of(context)!.favorites,
                  index: 1,
                  badge: Consumer(
                    builder: (context, ref, child) {
                      final favoritesState = ref.watch(favoritesProvider);
                      return favoritesState.favoritesCount > 0
                          ? Text(
                              '${favoritesState.favoritesCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
                _buildNavItem(
                  icon: Icons.person,
                  title: AppLocalizations.of(context)!.poets,
                  index: 2,
                ),
                _buildNavItem(
                  icon: Icons.settings,
                  title: AppLocalizations.of(context)!.settings,
                  index: 3,
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.version(AppConstants.appVersion),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: AppDimensions.marginSmall),
                Text(
                  AppLocalizations.of(context)!.ganjoorSource,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required int index,
    Widget? badge,
  }) {
    final isSelected = _selectedIndex == index;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.marginMedium,
        vertical: AppDimensions.marginSmall,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white70,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: badge,
        selected: isSelected,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        selectedTileColor: Colors.white.withOpacity(0.1),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ThemeData theme,
      ResponsiveService responsiveService) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: _getSelectedScreen(),
    );
  }

  Widget _buildRightSidebar(BuildContext context, ThemeData theme,
      ResponsiveService responsiveService) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Quick Actions
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.operations,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.marginMedium),
                _buildQuickAction(
                  icon: Icons.shuffle,
                  title: AppLocalizations.of(context)!.getRandomPoem,
                  onTap: () => _getRandomPoem(),
                ),
                _buildQuickAction(
                  icon: Icons.search,
                  title: AppLocalizations.of(context)!.searchPoems,
                  onTap: () => _showSearchDialog(),
                ),
                _buildQuickAction(
                  icon: Icons.favorite,
                  title: AppLocalizations.of(context)!.favorites,
                  onTap: () => _navigateToFavorites(),
                ),
              ],
            ),
          ),

          const Divider(),

          // Recent Favorites
          Expanded(
            child: _buildRecentFavorites(context, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.marginSmall),
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.primaryColor,
        ),
        title: Text(title),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        hoverColor: theme.primaryColor.withOpacity(0.1),
      ),
    );
  }

  Widget _buildRecentFavorites(BuildContext context, ThemeData theme) {
    return Consumer(
      builder: (context, ref, child) {
        final favoritesState = ref.watch(favoritesProvider);
        if (favoritesState.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noFavoritesAdded),
          );
        }

        final recentFavorites =
            ref.read(favoritesProvider.notifier).getRecentFavorites(limit: 5);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingMedium),
              child: Text(
                AppLocalizations.of(context)!.recentFavorites,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMedium),
                itemCount: recentFavorites.length,
                itemBuilder: (context, index) {
                  final favorite = recentFavorites[index];
                  return Card(
                    margin: const EdgeInsets.only(
                        bottom: AppDimensions.marginSmall),
                    child: ListTile(
                      leading: const Icon(
                        Icons.favorite,
                        color: AppColors.favoriteColor,
                      ),
                      title: Text(
                        favorite.poemTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        favorite.poetName,
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                      ),
                      onTap: () {
                        // Navigate to poem detail
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const DesktopHomeContent();
      case 1:
        return const FavoritesScreen();
      case 2:
        return const DesktopPoetsContent();
      case 3:
        return const SettingsScreen();
      default:
        return const DesktopHomeContent();
    }
  }

  void _getRandomPoem() {
    final poemNotifier = ref.read(poemProvider.notifier);
    poemNotifier.loadRandomPoem();
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.searchPoemsTitle),
        content: SizedBox(
          width: 400,
          child: PersianSearchBar(
            hintText: AppLocalizations.of(context)!.searchInFavorites,
            onChanged: (query) {
              // Handle search
            },
            onSubmitted: (query) {
              Navigator.pop(context);
              // Perform search
            },
          ),
        ),
      ),
    );
  }

  void _navigateToFavorites() {
    setState(() {
      _selectedIndex = 1;
    });
  }
}

class DesktopHomeContent extends ConsumerWidget {
  const DesktopHomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final responsiveService = ResponsiveService.instance;

    return SingleChildScrollView(
      padding: responsiveService.getPagePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          Text(
            AppLocalizations.of(context)!.welcome,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.marginSmall),
          Text(
            AppLocalizations.of(context)!.welcomeMessage,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppDimensions.marginExtraLarge),

          // Random Poem Section
          Center(
            child: Column(
              children: [
                const RandomPoemButton(),
                const SizedBox(height: AppDimensions.marginLarge),
                Consumer(
                  builder: (context, ref, child) {
                    final poemState = ref.watch(poemProvider);
                    if (poemState.currentPoem != null) {
                      return ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: PoemCard(
                          poem: poemState.currentPoem!,
                          showFullText: false,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.marginExtraLarge),

          // Today's Poet Section
          Consumer(
            builder: (context, ref, child) {
              final poets = ref.read(poemProvider.notifier).getPublishedPoets();
              if (poets.isEmpty) {
                return const SizedBox.shrink();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.todaysPoet,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.marginMedium),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: PoetCard(poet: poets.first),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class DesktopPoetsContent extends ConsumerWidget {
  const DesktopPoetsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final responsiveService = ResponsiveService.instance;

    return Consumer(
      builder: (context, ref, child) {
        final poemState = ref.watch(poemProvider);
        if (poemState.isLoadingPoets) {
          return const Center(child: CircularProgressIndicator());
        }

        final poets = ref.read(poemProvider.notifier).getPublishedPoets();

        return SingleChildScrollView(
          padding: responsiveService.getPagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.poets,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.marginLarge),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: responsiveService.getGridDelegate(context),
                itemCount: poets.length,
                itemBuilder: (context, index) {
                  return PoetCard(
                    poet: poets[index],
                    isCompact: true,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
