import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anonym_forum_provider.dart';
import 'detail_comment_screen.dart';
import 'make_post_screen.dart';

class AnonymForumScreen extends StatelessWidget {
  const AnonymForumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Anonim'),
        centerTitle: true,
      ),
      body: Consumer<AnonymForumProvider>(
        builder: (context, prov, _) {
          final posts = prov.posts;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, i) {
              final p = posts[i];
              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(child: Text(p.author[0])),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text(
                                  p.content.length > 120 ? p.content.substring(0, 120) + '...more' : p.content,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              prov.toggleLike(p.id);
                            },
                            icon: Icon(
                              p.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: p.isLiked ? Colors.red : null,
                            ),
                          ),
                          Text('${p.likes}'),
                          const SizedBox(width: 16),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => DetailCommentScreen(postId: p.id)),
                              );
                            },
                            icon: const Icon(Icons.comment_outlined),
                          ),
                          Text('${p.comments.length}'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      
    );
  }
}