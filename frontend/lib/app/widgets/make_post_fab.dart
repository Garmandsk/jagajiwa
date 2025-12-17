import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MakePostFab extends StatelessWidget {
  const MakePostFab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: () => context.push('/make-post'),
      backgroundColor: theme.colorScheme.primary,
      elevation: 6,
      heroTag: "btn1",
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}