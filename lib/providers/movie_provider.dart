import 'package:flutter/foundation.dart';
import '../../../models/movie.dart';
import '../../../services/api_service.dart';
import '../../../services/cache_service.dart';

/// Represents the current state of the app's data loading.
enum AppStatus { initial, loading, loaded, error, offline }

class MovieProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  // ─── State ───────────────────────────────────────────────────────────────
  List<Movie> _movies = [];
  List<Movie> _searchResults = [];
  AppStatus _status = AppStatus.initial;
  String _selectedCategory = 'popular';
  String _errorMessage = '';
  bool _isOffline = false;
  bool _isSearching = false;

  // ─── Getters ──────────────────────────────────────────────────────────────
  List<Movie> get movies => _isSearching ? _searchResults : _movies;
  AppStatus get status => _status;
  String get selectedCategory => _selectedCategory;
  String get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;
  bool get isSearching => _isSearching;

  final List<Map<String, String>> categories = [
    {'key': 'popular', 'label': 'Popular'},
    {'key': 'top_rated', 'label': 'Top Rated'},
    {'key': 'upcoming', 'label': 'Upcoming'},
  ];

  // ─── Actions ──────────────────────────────────────────────────────────────

  /// Fetches movies for the selected category from the API.
  /// Falls back to cached data if network is unavailable.
  Future<void> fetchMovies({String? category}) async {
    if (category != null) _selectedCategory = category;
    _isSearching = false;
    _isOffline = false;
    _status = AppStatus.loading;
    notifyListeners();

    try {
      final movies = await _apiService.fetchMovies(_selectedCategory);
      _movies = movies;
      _status = AppStatus.loaded;
      // Persist to cache for offline use
      await _cacheService.saveMovies(_selectedCategory, movies);
    } catch (_) {
      // Network failed — try loading from cache
      final cached = await _cacheService.getMovies(_selectedCategory);
      if (cached != null && cached.isNotEmpty) {
        _movies = cached;
        _status = AppStatus.offline;
        _isOffline = true;
      } else {
        _status = AppStatus.error;
        _errorMessage =
            'No internet connection and no cached data available.\n'
            'Please connect to the internet and try again.';
      }
    }

    notifyListeners();
  }

  /// Searches movies by query string using async/await.
  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    _isSearching = true;
    _status = AppStatus.loading;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchMovies(query);
      _status = AppStatus.loaded;
    } catch (_) {
      _status = AppStatus.error;
      _errorMessage = 'Search failed. Please check your internet connection.';
    }

    notifyListeners();
  }

  /// Clears the current search and returns to the category list.
  void clearSearch() {
    _isSearching = false;
    _searchResults = [];
    _status = _movies.isNotEmpty ? AppStatus.loaded : AppStatus.initial;
    notifyListeners();
  }
}
