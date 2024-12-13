import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class HttpHelper {
  // Start a session with the MovieNight API
  static Future<Map<String, dynamic>> startSession(String deviceId) async {
    final response = await http.get(
      Uri.parse('$movieNightBaseUrl/start-session?device_id=$deviceId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to start session');
    }
  }

  // Join an existing session with a code
  static Future<Map<String, dynamic>> joinSession(
      String deviceId, int code) async {
    final response = await http.get(
      Uri.parse(
          '$movieNightBaseUrl/join-session?device_id=$deviceId&code=$code'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to join session');
    }
  }

  // Fetch movies from the TMDb API
  static Future<List<Map<String, dynamic>>> fetchMovies(
      String category, int page) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$category?api_key=$tmdbApiKey&page=$page'),
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body)['results'] as List)
          .map((movie) => movie as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  // Vote for a movie
  static Future<Map<String, dynamic>> voteMovie(
      String sessionId, int movieId, bool vote) async {
    final response = await http.get(
      Uri.parse(
          '$movieNightBaseUrl/vote-movie?session_id=$sessionId&movie_id=$movieId&vote=$vote'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to vote for movie');
    }
  }
}
