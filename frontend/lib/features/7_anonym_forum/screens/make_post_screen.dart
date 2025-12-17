import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anonym_forum_provider.dart';

class MakePostScreen extends StatefulWidget {
  const MakePostScreen({Key? key}) : super(key: key);

  @override
  State<MakePostScreen> createState() => _MakePostScreenState();
}

class _MakePostScreenState extends State<MakePostScreen> {
  final TextEditingController _controller = TextEditingController();
  static const int maxChars = 50000;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Postingan'),
        centerTitle: true, // ✅ JUDUL KE TENGAH
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tuliskan apa pun yang ada di pikiranmu dengan bebas.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onBackground, // ✅ TERLIHAT DI DARK MODE
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  maxLength: maxChars,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tulis sesuatu...',
                    hintStyle: TextStyle(color: Colors.white54),
                  ),
                  onChanged: (_) => setState(() {}), // update counter
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_controller.text.length}/$maxChars',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onBackground.withOpacity(0.7),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final txt = _controller.text.trim();
                    if (txt.isEmpty) return;
                    await Provider.of<AnonymForumProvider>(
                      context,
                      listen: false,
                    ).createPost(txt);
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text('Kirim'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
