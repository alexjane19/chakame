import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import 'package:chakame/l10n/l10n.dart';
import '../models/favorite_model.dart';
import '../models/poem_model.dart';
import '../providers/favorites_provider.dart';
import '../providers/settings_provider.dart';
import '../utils/constants.dart';
import 'poem_detail_screen.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  String _selectedPoet = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _searchController.addListener(_onSearchChanged);
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

  void _onSearchChanged() {
    final query = _searchController.text;
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      favoritesNotifier.clearSearch();
    } else {
      setState(() {
        _isSearching = true;
      });
      favoritesNotifier.searchFavorites(query);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  FavoritesState? favoritesState;
  FavoritesNotifier? favoritesNotifier;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsState = ref.watch(settingsProvider);
     favoritesState = ref.watch(favoritesProvider);
     favoritesNotifier = ref.watch(favoritesProvider.notifier);
    return Scaffold(
      backgroundColor: settingsState.darkMode 
          ? AppColors.backgroundColorDark 
          : AppColors.backgroundColor,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                _buildSliverAppBar(context, theme),
                _buildSearchAndFilter(context, theme),
                _buildFavoritesList(context, theme),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: false,
      pinned: true,
      backgroundColor: theme.primaryColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.sort, color: Colors.white),
          onPressed: () => _showSortBottomSheet(context),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) => _handleMenuAction(context, value),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'clear_all',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.deleteAll),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'export',
              child: Row(
                children: [
                  const Icon(Icons.file_download),
                  const SizedBox(width: 8),
                  Text(AppLocalizations.of(context)!.export),
                ],
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Consumer(
          builder: (context, ref, child) {
            return Text(
              AppLocalizations.of(context)!.favoritesWithCount(favoritesState?.favoritesCount ?? 0),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
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
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          children: [
            _buildSearchBar(context, theme),
            const SizedBox(height: AppDimensions.marginMedium),
            _buildPoetFilter(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchInFavorites,
          prefixIcon: Icon(
            Icons.search,
            color: theme.primaryColor,
          ),
          suffixIcon: _isSearching
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _isSearching = false;
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.cardColor,
        ),
      ),
    );
  }

  Widget _buildPoetFilter(BuildContext context, ThemeData theme) {
    return Consumer(
      builder: (context, ref, child) {
        final poetNames = ref.read(favoritesProvider.notifier).getUniquePoetNames();
        
        if (poetNames.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: poetNames.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppDimensions.paddingSmall),
                  child: FilterChip(
                    selected: _selectedPoet.isEmpty,
                    onSelected: (selected) {
                      setState(() {
                        _selectedPoet = '';
                      });
                      favoritesNotifier?.clearPoetFilter();
                    },
                    label: Text(AppLocalizations.of(context)!.allPoets),
                    backgroundColor: Colors.grey[200],
                    selectedColor: theme.primaryColor,
                    labelStyle: TextStyle(
                      color: _selectedPoet.isEmpty ? Colors.white : theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              
              final poet = poetNames[index - 1];
              return Padding(
                padding: const EdgeInsets.only(right: AppDimensions.paddingSmall),
                child: FilterChip(
                  selected: _selectedPoet == poet,
                  onSelected: (selected) {
                    setState(() {
                      _selectedPoet = selected ? poet : '';
                    });
                    if (selected) {
                      favoritesNotifier?.filterByPoet(poet);
                    } else {
                      favoritesNotifier?.clearPoetFilter();
                    }
                  },
                  label: Text(poet),
                  backgroundColor: Colors.grey[200],
                  selectedColor: theme.primaryColor,
                  labelStyle: TextStyle(
                    color: _selectedPoet == poet ? Colors.white : theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFavoritesList(BuildContext context, ThemeData theme) {
    return Consumer(
      builder: (context, ref, child) {
        if (favoritesState?.isLoading ?? true) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingLarge),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (favoritesState?.isEmpty ?? true) {
          return _buildEmptyState(context, theme);
        }

        if (favoritesState?.isSearchEmpty() ?? true) {
          return _buildNoSearchResults(context, theme);
        }

        final favorites = favoritesState?.filteredFavorites ?? [];
        
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final favorite = favorites[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                  vertical: AppDimensions.paddingSmall,
                ),
                child: _buildFavoriteItem(context, favorite, index),
              );
            },
            childCount: favorites.length,
          ),
        );
      },
    );
  }

  Widget _buildFavoriteItem(BuildContext context, Favorite favorite, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: OpenContainer(
              transitionType: ContainerTransitionType.fadeThrough,
              openBuilder: (context, action) {
                final poem = Poem(
                  id: favorite.poemId,
                  title: favorite.poemTitle,
                  plainText: favorite.poemText,
                  htmlText: favorite.poemText,
                  poetName: favorite.poetName,
                  poetId: favorite.poetId,
                  categoryName: favorite.categoryName,
                  categoryId: 0,
                  poemUrl: favorite.poemUrl,
                  verses: favorite.poemText.split('\n').where((line) => line.trim().isNotEmpty).toList(),
                );
                return PoemDetailScreen(poem: poem);
              },
              closedBuilder: (context, action) {
                return Dismissible(
                  key: ValueKey(favorite.poemId),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) => _confirmDelete(context, favorite),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppDimensions.paddingLarge),
                    decoration: BoxDecoration(
                      color: AppColors.errorColor,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: AppDimensions.iconSizeLarge,
                    ),
                  ),
                  child: _buildFavoriteCard(context, favorite),
                );
              },
              closedElevation: AppDimensions.elevationMedium,
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteCard(BuildContext context, Favorite favorite) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: AppDimensions.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      ),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        favorite.poemTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppDimensions.marginSmall),
                      Text(
                        favorite.poetName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.favorite,
                  color: AppColors.favoriteColor,
                  size: AppDimensions.iconSizeLarge,
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.marginMedium),
            Text(
              favorite.firstLine,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.marginSmall),
            Text(
              _formatDate(favorite.dateAdded),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingExtraLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppDimensions.marginLarge),
            Text(
              AppLocalizations.of(context)!.noFavorites,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.marginMedium),
            Text(
              AppLocalizations.of(context)!.noFavoritesDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.marginExtraLarge),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: Text(AppLocalizations.of(context)!.backToHome),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLarge,
                  vertical: AppDimensions.paddingMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoSearchResults(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingExtraLarge),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppDimensions.marginLarge),
            Text(
              AppLocalizations.of(context)!.noSearchResults,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppDimensions.marginMedium),
            Text(
              AppLocalizations.of(context)!.changeSearchOrFilter,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLarge),
        ),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            return Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLarge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.sort,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.marginLarge),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: Text(AppLocalizations.of(context)!.newest),
                    trailing: favoritesState?.sortType == FavoritesSortType.dateNewest
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      favoritesNotifier?.setSortType(FavoritesSortType.dateNewest);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: Text(AppLocalizations.of(context)!.oldest),
                    trailing: favoritesState?.sortType == FavoritesSortType.dateOldest
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      favoritesNotifier?.setSortType(FavoritesSortType.dateOldest);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(AppLocalizations.of(context)!.poetName),
                    trailing: favoritesState?.sortType == FavoritesSortType.poetName
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      favoritesNotifier?.setSortType(FavoritesSortType.poetName);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.title),
                    title: Text(AppLocalizations.of(context)!.poemTitle),
                    trailing: favoritesState?.sortType == FavoritesSortType.poemTitle
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      favoritesNotifier?.setSortType(FavoritesSortType.poemTitle);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'clear_all':
        _showClearAllDialog(context);
        break;
      case 'export':
        _exportFavorites(context);
        break;
    }
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteAllFavorites),
        content: Text(AppLocalizations.of(context)!.deleteAllConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              final favoritesNotifier = ref.read(favoritesProvider.notifier);
              favoritesNotifier.clearAllFavorites();
            },
            child: Text(AppLocalizations.of(context)!.deleteAll),
          ),
        ],
      ),
    );
  }

  void _exportFavorites(BuildContext context) {
    final favoritesNotifier = ref.read(favoritesProvider.notifier);
    favoritesNotifier.exportFavorites();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.favoritesExported),
        backgroundColor: AppColors.successColor,
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Favorite favorite) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.removeFromFavorites),
        content: Text(AppLocalizations.of(context)!.removeFromFavoritesConfirmation(favorite.poemTitle)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              final favoritesNotifier = ref.read(favoritesProvider.notifier);
              favoritesNotifier.removeFromFavorites(favorite.poemId);
            },
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    ) ?? false;
  }

  String _formatDate(DateTime date) {
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }
}