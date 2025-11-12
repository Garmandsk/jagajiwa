import 'package:flutter/material.dart';

// Import services/shared_preferences jika Anda ingin menyimpan preferensi mode gelap

class SettingProvider extends ChangeNotifier {
  // Mode Gelap/Terang
  ThemeMode _themeMode = ThemeMode.light; // Default ke terang

  // Status Notifikasi (simulasi)
  bool _notificationsEnabled = true;

  // Status Pengingat Harian (simulasi)
  bool _dailyReminderEnabled = false;

  // Getter
  ThemeMode get themeMode => _themeMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get dailyReminderEnabled => _dailyReminderEnabled;

  // Inisialisasi (Opsional: Ambil dari Shared Preferences saat startup)
  SettingProvider() {
    _loadInitialSettings();
  }

  void _loadInitialSettings() {
    // Di sini Anda akan membaca nilai yang disimpan sebelumnya
    // Contoh: _themeMode = (SharedPreferences.getBool('isDarkMode') ?? false) ? ThemeMode.dark : ThemeMode.light;
    
    // Untuk saat ini, kita gunakan nilai default di atas.
    notifyListeners();
  }

  // --- FUNGSI PENGATURAN TEMA ---

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    // Opsional: Simpan ke Shared Preferences di sini
    // SharedPreferences.setBool('isDarkMode', isDark);
  }

  // --- FUNGSI PENGATURAN NOTIFIKASI ---

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
    // Opsional: Simpan ke database atau Shared Preferences
    // print('Notifikasi diubah menjadi: $value');
  }

  // --- FUNGSI PENGATURAN PENGINGAT HARIAN ---

  void toggleDailyReminder(bool value) {
    _dailyReminderEnabled = value;
    notifyListeners();
    // Opsional: Atur jadwal pengingat lokal atau simpan status
    // print('Pengingat harian diubah menjadi: $value');
  }
}