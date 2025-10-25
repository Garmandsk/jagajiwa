import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda JagaJiwa'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            const Text(
              'Selamat datang di Beranda JagaJiwa!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.blueAccent
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/profile');
              },
              child: const Text('Profil Saya'),
            ),
          ],
        ),
      ),
    );
  }
}