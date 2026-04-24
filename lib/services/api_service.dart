import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/movie.dart';

class ApiService {
  static const String _apiKey = '809c422a7e76b3a843149a37e9036e3e';
  static const String _baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String backdropBaseUrl = 'https://image.tmdb.org/t/p/w780';

  Future<List<Movie>> fetchMovies(String category) async {
    final uri = Uri.parse(
      '$_baseUrl/movie/$category?api_key=$_apiKey&language=en-US&page=1',
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('API error: ${response.statusCode}');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final uri = Uri.parse(
      '$_baseUrl/search/movie?api_key=$_apiKey&language=en-US'
      '&query=${Uri.encodeComponent(query)}&page=1',
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Search error: ${response.statusCode}');
    }
  }
}
