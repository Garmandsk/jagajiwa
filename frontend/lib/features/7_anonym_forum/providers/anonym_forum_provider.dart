import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/forum_model.dart';

class AnonymForumProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  
  List<Post> _posts = [];
  List<Post> get posts => List.unmodifiable(_posts);
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- FUNGSI UTAMA: LOAD POSTS ---
  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _supabase.auth.currentUser?.id;
      print('Fetching posts for user: $userId');

      // 1. Ambil Data Post
      final response = await _supabase
          .from('forum_posts')
          .select('*, forum_likes(*), forum_comments(*)') // Join manual sederhana
          .order('created_at', ascending: false);

      final List<Post> loadedPosts = [];

      for (var item in response) {
        // Hitung Likes secara manual dari array join
        final List likesList = item['forum_likes'] ?? [];
        final int likeCount = likesList.length;
        
        // Cek apakah user login ada di daftar likes
        bool isLikedByMe = false;
        if (userId != null) {
          isLikedByMe = likesList.any((like) => like['user_id'] == userId);
        }

        // Parse Post
        final post = Post.fromJson(
          item, 
          likeCount: likeCount, 
          likedByMe: isLikedByMe
        );

        // 2. Proses Komentar (Flat List -> Nested List)
        final List commentsList = item['forum_comments'] ?? [];
        // Urutkan biar komentar lama di atas
        commentsList.sort((a, b) => a['created_at'].compareTo(b['created_at'])); 
        
        final Map<String, Comment> commentMap = {};
        final List<Comment> rootComments = [];

        // Step A: Ubah semua jadi Object Comment
        for (var cData in commentsList) {
          final c = Comment.fromJson(cData);
          commentMap[c.id] = c;
        }

        // Step B: Susun Hierarchy (Parent -> Child)
        for (var c in commentMap.values) {
          if (c.parentId == null) {
            rootComments.add(c); // Komentar utama
          } else {
            // Ini adalah balasan, masukkan ke replies parent-nya
            if (commentMap.containsKey(c.parentId)) {
              commentMap[c.parentId]!.replies.add(c);
            }
          }
        }
        
        // Masukkan comments yang sudah rapi ke Post
        post.comments.addAll(rootComments);
        loadedPosts.add(post);
      }

      _posts = loadedPosts;
      
    } catch (e) {
      debugPrint('Error fetching posts: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // --- CREATE POST ---
  Future<void> createPost(String content) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      // 1. Ambil Anoname dari tabel profiles (sesuai setup sebelumnya)
      final profileRes = await _supabase
          .from('profiles')
          .select('anoname')
          .eq('id', user.id)
          .single();
          
      final String myAnoname = profileRes['anoname'] ?? 'Anonim';

      // 2. Insert ke forum_posts
      await _supabase.from('forum_posts').insert({
        'user_id': user.id,
        'anoname': myAnoname,
        'content': content,
      });

      // 3. Refresh data agar UI update
      await fetchPosts();

    } catch (e) {
      debugPrint('Error creating post: $e');
    }
  }

  // --- TOGGLE LIKE ---
  Future<void> toggleLike(String postId) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    // Cari post di local list untuk update UI instan (Optimistic Update)
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx != -1) {
      final p = _posts[idx];
      if (p.isLiked) {
        p.likes--; 
        p.isLiked = false;
        // Hapus dari DB
        await _supabase.from('forum_likes').delete().match({
          'user_id': user.id,
          'post_id': postId
        });
      } else {
        p.likes++;
        p.isLiked = true;
        // Tambah ke DB
        await _supabase.from('forum_likes').insert({
          'user_id': user.id,
          'post_id': postId
        });
      }
      notifyListeners();
    }
  }

  // --- ADD COMMENT / REPLY ---
  Future<void> addComment(String postId, String content, {String? parentId}) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      // Ambil Anoname lagi (bisa dioptimasi disimpan di variabel provider sih)
      final profileRes = await _supabase.from('profiles').select('anoname').eq('profile_id', user.id).single();
      final String myAnoname = profileRes['anoname'] ?? 'Anonim';

      await _supabase.from('forum_comments').insert({
        'post_id': postId,
        'parent_id': parentId, // NULL jika komentar utama, ISI ID jika balasan
        'user_id': user.id,
        'anoname': myAnoname,
        'content': content,
      });

      await fetchPosts(); // Refresh untuk melihat komentar baru

    } catch (e) {
      debugPrint('Error commenting: $e');
    }
  }
  
  // Wrapper agar cocok dengan UI lama yang membedakan addComment dan addReply
  // Padahal logic backendnya sama aja, beda di parentId
  Future<void> addReply(String postId, String commentId, String content) async {
    await addComment(postId, content, parentId: commentId);
  }
}