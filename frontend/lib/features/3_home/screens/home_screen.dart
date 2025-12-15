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
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda JagaJiwa')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat datang di Beranda JagaJiwa!',
              style: TextStyle(fontSize: 20, color: Colors.blueAccent),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/profile');
              },
              child: const Text('Profil Saya'),
            ),
            ElevatedButton(
              onPressed: () {
                context.push('/quiz');
              },
              child: const Text('Kuesioner'),
            ),
   
            ElevatedButton(
              onPressed: () => context.push("/anonym-forum"), 
              child: const Text("Forum Anonim"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MainNavigationBar(
        currentIndex: 1,
      ),
    );
  }
}
