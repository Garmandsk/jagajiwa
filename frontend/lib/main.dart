import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_manager/window_manager.dart';

// App core
import 'package:frontend/app/routes/app_router.dart';
import 'package:frontend/app/theme/app_theme.dart';

// Providers
import 'package:frontend/features/2_auth/providers/auth_provider.dart';
import 'package:frontend/features/4_quiz/providers/quiz_provider.dart';
import 'package:frontend/features/5_knowledge_center/providers/knowledge_provider.dart';
import 'package:frontend/features/7_anonym_forum/providers/anonym_forum_provider.dart';
import 'package:frontend/features/9_profile/providers/profile_provider.dart';
import 'package:frontend/features/9_profile/providers/setting_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');

  // =========================================
  // Desktop Window (HANYA DESKTOP)
  // =========================================
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(393, 851),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: "JagaJiwa",
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // =========================================
  // Supabase (WAJIB HANYA DI SINI)
  // =========================================
  await Supabase.initialize(
    url: 'https://ojdzfnfpaosydemfywyq.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9qZHpmbmZwYW9zeWRlbWZ5d3lxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5OTgzMTEsImV4cCI6MjA3MzU3NDMxMX0.x537kj9JwiKZTfAWYL_Zj1pXKWcgSctAoRLNGt8lk4Y',
  );

  runApp(const JagaJiwaApp());
}

// =================================================
// ROOT APP
// =================================================
class JagaJiwaApp extends StatelessWidget {
  const JagaJiwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => KnowledgeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => SettingProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => AnonymForumProvider()),
      ],
      child: Consumer<SettingProvider>(
        builder: (context, settingProvider, _) {
          return MaterialApp.router(
            title: 'JagaJiwa',
            debugShowCheckedModeBanner: false,

            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingProvider.themeMode,

            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
