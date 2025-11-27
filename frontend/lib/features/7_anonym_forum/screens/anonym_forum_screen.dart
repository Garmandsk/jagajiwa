import 'package:flutter/material.dart';
import 'package:frontend/features/7_anonym_forum/providers/anonym_forum_provider.dart';
import 'package:provider/provider.dart';

class ForumListScreen extends StatefulWidget {
  const ForumListScreen({super.key});

  @override
  State<ForumListScreen> createState() => _ForumListScreenState();
}

class _ForumListScreenState extends State<ForumListScreen> {
  final Map<String, bool> expanded = {};

  @override
  Widget build(BuildContext context) {
    final forum = Provider.of<ForumProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Forum Anonim")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/forum-create'),
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: forum.posts.length,
        itemBuilder: (context, i) {
          final post = forum.posts[i];

          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.content),

                  // LIKE + KOMENTAR
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          post.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: post.isLiked ? Colors.red : null,
                        ),
                        onPressed: () {
                          forum.toggleLikePost(post.id);
                        },
                      ),
                      Text(post.likes.toString()),

                      const SizedBox(width: 12),

                      IconButton(
                        icon: const Icon(Icons.reply),
                        onPressed: () {
                          showCommentInput(context, forum, post.id);
                        },
                      ),
                      Text("${post.comments.length} komentar"),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // ============================
                  // LIST KOMENTAR
                  // ============================
                  ...post.comments.map((c) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              expanded[c.id] = !(expanded[c.id] ?? false);
                            });
                          },
                          child: Row(
                            children: [
                              Expanded(child: Text("• ${c.content}")),
                              Icon(
                                expanded[c.id] == true
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                              ),
                            ],
                          ),
                        ),

                        if (expanded[c.id] == true) ...[
                          // ================
                          // LIKE + BALAS
                          // ================
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  c.isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: c.isLiked ? Colors.red : null,
                                ),
                                onPressed: () {
                                  forum.toggleLikeComment(post.id, c.id);
                                },
                              ),
                              Text(c.likes.toString()),

                              IconButton(
                                icon: const Icon(Icons.reply),
                                onPressed: () {
                                  showReplyInput(
                                      context, forum, post.id, c.id);
                                },
                              ),
                            ],
                          ),

                          // ============================
                          // BALASAN DENGAN BATAS 1
                          // ============================
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (c.replies.isEmpty)
                                  const Text("Tidak ada balasan"),

                                if (c.replies.isNotEmpty)
                                  Row(
                                    children: [
                                      Expanded(
                                        child:
                                            Text("↳ ${c.replies.first.content}"),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          c.replies.first.isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: c.replies.first.isLiked
                                              ? Colors.red
                                              : null,
                                        ),
                                        onPressed: () {
                                          forum.toggleLikeReply(
                                            post.id,
                                            c.id,
                                            c.replies.first.id,
                                          );
                                        },
                                      ),
                                      Text(c.replies.first.likes.toString()),
                                    ],
                                  ),

                                // Jika balasan > 1 → beri info
                                if (c.replies.length > 1)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      "Lihat ${c.replies.length - 1} balasan lainnya dengan mengetuk komentar...",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),

                                // ============================
                                // Jika komentar di-expand → tampilkan SEMUA balasan
                                // ============================
                                if (expanded[c.id] == true &&
                                    c.replies.length > 1)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        c.replies.skip(1).map((reply) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                                "↳ ${reply.content}"),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              reply.isLiked
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: reply.isLiked
                                                  ? Colors.red
                                                  : null,
                                            ),
                                            onPressed: () {
                                              forum.toggleLikeReply(
                                                post.id,
                                                c.id,
                                                reply.id,
                                              );
                                            },
                                          ),
                                          Text(reply.likes.toString()),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // INPUT KOMENTAR
  void showCommentInput(
      BuildContext context, ForumProvider forum, String postId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Komentar"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Tulis komentar...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              forum.addComment(postId, controller.text);
              Navigator.pop(context);
            },
            child: const Text("Kirim"),
          ),
        ],
      ),
    );
  }

  // INPUT BALASAN
  void showReplyInput(BuildContext context, ForumProvider forum,
      String postId, String commentId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Balas Komentar"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Tulis balasan...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              forum.addReply(postId, commentId, controller.text);
              Navigator.pop(context);
            },
            child: const Text("Kirim"),
          ),
        ],
      ),
    );
  }
}
