import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/widgets/ai_chatbot_fab.dart';
import '../providers/anonym_forum_provider.dart';
import 'detail_comment_screen.dart';
import 'package:frontend/app/widgets/navigation.dart';

class AnonymForumScreen extends StatefulWidget {
  const AnonymForumScreen({Key? key}) : super(key: key);

  @override
  State<AnonymForumScreen> createState() => _AnonymForumScreenState();
}

class _AnonymForumScreenState extends State<AnonymForumScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AnonymForumProvider>(context, listen: false).fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum Anonim'),
        centerTitle: true,
      ),

      body: Consumer<AnonymForumProvider>(
        builder: (context, prov, _) {
          // 1. Loading
          if (prov.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Empty state
          if (prov.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.forum_outlined, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada postingan.\nJadilah yang pertama curhat!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: prov.fetchPosts,
                    child: const Text("Refresh"),
                  )
                ],
              ),
            );
          }

          final posts = prov.posts;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, i) {
              final p = posts[i];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
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
                                Text(
                                  p.author,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  p.content.length > 120
                                      ? '${p.content.substring(0, 120)}...more'
                                      : p.content,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          IconButton(
                            onPressed: () => prov.toggleLike(p.id),
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
                                MaterialPageRoute(
                                  builder: (_) => DetailCommentScreen(postId: p.id),
                                ),
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

      floatingActionButton: const AiChatbotFab(),

      // ===== REUSABLE NAVIGATION BAR =====
      bottomNavigationBar: const MainNavigationBar(
        currentIndex: 1, // Forum
      ),
    );
  }
}
