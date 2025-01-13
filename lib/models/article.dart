class NewsApi {
  String status;
  int totalResults;
  List<Article> articles;

  NewsApi({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsApi.fromJson(Map<String, dynamic> json) {
    return NewsApi(
      status: json['status'] ?? '',  // Default to empty string if null
      totalResults: json['totalResults'] ?? 0,  // Default to 0 if null
      articles: (json['articles'] as List)
          .map((article) => Article.fromJson(article))
          .toList(),
    );
  }
}

class Article {
  Source source;
  String? author;
  String title;
  String? description;
  String url;
  String? urlToImage;
  DateTime publishedAt;
  String content;

  Article({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      author: json['author'] as String?,
      title: json['title'] ?? 'No Title',  // Default to 'No Title' if null
      description: json['description'] as String?,
      url: json['url'] ?? '',  // Default to empty string if null
      urlToImage: json['urlToImage'] as String?,
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toIso8601String()),
      content: json['content'] ?? '',  // Default to empty string if null
    );
  }
}

class Source {
  String? id;
  String name;

  Source({
    this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] as String?,
      name: json['name'] ?? 'Unknown',  // Default to 'Unknown' if null
    );
  }
}
