import 'package:flutter/material.dart';
import 'package:frontend/features/7_anonym_forum/providers/anonym_forum_provider.dart';
import 'package:frontend/features/7_anonym_forum/screens/anonym_forum_screen.dart';
import 'package:frontend/features/7_anonym_forum/screens/detail_screen.dart';
import 'package:frontend/features/7_anonym_forum/screens/make_post.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ForumProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTS PG',
      debugShowCheckedModeBanner: false,
      routes: {
        '/forum': (_) => const ForumListScreen(),
        '/forum-create': (_) => ForumCreatePostScreen(),
        '/comment-thread': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map;
          return CommentThreadScreen(
            postId: args['postId'],
          );
        },        
      },
      home: const MainHomeScreen(),  // ⬅ screen utama langsung dari main
    );
  }
}

class MainHomeScreen extends StatelessWidget {
  const MainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/forum');
          },
          child: const Text("Masuk ke Forum Anonim"),
        ),
      ),
    );
  }
}
