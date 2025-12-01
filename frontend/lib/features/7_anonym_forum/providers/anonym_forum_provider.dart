import 'package:flutter/foundation.dart';
import '../model/forum_model.dart';
import 'dart:math';

class ForumProvider extends ChangeNotifier {
  final List<Post> _posts = [];

  List<Post> get posts => List.unmodifiable(_posts.reversed); // newest first

  final Random _rnd = Random();

  ForumProvider() {
    // dummy initial data
    _seedDummy();
  }

  void _seedDummy() {
    _posts.addAll([
      Post(
        id: 'p1',
        author: 'Kambing234',
        content:
            'Apa keluh kesah kalian tentang judi teman-teman.. aku khawatir nih. Ini cuma curhat yaa...',
        likes: 120,
        comments: [
          Comment(id: 'c1', author: 'Jeruk12', content: 'Stop judi tuh payah banget yah'),
          Comment(id: 'c2', author: 'KucingPutih23', content: 'Aku sudah 15 tahun bermain judi...'),
        ],
      ),
      Post(
        id: 'p2',
        author: 'AngsaHitam23',
        content:
            'ini isinya akwjdahskdhakwd kasbndkabwjbdajsbdb ... more',
        likes: 20,
      ),
    ]);
  }

  String _makeId(String prefix) => '\$prefix\${DateTime.now().millisecondsSinceEpoch}\${_rnd.nextInt(999)}';

  void createPost(String author, String content) {
    final p = Post(id: _makeId('p'), author: author, content: content);
    _posts.add(p);
    notifyListeners();
  }

  void toggleLike(String postId) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;
    _posts[idx].likes += 1; // simple: only increment (no unlike logic for demo)
    notifyListeners();
  }

  void addComment(String postId, String author, String content) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;
    final c = Comment(id: _makeId('c'), author: author, content: content);
    _posts[idx].comments.add(c);
    notifyListeners();
  }

  void addReply(String postId, String commentId, String author, String content) {
    final pIdx = _posts.indexWhere((p) => p.id == postId);
    if (pIdx == -1) return;
    final comments = _posts[pIdx].comments;
    final cIdx = comments.indexWhere((c) => c.id == commentId);
    if (cIdx == -1) return;
    final reply = Comment(id: _makeId('r'), author: author, content: content);
    comments[cIdx].replies.add(reply);
    notifyListeners();
  }
}
