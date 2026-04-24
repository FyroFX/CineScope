import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/movie.dart';

class CacheService {
  static const String _cachePrefix = 'movies_cache_';
  static const String _cacheTimestampPrefix = 'movies_timestamp_';

  /// Saves a list of movies to local cache under a given category key.
  Future<void> saveMovies(String category, List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = movies.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('$_cachePrefix$category', encoded);
    await prefs.setInt(
      '$_cacheTimestampPrefix$category',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Retrieves cached movies for a given category. Returns null if not found.
  Future<List<Movie>?> getMovies(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getStringList('$_cachePrefix$category');
    if (encoded == null || encoded.isEmpty) return null;
    return encoded.map((s) => Movie.fromJson(jsonDecode(s))).toList();
  }

  /// Returns when the cache was last updated for a category.
  Future<DateTime?> getCacheTime(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final ms = prefs.getInt('$_cacheTimestampPrefix$category');
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// Clears all cached movie data.
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where(
      (k) => k.startsWith(_cachePrefix) || k.startsWith(_cacheTimestampPrefix),
    );
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
