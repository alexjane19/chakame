import 'package:hive_flutter/hive_flutter.dart';
import '../models/poem_model.dart';
import '../models/favorite_model.dart';
import '../models/poet_model.dart';

class StorageService {
  static const String _poemsBox = 'poems';
  static const String _favoritesBox = 'favorites';
  static const String _poetsBox = 'poets';
  static const String _settingsBox = 'settings';
  
  static StorageService? _instance;
  static StorageService get instance => _instance ??= StorageService._internal();
  
  StorageService._internal();

  static Future<void> init() async {
    await Hive.initFlutter();
    
    Hive.registerAdapter(PoemAdapter());
    Hive.registerAdapter(FavoriteAdapter());
    Hive.registerAdapter(PoetAdapter());
    
    await Hive.openBox<Poem>(_poemsBox);
    await Hive.openBox<Favorite>(_favoritesBox);
    await Hive.openBox<Poet>(_poetsBox);
    await Hive.openBox(_settingsBox);
  }

  Box<Poem> get _poems => Hive.box<Poem>(_poemsBox);
  Box<Favorite> get _favorites => Hive.box<Favorite>(_favoritesBox);
  Box<Poet> get _poets => Hive.box<Poet>(_poetsBox);
  Box get _settings => Hive.box(_settingsBox);

  Future<void> cachePoem(Poem poem) async {
    await _poems.put(poem.id, poem);
  }

  Future<void> cachePoemList(List<Poem> poems) async {
    final Map<int, Poem> poemsMap = {
      for (var poem in poems) poem.id: poem
    };
    await _poems.putAll(poemsMap);
  }

  List<Poem> getCachedPoems() {
    return _poems.values.toList();
  }

  Poem? getCachedPoemById(int id) {
    return _poems.get(id);
  }

  Future<void> clearPoemCache() async {
    await _poems.clear();
  }

  Future<void> addToFavorites(Poem poem) async {
    final favorite = Favorite.fromPoem(poem);
    await _favorites.put(poem.id, favorite);
  }

  Future<void> removeFromFavorites(int poemId) async {
    await _favorites.delete(poemId);
  }

  bool isFavorite(int poemId) {
    return _favorites.containsKey(poemId);
  }

  List<Favorite> getFavorites() {
    return _favorites.values.toList();
  }

  List<Favorite> searchFavorites(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _favorites.values.where((favorite) {
      return favorite.poemTitle.toLowerCase().contains(lowercaseQuery) ||
             favorite.poetName.toLowerCase().contains(lowercaseQuery) ||
             favorite.poemText.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  List<Favorite> getFavoritesByPoet(String poetName) {
    return _favorites.values.where((favorite) => 
        favorite.poetName.toLowerCase().contains(poetName.toLowerCase())).toList();
  }

  List<Favorite> getFavoritesSortedByDate({bool ascending = false}) {
    final favorites = getFavorites();
    favorites.sort((a, b) => ascending 
        ? a.dateAdded.compareTo(b.dateAdded)
        : b.dateAdded.compareTo(a.dateAdded));
    return favorites;
  }

  List<Favorite> getFavoritesSortedByPoet() {
    final favorites = getFavorites();
    favorites.sort((a, b) => a.poetName.compareTo(b.poetName));
    return favorites;
  }

  int getFavoritesCount() {
    return _favorites.length;
  }

  Future<void> clearFavorites() async {
    await _favorites.clear();
  }

  Future<void> cachePoets(List<Poet> poets) async {
    final Map<int, Poet> poetsMap = {
      for (var poet in poets) poet.id: poet
    };
    await _poets.putAll(poetsMap);
  }

  List<Poet> getCachedPoets() {
    return _poets.values.toList();
  }

  Poet? getCachedPoetById(int id) {
    return _poets.get(id);
  }

  Future<void> clearPoetsCache() async {
    await _poets.clear();
  }

  Future<void> setSetting(String key, dynamic value) async {
    await _settings.put(key, value);
  }

  T? getSetting<T>(String key, {T? defaultValue}) {
    return _settings.get(key, defaultValue: defaultValue) as T?;
  }

  bool getNotificationsEnabled() {
    return getSetting<bool>('notifications_enabled', defaultValue: true) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await setSetting('notifications_enabled', enabled);
  }

  String getNotificationTime() {
    return getSetting<String>('notification_time', defaultValue: '09:00') ?? '09:00';
  }

  Future<void> setNotificationTime(String time) async {
    await setSetting('notification_time', time);
  }

  bool getDarkMode() {
    return getSetting<bool>('dark_mode', defaultValue: false) ?? false;
  }

  Future<void> setDarkMode(bool enabled) async {
    await setSetting('dark_mode', enabled);
  }

  String getSelectedFont() {
    return getSetting<String>('selected_font', defaultValue: 'IranSans') ?? 'IranSans';
  }

  Future<void> setSelectedFont(String font) async {
    await setSetting('selected_font', font);
  }

  String getSelectedLanguage() {
    return getSetting<String>('selected_language', defaultValue: 'fa') ?? 'fa';
  }

  Future<void> setSelectedLanguage(String language) async {
    await setSetting('selected_language', language);
  }

  DateTime? getLastRandomPoemDate() {
    final timestamp = getSetting<int>('last_random_poem_date');
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  Future<void> setLastRandomPoemDate(DateTime date) async {
    await setSetting('last_random_poem_date', date.millisecondsSinceEpoch);
  }

  Poem? getLastRandomPoem() {
    final poemId = getSetting<int>('last_random_poem_id');
    return poemId != null ? getCachedPoemById(poemId) : null;
  }

  Future<void> setLastRandomPoem(Poem poem) async {
    await setSetting('last_random_poem_id', poem.id);
    await cachePoem(poem);
  }

  Future<void> clearAllData() async {
    await _poems.clear();
    await _favorites.clear();
    await _poets.clear();
    await _settings.clear();
  }

  Future<void> exportFavorites() async {
    final favorites = getFavorites();
    final jsonString = favorites.map((f) => f.toJson()).toList().toString();
    await setSetting('favorites_export', jsonString);
  }

  Map<String, dynamic> getStorageStats() {
    return {
      'cached_poems': _poems.length,
      'favorites_count': _favorites.length,
      'cached_poets': _poets.length,
      'settings_count': _settings.length,
    };
  }

  static Future<void> dispose() async {
    await Hive.close();
  }
}