class ForumComment {
  final String id;
  final String content;
  final DateTime createdAt;
  int likes;
  bool isLiked;
  List<ForumComment> replies;

  ForumComment({
    required this.id,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
    this.replies = const [],
  });
}

class ForumPost {
  final String id;
  final String content;
  final DateTime createdAt;
  int likes;
  bool isLiked;
  List<ForumComment> comments;

  ForumPost({
    required this.id,
    required this.content,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
    this.comments = const [],
  });
}
