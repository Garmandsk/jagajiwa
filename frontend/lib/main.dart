import 'package:flutter/material.dart';
import 'package:frontend/features/5_knowledge_center/providers/knowledge_provider.dart';
import 'package:frontend/features/9_profile/providers/setting_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import './app/routes/app_router.dart';
import 'package:frontend/app/theme/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/9_profile/providers/profile_provider.dart';
import 'package:english_words/english_words.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io' show Platform;
// ... import lainnya

void main() async {
  // Pastikan semua binding siap sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');

  // Cek apakah platform adalah Desktop (Windows, macOS, atau Linux)
  // Ini penting agar kode ini tidak berjalan di Android/iOS
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Inisialisasi window manager
    await windowManager.ensureInitialized();

    // Tentukan opsi jendela Anda
    WindowOptions windowOptions = const WindowOptions(
      // Atur ukuran sesuai target device (contoh: Pixel 5, 393x851 logical pixels)
      size: Size(393, 851),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: "JagaJiwa - Mode Debug",
    );

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

  runApp(
    // MultiProvider HARUS menjadi widget paling luar
    MultiProvider(
      providers: [
        // Pastikan Anda sudah mendaftarkan ProfileProvider di sini
        ChangeNotifierProvider(create: (_) => ProfileProvider()),   
        ChangeNotifierProvider(create: (_) => SettingProvider()), 
        ChangeNotifierProvider(create:  (_) => KnowledgeProvider()),
        // ... daftarkan provider lainnya di sini
      ],
      // JagaJiwaApp (yang berisi MaterialApp) ada DI DALAM MultiProvider
      child: const JagaJiwaApp(),
    ),
  );
}

class JagaJiwaApp extends StatelessWidget {
  const JagaJiwaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingProvider = context.watch<SettingProvider>();

    return MaterialApp.router(
      title: 'JagaJiwa',
      // Menggunakan tema "Pelita Jiwa" yang sudah kita definisikan
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingProvider.themeMode, // Default ke tema gelap "Pelita Jiwa"

      // Menggunakan GoRouter untuk navigasi
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}