class Source {
  String id, name;
  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json["id"] as String,
      name: json["name"] as String,
    );
  }
}

class Article {
  Source source;
  String author, title, description, url, image, publishedAt, content;
  Article(
      {this.source,
      this.author,
      this.title,
      this.description,
      this.url,
      this.image,
      this.publishedAt,
      this.content});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        source: Source.fromJson(json["source"]),
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        image: json["urlToImage"],
        publishedAt: json["publishedAt"],
        content: json["content"]);
  }
}
