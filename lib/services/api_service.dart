import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/poem_model.dart';
import '../models/poet_model.dart';
import '../models/ganjoor_response.dart';
import '../utils/constants.dart';

class ApiService {
  static const String baseUrl = 'https://api.ganjoor.net/api/ganjoor';
  static const Duration timeoutDuration = Duration(seconds: 15);
  
  final http.Client _client;
  final Random _random = Random();

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<bool> hasInternetConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  Future<List<Poet>> getAllPoets() async {
    try {
      if (!await hasInternetConnection()) {
        throw ApiException('No internet connection', ApiErrorType.noConnection);
      }

      final response = await _client
          .get(Uri.parse('$baseUrl/poets'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Poet.fromJson(json)).toList();
      } else {
        throw ApiException('Error fetching poets', ApiErrorType.serverError);
      }
    } on SocketException {
      throw ApiException('No internet connection', ApiErrorType.noConnection);
    } on http.ClientException {
      throw ApiException('Server connection error', ApiErrorType.networkError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error', ApiErrorType.unknown);
    }
  }

  Future<Poem> getRandomPoem() async {
    try {
      if (!await hasInternetConnection()) {
        throw ApiException('No internet connection', ApiErrorType.noConnection);
      }

      final poets = await getAllPoets();
      final publishedPoets = poets.where((poet) => poet.published).toList();

      if (publishedPoets.isEmpty) {
        throw ApiException('No poets found', ApiErrorType.noData);
      }

      final randomPoet = publishedPoets[_random.nextInt(publishedPoets.length)];
      return await getRandomPoemFromPoet(randomPoet.id);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error fetching random poem', ApiErrorType.unknown);
    }
  }

  Future<Poem> getRandomPoemFromPoet(int poetId) async {
    try {
      if (!await hasInternetConnection()) {
        throw ApiException('No internet connection', ApiErrorType.noConnection);
      }

      final response = await _client
          .get(Uri.parse('$baseUrl/poem/random?poetId=$poetId'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final ganjoorResponse = GanjoorPoemResponse.fromJson(jsonData);
        return ganjoorResponse.toPoem();
      } else if (response.statusCode == 404) {
        throw ApiException('No poem found for this poet', ApiErrorType.notFound);
      } else {
        throw ApiException('Error fetching poem', ApiErrorType.serverError);
      }
    } on SocketException {
      throw ApiException('No internet connection', ApiErrorType.noConnection);
    } on http.ClientException {
      throw ApiException('Server connection error', ApiErrorType.networkError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error', ApiErrorType.unknown);
    }
  }

  Future<List<Poem>> getPoemsByPoet(int poetId, {int page = 1, int pageSize = 20}) async {
    try {
      if (!await hasInternetConnection()) {
        throw ApiException('No internet connection', ApiErrorType.noConnection);
      }

      final response = await _client
          .get(Uri.parse('$baseUrl/poet/$poetId/poems?page=$page&pageSize=$pageSize'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Poem.fromJson(json)).toList();
      } else {
        throw ApiException('Error fetching poems', ApiErrorType.serverError);
      }
    } on SocketException {
      throw ApiException('No internet connection', ApiErrorType.noConnection);
    } on http.ClientException {
      throw ApiException('Server connection error', ApiErrorType.networkError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error', ApiErrorType.unknown);
    }
  }

  Future<Poem> getPoemById(int poemId) async {
    try {
      if (!await hasInternetConnection()) {
        throw ApiException('No internet connection', ApiErrorType.noConnection);
      }

      final response = await _client
          .get(Uri.parse('$baseUrl/poem/$poemId'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final ganjoorResponse = GanjoorPoemResponse.fromJson(jsonData);
        return ganjoorResponse.toPoem();
      } else if (response.statusCode == 404) {
        throw ApiException('Poem not found', ApiErrorType.notFound);
      } else {
        throw ApiException('Error fetching poem', ApiErrorType.serverError);
      }
    } on SocketException {
      throw ApiException('No internet connection', ApiErrorType.noConnection);
    } on http.ClientException {
      throw ApiException('Server connection error', ApiErrorType.networkError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error', ApiErrorType.unknown);
    }
  }

  Future<List<Poem>> searchPoems(String query, {int page = 1, int pageSize = 20}) async {
    try {
      if (!await hasInternetConnection()) {
        throw ApiException('No internet connection', ApiErrorType.noConnection);
      }

      final encodedQuery = Uri.encodeComponent(query);
      final response = await _client
          .get(Uri.parse('$baseUrl/poems/search?term=$encodedQuery&page=$page&pageSize=$pageSize'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Poem.fromJson(json)).toList();
      } else {
        throw ApiException('Error searching poems', ApiErrorType.serverError);
      }
    } on SocketException {
      throw ApiException('No internet connection', ApiErrorType.noConnection);
    } on http.ClientException {
      throw ApiException('Server connection error', ApiErrorType.networkError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error', ApiErrorType.unknown);
    }
  }

  Future<Poet> getPoetById(int poetId) async {
    try {
      if (!await hasInternetConnection()) {
        throw ApiException('No internet connection', ApiErrorType.noConnection);
      }

      final response = await _client
          .get(Uri.parse('$baseUrl/poet/$poetId'))
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Poet.fromJson(jsonData['poet']);
      } else if (response.statusCode == 404) {
        throw ApiException('Poet not found', ApiErrorType.notFound);
      } else {
        throw ApiException('Error fetching poet information', ApiErrorType.serverError);
      }
    } on SocketException {
      throw ApiException('No internet connection', ApiErrorType.noConnection);
    } on http.ClientException {
      throw ApiException('Server connection error', ApiErrorType.networkError);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error', ApiErrorType.unknown);
    }
  }

  void dispose() {
    _client.close();
  }
}

enum ApiErrorType {
  noConnection,
  networkError,
  serverError,
  notFound,
  noData,
  unknown,
}

class ApiException implements Exception {
  final String message;
  final ApiErrorType type;

  ApiException(this.message, this.type);

  @override
  String toString() => 'ApiException: $message (Type: $type)';
}