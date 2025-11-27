import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../model/forum_model.dart';

class ForumProvider with ChangeNotifier {
  final List<ForumPost> _posts = [];

  List<ForumPost> get posts => _posts.reversed.toList();

  // Add post
  void addPost(String content) {
    _posts.add(
      ForumPost(
        id: const Uuid().v4(),
        content: content,
        createdAt: DateTime.now(),
        comments: [],
      ),
    );
    notifyListeners();
  }

  // Like Post
  void toggleLikePost(String id) {
    final post = _posts.firstWhere((e) => e.id == id);
    if (post.isLiked) {
      post.likes--;
      post.isLiked = false;
    } else {
      post.likes++;
      post.isLiked = true;
    }
    notifyListeners();
  }

  // Add comment to post
  void addComment(String postId, String text) {
    final post = _posts.firstWhere((e) => e.id == postId);
    post.comments.add(
      ForumComment(
        id: const Uuid().v4(),
        content: text,
        createdAt: DateTime.now(),
        replies: [],
      ),
    );
    notifyListeners();
  }

  // Add reply to comment
  void addReply(String postId, String commentId, String text) {
    final post = _posts.firstWhere((e) => e.id == postId);
    final comment = post.comments.firstWhere((c) => c.id == commentId);

    comment.replies.add(
      ForumComment(
        id: const Uuid().v4(),
        content: text,
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  // Like comment
  void toggleLikeComment(String postId, String commentId) {
    final post = _posts.firstWhere((e) => e.id == postId);
    final comment = post.comments.firstWhere((e) => e.id == commentId);

    if (comment.isLiked) {
      comment.likes--;
      comment.isLiked = false;
    } else {
      comment.likes++;
      comment.isLiked = true;
    }
    notifyListeners();
  }

  // Like reply
  void toggleLikeReply(String postId, String commentId, String replyId) {
    final post = _posts.firstWhere((e) => e.id == postId);
    final comment = post.comments.firstWhere((e) => e.id == commentId);
    final reply = comment.replies.firstWhere((e) => e.id == replyId);

    if (reply.isLiked) {
      reply.likes--;
      reply.isLiked = false;
    } else {
      reply.likes++;
      reply.isLiked = true;
    }
    notifyListeners();
  }
}
