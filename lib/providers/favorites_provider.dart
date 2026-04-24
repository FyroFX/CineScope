import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
 
class FavoritesProvider extends ChangeNotifier {
  static const String _key = 'favorites';
 
  List<Movie> _favorites = [];
 
  List<Movie> get favorites => List.unmodifiable(_favorites);
 
  bool isFavorite(int movieId) =>
      _favorites.any((m) => m.id == movieId);
 
  /// Load favorites from SharedPreferences on startup.
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    _favorites = data.map((s) => Movie.fromJson(jsonDecode(s))).toList();
    notifyListeners();
  }
 
  /// Toggle a movie in/out of favorites and persist.
  Future<void> toggleFavorite(Movie movie) async {
    if (isFavorite(movie.id)) {
      _favorites.removeWhere((m) => m.id == movie.id);
    } else {
      _favorites.insert(0, movie);
    }
    await _persist();
    notifyListeners();
  }
 
  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _favorites.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(_key, data);
  }
}