import 'package:flutter/material.dart';
import 'package:newsapp_final/screens/article%20Details%20Screen.dart';
import '../services/auth_service.dart';
import '../services/news_service.dart'; // Import the NewsService
import '../models/article.dart'; // Import the Article model class
import 'auth_screen.dart';
// import 'article_details_screen.dart'; // Import the Article Details Screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();
  final List<String> _categories = [
    'general',
    'technology',
    'sports',
    'business',
    'health',
    'entertainment',
    'science',
  ];

  String _selectedCategory = 'general';
  late Future<NewsApi> _newsApi;

  @override
  void initState() {
    super.initState();
    _fetchNewsByCategory(_selectedCategory); // Fetch news on initialization
  }

  void _fetchNewsByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _newsApi = _newsService.fetchNews(category: category); // Fetch news for the selected category
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Welcome, ${user?.email ?? 'Guest'}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await AuthService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizontal category selector
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedCategory == category
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    onPressed: () => _fetchNewsByCategory(category),
                    child: Text(
                      category[0].toUpperCase() + category.substring(1),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          // News articles list
          Expanded(
            child: FutureBuilder<NewsApi>(
              future: _newsApi,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final newsApi = snapshot.data!;
                  if (newsApi.articles.isEmpty) {
                    return Center(child: Text('No articles available.'));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: newsApi.articles.length,
                    itemBuilder: (context, index) {
                      final article = newsApi.articles[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ArticleDetailsScreen(article: article),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (article.urlToImage != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  child: Image.network(
                                    article.urlToImage!,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      article.description ?? 'No description',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Published on: ${article.publishedAt.toLocal()}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No news available.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
