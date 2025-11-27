import 'package:flutter/material.dart';
import 'package:frontend/features/7_anonym_forum/providers/anonym_forum_provider.dart';
import 'package:provider/provider.dart';


class ForumCreatePostScreen extends StatelessWidget {
  ForumCreatePostScreen({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Postingan Anonim"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: "Tulis pesan secara anonim...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;

                  Provider.of<ForumProvider>(context, listen: false)
                      .addPost(text);

                  Navigator.pop(context);
                },
                child: const Text("Kirim"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
