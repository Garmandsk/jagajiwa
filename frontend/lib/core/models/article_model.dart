class Article{
  final String knowledge_article_id;
  final DateTime created_at;
  final String title;
  final String subtitle;
  final int read_time;
  final String content;
  final int category;
  final String? image_url;

  Article({
    required this.knowledge_article_id,
    required this.created_at,
    required this.title,
    required this.subtitle,
    required this.read_time,
    required this.content,
    required this.category,
    this.image_url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      knowledge_article_id: json['knowledge_article_id'],
      created_at: DateTime.parse(json['created_at']),
      title: json['title'] ?? 'Tanpa Judul',    
      subtitle: json['subtitle'],
      read_time: json['read_time'],
      content: json['content'],
      category: json['category'],
      image_url: json['image_url'] ?? ''
    );
  }
}