import 'package:flutter/material.dart';
import 'package:frontend/app/widgets/navigation.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MainNavigationBar(
      currentIndex: 0,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Screen'),
            ElevatedButton(
              onPressed: () => context.push("/anonym-forum"), 
              child: const Text("Forum Anonim")
            ),
            ElevatedButton(
              onPressed: () => context.push("/profile"), 
              child: const Text("Profile")
            )
          ],
        ),
      ),
    );
  }
}