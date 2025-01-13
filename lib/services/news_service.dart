import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newsapp_final/models/article.dart';

class NewsService {
  final String apiKey = '9ceeda42743f43828963b39bc7f5df51';  // Replace with your API key
  final String baseUrl = 'https://newsapi.org/v2';

  // Fetch news articles based on category
  Future<NewsApi> fetchNews({String category = 'general'}) async {
    final url = '$baseUrl/top-headlines?category=$category&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the JSON response and return a NewsApi object
        return NewsApi.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  // Fetch articles by keyword (search)
  Future<NewsApi> searchNews(String keyword) async {
    final url = '$baseUrl/everything?q=$keyword&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse the JSON response and return a NewsApi object
        return NewsApi.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to search news');
      }
    } catch (e) {
      throw Exception('Error searching news: $e');
    }
  }
}
