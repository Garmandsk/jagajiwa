import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AiChatbotFab extends StatelessWidget {
  const AiChatbotFab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: () => context.push('/chatbot'),
      backgroundColor: theme.colorScheme.primary,
      elevation: 6,
      child: const Icon(
        Icons.android,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}

