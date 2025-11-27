import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anonym_forum_provider.dart';

class CommentThreadScreen extends StatelessWidget {
  final String postId;

  const CommentThreadScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    final forum = Provider.of<ForumProvider>(context);
    final post = forum.posts.firstWhere((p) => p.id == postId);

    return Scaffold(
      appBar: AppBar(title: const Text("Semua Komentar")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: post.comments.map((c) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• ${c.content}"),

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
                ],
              ),

              // semua balasan
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: c.replies.map((r) {
                    return Row(
                      children: [
                        Expanded(child: Text("↳ ${r.content}")),
                        IconButton(
                          icon: Icon(
                            r.isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: r.isLiked ? Colors.red : null,
                          ),
                          onPressed: () {
                            forum.toggleLikeReply(post.id, c.id, r.id);
                          },
                        ),
                        Text(r.likes.toString()),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}
