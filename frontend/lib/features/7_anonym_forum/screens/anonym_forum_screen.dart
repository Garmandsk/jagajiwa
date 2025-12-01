import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anonym_forum_provider.dart';
import 'detail_comment.dart';
import 'make_post.dart';

class AnonymForumScreen extends StatelessWidget {
  const AnonymForumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Anonim'),
        centerTitle: true,
      ),
      body: Consumer<ForumProvider>(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  prov.toggleLike(p.id);
                                },
                                icon: const Icon(Icons.favorite_border),
                              ),
                              Text('${p.likes}'),
                              const SizedBox(width: 16),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => DetailScreen(postId: p.id)),
                                  );
                                },
                                icon: const Icon(Icons.comment_outlined),
                              ),
                              Text('${p.comments.length}'),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              // quick open detail
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => DetailScreen(postId: p.id)),
                              );
                            },
                            icon: const Icon(Icons.more_horiz),
                          ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const MakePostScreen()));
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            IconButton(onPressed: null, icon: Icon(Icons.home)),
            IconButton(onPressed: null, icon: Icon(Icons.group)),
            SizedBox(width: 48), // space for FAB
            IconButton(onPressed: null, icon: Icon(Icons.chat_bubble)),
            IconButton(onPressed: null, icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }
}