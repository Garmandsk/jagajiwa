import 'package:flutter/material.dart';
import 'package:frontend/features/2_auth/providers/auth_provider.dart';
import 'package:frontend/features/5_knowledge_center/providers/knowledge_provider.dart';
import 'package:frontend/features/9_profile/providers/setting_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import './app/routes/app_router.dart';
import 'package:frontend/app/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Provider
import 'features/7_anonym_forum/providers/anonym_forum_provider.dart';

// Navigation
import 'navigation/navigation.dart';

void main() async {
  await dotenv.load(fileName: ".env"); // Memuat variabel lingkungan dari
    // Terapkan opsi saat jendela siap ditampilkan
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://ojdzfnfpaosydemfywyq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9qZHpmbmZwYW9zeWRlbWZ5d3lxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5OTgzMTEsImV4cCI6MjA3MzU3NDMxMX0.x537kj9JwiKZTfAWYL_Zj1pXKWcgSctAoRLNGt8lk4Y',
  );

  runApp(const JagaJiwaApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {    

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:  (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => KnowledgeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),   
        ChangeNotifierProvider(create: (_) => SettingProvider()),         
      ],
      // Gunakan Consumer<SettingProvider> di sini
      child: Consumer<SettingProvider>(
        builder: (context, settingProvider, child) {
          return MaterialApp.router(
            title: 'JagaJiwa',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,      
            themeMode: settingProvider.themeMode,      
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
