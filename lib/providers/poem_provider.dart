import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/poem_model.dart';
import '../models/poet_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

// Poem state class
class PoemState {
  final Poem? currentPoem;
  final List<Poem> poems;
  final List<Poet> poets;
  final bool isLoading;
  final String? error;
  final bool isLoadingPoets;
  final String? poetsError;

  const PoemState({
    required this.currentPoem,
    required this.poems,
    required this.poets,
    required this.isLoading,
    required this.error,
    required this.isLoadingPoets,
    required this.poetsError,
  });

  PoemState copyWith({
    Poem? currentPoem,
    List<Poem>? poems,
    List<Poet>? poets,
    bool? isLoading,
    String? error,
    bool? isLoadingPoets,
    String? poetsError,
  }) {
    return PoemState(
      currentPoem: currentPoem ?? this.currentPoem,
      poems: poems ?? this.poems,
      poets: poets ?? this.poets,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isLoadingPoets: isLoadingPoets ?? this.isLoadingPoets,
      poetsError: poetsError ?? this.poetsError,
    );
  }

  PoemState clearError() {
    return copyWith(error: null);
  }

  PoemState clearPoetsError() {
    return copyWith(poetsError: null);
  }

  PoemState clearCurrentPoem() {
    return copyWith(currentPoem: null);
  }

  PoemState clearPoems() {
    return copyWith(poems: []);
  }
}

// Poem StateNotifier
class PoemNotifier extends StateNotifier<PoemState> {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService.instance;

  PoemNotifier() : super(const PoemState(
    currentPoem: null,
    poems: [],
    poets: [],
    isLoading: false,
    error: null,
    isLoadingPoets: false,
    poetsError: null,
  ));

  Future<void> loadRandomPoem() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      var poem = await _apiService.getRandomPoem();
      final poet = await _apiService.getPoetById(poem.poetId);
      poem = poem.copyWith(poetName: poet.name);
      state = state.copyWith(
        currentPoem: poem,
        isLoading: false,
        error: null,
      );
      await _storageService.cachePoem(poem);
      await _storageService.setLastRandomPoem(poem);
    } catch (e) {
      final cachedPoem = _storageService.getLastRandomPoem();
      if (cachedPoem != null) {
        state = state.copyWith(
          currentPoem: cachedPoem,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> loadRandomPoemFromPoet(int poetId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      var poem = await _apiService.getRandomPoemFromPoet(poetId);
      final poet = await _apiService.getPoetById(poem.poetId);
      poem = poem.copyWith(poetName: poet.name);
      state = state.copyWith(
        currentPoem: poem,
        isLoading: false,
        error: null,
      );
      await _storageService.cachePoem(poem);
    } catch (e) {
      final cachedPoems = _storageService.getCachedPoems()
          .where((p) => p.poetId == poetId)
          .toList();
      
      if (cachedPoems.isNotEmpty) {
        state = state.copyWith(
          currentPoem: cachedPoems.first,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> loadPoemById(int poemId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final cachedPoem = _storageService.getCachedPoemById(poemId);
      if (cachedPoem != null) {
        state = state.copyWith(
          currentPoem: cachedPoem,
          isLoading: false,
          error: null,
        );
        return;
      }

      final poem = await _apiService.getPoemById(poemId);
      state = state.copyWith(
        currentPoem: poem,
        isLoading: false,
        error: null,
      );
      await _storageService.cachePoem(poem);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadPoemsByPoet(int poetId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final poems = await _apiService.getPoemsByPoet(poetId);
      state = state.copyWith(
        poems: poems,
        isLoading: false,
        error: null,
      );
      await _storageService.cachePoemList(poems);
    } catch (e) {
      final cachedPoems = _storageService.getCachedPoems()
          .where((p) => p.poetId == poetId)
          .toList();
      
      if (cachedPoems.isNotEmpty) {
        state = state.copyWith(
          poems: cachedPoems,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> searchPoems(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(poems: []);
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final poems = await _apiService.searchPoems(query);
      state = state.copyWith(
        poems: poems,
        isLoading: false,
        error: null,
      );
      await _storageService.cachePoemList(poems);
    } catch (e) {
      final cachedPoems = _storageService.getCachedPoems()
          .where((p) => 
              p.title.toLowerCase().contains(query.toLowerCase()) ||
              p.plainText.toLowerCase().contains(query.toLowerCase()) ||
              p.poetName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      
      if (cachedPoems.isNotEmpty) {
        state = state.copyWith(
          poems: cachedPoems,
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  Future<void> loadPoets() async {
    state = state.copyWith(isLoadingPoets: true, poetsError: null);

    try {
      final cachedPoets = _storageService.getCachedPoets();
      if (cachedPoets.isNotEmpty) {
        state = state.copyWith(
          poets: cachedPoets,
          isLoadingPoets: false,
        );
      }

      final poets = await _apiService.getAllPoets();
      state = state.copyWith(
        poets: poets,
        isLoadingPoets: false,
        poetsError: null,
      );
      await _storageService.cachePoets(poets);
    } catch (e) {
      final cachedPoets = _storageService.getCachedPoets();
      if (cachedPoets.isNotEmpty) {
        state = state.copyWith(
          poets: cachedPoets,
          isLoadingPoets: false,
          poetsError: null,
        );
      } else {
        state = state.copyWith(
          isLoadingPoets: false,
          poetsError: e.toString(),
        );
      }
    }
  }

  void clearCurrentPoem() {
    state = state.clearCurrentPoem();
  }

  void clearPoems() {
    state = state.clearPoems();
  }

  void clearError() {
    state = state.clearError();
  }

  void clearPoetsError() {
    state = state.clearPoetsError();
  }

  List<Poem> getCachedPoems() {
    return _storageService.getCachedPoems();
  }

  Poet? getPoetById(int poetId) {
    try {
      return state.poets.firstWhere((poet) => poet.id == poetId);
    } catch (e) {
      return null;
    }
  }

  List<Poet> getPublishedPoets() {
    return state.poets.where((poet) => poet.published).toList();
  }

  Future<Poet> getRandomPoet() async{
    final poets = state.poets.where((poet) => poet.published).toList();
    final randomizedPoets = List.of(poets)..shuffle();
    final poet = randomizedPoets.first;
    final randomPoet = await _apiService.getPoetById(poet.id);
    return randomPoet;
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }
}

// Poem provider
final poemProvider = StateNotifierProvider<PoemNotifier, PoemState>((ref) {
  return PoemNotifier();
});