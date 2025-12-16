import 'package:flutter/material.dart';
import 'package:frontend/features/0_splash/screens/splash_screen.dart';
import 'package:frontend/app/routes/app_router.dart';

class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    await Future.delayed(const Duration(seconds: 2)); // splash duration
    setState(() => _done = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_done) {
      return const SplashScreen();
    }
    return Router(
      routerDelegate: AppRouter.router.routerDelegate,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routeInformationProvider: AppRouter.router.routeInformationProvider,
    );
  }
}
