
import 'package:flutter/material.dart';
import 'package:frontend/app/widgets/navigation.dart';
import 'package:provider/provider.dart';
import '../providers/anonym_forum_provider.dart';
import '../model/forum_model.dart';

class DetailCommentScreen extends StatefulWidget {
  final String postId;
  const DetailCommentScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<DetailCommentScreen> createState() => _DetailCommentScreenState();
}

class _DetailCommentScreenState extends State<DetailCommentScreen> {
  TextEditingController _newCommentController = TextEditingController();

  @override
  void dispose() {
    _newCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Post')),
      body: Consumer<AnonymForumProvider>(builder: (context, prov, _) {
        final post = prov.posts.firstWhere((p) => p.id == widget.postId);
        return SingleChildScrollView(
          child: Card(
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
                        onPressed: () {
                          prov.toggleLike(post.id);
                        },
                        icon: Icon(
                          post.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: post.isLiked ? Theme.of(context).colorScheme.error : null,
                        ),),
                      Text('${post.likes}'),
                      const SizedBox(width: 16),
                    ],
                  ),
                  const Divider(),
                  const Text('Balasan', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...post.comments.map((c) => CommentWidget(comment: c, post: post, depth: 0, replyingToAuthor: null)).toList(),
                  const SizedBox(height: 20),
                  _buildNewCommentBox(post.id),
                ],
              ),
            ),
          ),
        );
      }),
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
            Provider.of<AnonymForumProvider>(context, listen: false).addComment(postId, txt);
            _newCommentController.clear();
          },
          icon: const Icon(Icons.send),
        )
      ],
    );
  }
}

class CommentWidget extends StatefulWidget {
  final Comment comment;
  final Post post;
  final int depth;
  final String? replyingToAuthor;

  const CommentWidget({Key? key, required this.comment, required this.post, this.depth = 0, this.replyingToAuthor}) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  String? _activeReplyFor;
  final Map<String, TextEditingController> _replyControllers = {};

  @override
  void dispose() {
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
    final c = widget.comment;
    return Padding(
      padding: EdgeInsets.only(left: widget.depth * 40.0),
      child: Card(
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
                        if (widget.replyingToAuthor != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text("${widget.replyingToAuthor} > ${c.author}", style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                          ),
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
                ...c.replies.map((r) => CommentWidget(comment: r, post: widget.post, depth: widget.depth + 1, replyingToAuthor: c.author)).toList()
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
                        Provider.of<AnonymForumProvider>(context, listen: false).addReply(widget.post.id, c.id, txt);
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
      ),
    );
  }
}
