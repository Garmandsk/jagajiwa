class Post {
  final String id;
  final String title;
  final String content;
  final String authorUsername;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorUsername,
    required this.createdAt,
  });

  // Factory constructor untuk membuat objek Post dari map/JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      authorUsername: json['authorUsername'] ?? 'Anonim',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}