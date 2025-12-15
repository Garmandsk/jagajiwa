import 'package:flutter/material.dart';
import 'chat_bubble_widget.dart';

class ChatMessageList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final bool isLoading;

  const ChatMessageList({
    super.key, 
    required this.messages, 
    required this.isLoading
  });

  @override
  Widget build(BuildContext context) {
    // Scroll controller agar otomatis scroll ke bawah
    final ScrollController scrollController = ScrollController();

    // Auto scroll ke bawah saat ada pesan baru
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16.0),
      // Tambah 1 item jika sedang loading untuk indikator
      itemCount: messages.length + (isLoading ? 1 : 0), 
      itemBuilder: (context, index) {
        // Tampilkan indikator loading di item terakhir
        if (isLoading && index == messages.length) {
          return const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: SizedBox(
                width: 20, 
                height: 20, 
                child: CircularProgressIndicator(strokeWidth: 2)
              ),
            ),
          );
        }

        final message = messages[index];
        return ChatBubble(
          text: message['text'],
          isUser: message['isUser'],
        );
      },
    );
  }
}