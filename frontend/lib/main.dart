import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Provider
import 'features/7_anonym_forum/providers/anonym_forum_provider.dart';

// Navigation
import 'navigation/navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnonymForumProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Forum Anonim",
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: "Poppins",
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            brightness: Brightness.light,
          ),
        ),
        home: const MainNavigation(initialIndex: 0), // ⬅️ SATU-SATUNYA Scaffold utama
      ),
    );
  }
}
