import 'package:flutter/material.dart';
import 'package:frontend/app/widgets/navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/anonym_forum_provider.dart';

class MakePostScreen extends StatefulWidget {
  const MakePostScreen({Key? key}) : super(key: key);

  @override
  State<MakePostScreen> createState() => _MakePostScreenState();
}

class _MakePostScreenState extends State<MakePostScreen> {
  final TextEditingController _controller = TextEditingController();
  static const int maxChars = 50000;
  bool _isLoading = false;

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
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  maxLines: null,
                  maxLength: maxChars,
                  autofocus: true,  // Tambahkan ini
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tulis sesuatu...',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                  onPressed: _isLoading ? null : () async {
                    final txt = _controller.text.trim();
                    if (txt.isEmpty) return;
                    final user = Supabase.instance.client.auth.currentUser;
                    if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Anda harus login terlebih dahulu')),
                      );
                      return;
                    }
                    setState(() => _isLoading = true);
                    try {
                      await Provider.of<AnonymForumProvider>(context, listen: false).createPost(txt);
                      if (mounted) context.go('/anonym-forum');
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Gagal membuat post: $e')),
                        );
                      }
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
                  child: _isLoading ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ) : const Text('Kirim'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
