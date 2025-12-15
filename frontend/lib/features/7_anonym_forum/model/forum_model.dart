
class Comment {
  final String id;
  final String author; // anonymous name
  final String content;
  final DateTime createdAt;
  final List<Comment> replies;
  bool isLiked; // ✅ tambahkan

  Comment({
    required this.id,
    required this.author,
    required this.content,
    this.isLiked = false, // ✅ default false
    DateTime? createdAt,
    List<Comment>? replies,
  })  : createdAt = createdAt ?? DateTime.now(),
        replies = replies ?? [];
}


class Post {
  final String id;
  final String author; // anonymous handle
  String content;
  int likes;
  final DateTime createdAt;
  final List<Comment> comments;
  bool isLiked;

  Post({
    required this.id,
    required this.author,
    required this.content,
    this.likes = 0,
    this.isLiked = false,
    DateTime? createdAt,
    List<Comment>? comments,
  })  : createdAt = createdAt ?? DateTime.now(),
        comments = comments ?? [];
}
