
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anonym_forum_provider.dart';
import '../model/forum_model.dart';

class DetailScreen extends StatefulWidget {
  final String postId;
  const DetailScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // map to show reply box for specific comment id
  String? _activeReplyFor;
  final Map<String, TextEditingController> _replyControllers = {};

  TextEditingController _newCommentController = TextEditingController();

  @override
  void dispose() {
    _newCommentController.dispose();
    for (var c in _replyControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _getReplyController(String commentId) {
    if (!_replyControllers.containsKey(commentId)) {
      _replyControllers[commentId] = TextEditingController();
    }
    return _replyControllers[commentId]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Post')),
      body: Consumer<ForumProvider>(builder: (context, prov, _) {
        final post = prov.posts.firstWhere((p) => p.id == widget.postId);
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(child: Text(post.author[0])),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(post.createdAt.toString()),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 12),
                Text(post.content, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => prov.toggleLike(post.id),
                      icon: const Icon(Icons.favorite_border),
                    ),
                    Text('${post.likes}'),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                    ),
                  ],
                ),
                const Divider(),
                const Text('Balasan', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...post.comments.map((c) => _buildComment(context, post, c)).toList(),
                const SizedBox(height: 20),
                _buildNewCommentBox(post.id),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildComment(BuildContext context, Post post, Comment c) {
    final prov = Provider.of<ForumProvider>(context, listen: false);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 16, child: Text(c.author[0])),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(c.content),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_activeReplyFor == c.id) {
                        _activeReplyFor = null;
                      } else {
                        _activeReplyFor = c.id;
                      }
                    });
                  },
                  icon: const Icon(Icons.reply),
                ),
              ],
            ),
            if (c.replies.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...c.replies.map((r) => Padding(
                    padding: const EdgeInsets.only(left: 40, top: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(radius: 12, child: Text(r.author[0], style: const TextStyle(fontSize: 10))),
                        const SizedBox(width: 8),
                        Expanded(child: Text(r.content)),
                      ],
                    ),
                  ))
            ],
            if (_activeReplyFor == c.id) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _getReplyController(c.id),
                      decoration: const InputDecoration(hintText: 'Balas komentar...'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final txt = _getReplyController(c.id).text.trim();
                      if (txt.isEmpty) return;
                      Provider.of<ForumProvider>(context, listen: false).addReply(post.id, c.id, 'Anon', txt);
                      _getReplyController(c.id).clear();
                      setState(() {
                        _activeReplyFor = null;
                      });
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildNewCommentBox(String postId) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _newCommentController,
            decoration: const InputDecoration(hintText: 'Ketik balasan...'),
          ),
        ),
        IconButton(
          onPressed: () {
            final txt = _newCommentController.text.trim();
            if (txt.isEmpty) return;
            Provider.of<ForumProvider>(context, listen: false).addComment(postId, 'Anon', txt);
            _newCommentController.clear();
          },
          icon: const Icon(Icons.send),
        )
      ],
    );
  }
}
