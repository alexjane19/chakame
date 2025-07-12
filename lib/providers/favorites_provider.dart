import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/poem_model.dart';
import '../models/favorite_model.dart';
import '../services/storage_service.dart';

enum FavoritesSortType {
  dateNewest,
  dateOldest,
  poetName,
  poemTitle,
}

// Favorites state class
class FavoritesState {
  final List<Favorite> favorites;
  final List<Favorite> filteredFavorites;
  final String searchQuery;
  final String selectedPoetFilter;
  final FavoritesSortType sortType;
  final bool isLoading;

  const FavoritesState({
    required this.favorites,
    required this.filteredFavorites,
    required this.searchQuery,
    required this.selectedPoetFilter,
    required this.sortType,
    required this.isLoading,
  });

  FavoritesState copyWith({
    List<Favorite>? favorites,
    List<Favorite>? filteredFavorites,
    String? searchQuery,
    String? selectedPoetFilter,
    FavoritesSortType? sortType,
    bool? isLoading,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      filteredFavorites: filteredFavorites ?? this.filteredFavorites,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedPoetFilter: selectedPoetFilter ?? this.selectedPoetFilter,
      sortType: sortType ?? this.sortType,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get favoritesCount => favorites.length;
  bool get isEmpty => favorites.isEmpty;
  List<Favorite> get allFavorites => favorites;

  bool hasSearchResults() {
    return searchQuery.isNotEmpty && filteredFavorites.isNotEmpty;
  }

  bool isSearchEmpty() {
    return searchQuery.isNotEmpty && filteredFavorites.isEmpty;
  }
}

// Favorites StateNotifier
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final StorageService _storageService = StorageService.instance;

  FavoritesNotifier() : super(const FavoritesState(
    favorites: [],
    filteredFavorites: [],
    searchQuery: '',
    selectedPoetFilter: '',
    sortType: FavoritesSortType.dateNewest,
    isLoading: false,
  )) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true);

    try {
      final favorites = _storageService.getFavorites();
      state = state.copyWith(
        favorites: favorites,
        isLoading: false,
      );
      _applyFiltersAndSort();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> addToFavorites(Poem poem) async {
    if (isFavorite(poem.id)) {
      return;
    }

    try {
      await _storageService.addToFavorites(poem);
      await loadFavorites();
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(int poemId) async {
    try {
      await _storageService.removeFromFavorites(poemId);
      await loadFavorites();
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
    }
  }

  Future<void> toggleFavorite(Poem poem) async {
    if (isFavorite(poem.id)) {
      await removeFromFavorites(poem.id);
    } else {
      await addToFavorites(poem);
    }
  }

  bool isFavorite(int poemId) {
    return _storageService.isFavorite(poemId);
  }

  void searchFavorites(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFiltersAndSort();
  }

  void filterByPoet(String poetName) {
    state = state.copyWith(selectedPoetFilter: poetName);
    _applyFiltersAndSort();
  }

  void clearPoetFilter() {
    state = state.copyWith(selectedPoetFilter: '');
    _applyFiltersAndSort();
  }

  void setSortType(FavoritesSortType sortType) {
    state = state.copyWith(sortType: sortType);
    _applyFiltersAndSort();
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    _applyFiltersAndSort();
  }

  void clearAllFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedPoetFilter: '',
    );
    _applyFiltersAndSort();
  }

  void _applyFiltersAndSort() {
    List<Favorite> result = List.from(state.favorites);

    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      result = result.where((favorite) {
        return favorite.poemTitle.toLowerCase().contains(query) ||
               favorite.poetName.toLowerCase().contains(query) ||
               favorite.poemText.toLowerCase().contains(query);
      }).toList();
    }

    if (state.selectedPoetFilter.isNotEmpty) {
      result = result.where((favorite) =>
          favorite.poetName.toLowerCase().contains(state.selectedPoetFilter.toLowerCase())).toList();
    }

    result.sort((a, b) {
      switch (state.sortType) {
        case FavoritesSortType.dateNewest:
          return b.dateAdded.compareTo(a.dateAdded);
        case FavoritesSortType.dateOldest:
          return a.dateAdded.compareTo(b.dateAdded);
        case FavoritesSortType.poetName:
          return a.poetName.compareTo(b.poetName);
        case FavoritesSortType.poemTitle:
          return a.poemTitle.compareTo(b.poemTitle);
      }
    });

    state = state.copyWith(filteredFavorites: result);
  }

  List<String> getUniquePoetNames() {
    final poetNames = state.favorites.map((f) => f.poetName).toSet().toList();
    poetNames.sort();
    return poetNames;
  }

  List<Favorite> getFavoritesByPoet(String poetName) {
    return state.favorites.where((f) => f.poetName == poetName).toList();
  }

  Future<void> clearAllFavorites() async {
    try {
      await _storageService.clearFavorites();
      await loadFavorites();
    } catch (e) {
      debugPrint('Error clearing favorites: $e');
    }
  }

  Future<void> exportFavorites() async {
    try {
      await _storageService.exportFavorites();
    } catch (e) {
      debugPrint('Error exporting favorites: $e');
    }
  }

  Favorite? getFavoriteById(int poemId) {
    try {
      return state.favorites.firstWhere((f) => f.poemId == poemId);
    } catch (e) {
      return null;
    }
  }

  Map<String, int> getFavoritesStatistics() {
    final stats = <String, int>{};
    
    for (final favorite in state.favorites) {
      stats[favorite.poetName] = (stats[favorite.poetName] ?? 0) + 1;
    }
    
    return stats;
  }

  List<Favorite> getRecentFavorites({int limit = 10}) {
    final recent = List<Favorite>.from(state.favorites);
    recent.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    return recent.take(limit).toList();
  }
}

// Favorites provider
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  return FavoritesNotifier();
});