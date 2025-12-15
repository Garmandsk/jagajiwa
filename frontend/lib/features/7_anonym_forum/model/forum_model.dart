class Comment {
  final String id;
  final String author;
  final String content;
  final DateTime createdAt;
  final String? parentId; // Tambahan untuk logika balasan
  final List<Comment> replies;
  bool isLiked; // Disimpan di client side logic

  Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    this.parentId,
    this.isLiked = false,
    List<Comment>? replies,
  }) : replies = replies ?? [];

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      author: json['anoname'] ?? 'Anon', // Ambil dari kolom anoname
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      parentId: json['parent_id'],
      // Replies diisi nanti oleh Provider setelah sorting
    );
  }
}

class Post {
  final String id;
  final String author;
  final String content;
  int likes; // Jumlah like (diambil dari count)
  final DateTime createdAt;
  final List<Comment> comments; // Diambil terpisah nanti
  bool isLiked; // Status apakah user login sudah like

  Post({
    required this.id,
    required this.author,
    required this.content,
    this.likes = 0,
    this.isLiked = false,
    required this.createdAt,
    List<Comment>? comments,
  }) : comments = comments ?? [];

  factory Post.fromJson(Map<String, dynamic> json, {int likeCount = 0, bool likedByMe = false}) {
    return Post(
      id: json['id'],
      author: json['anoname'] ?? 'Anon',
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      likes: likeCount,
      isLiked: likedByMe,
    );
  }
}