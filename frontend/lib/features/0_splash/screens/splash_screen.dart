import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Selamat Datang di JagaJiwa',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}