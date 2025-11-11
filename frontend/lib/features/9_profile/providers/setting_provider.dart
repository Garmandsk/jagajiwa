import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingProvider extends ChangeNotifier {
  // Kunci untuk menyimpan data di memori HP
  static const String _kNotificationsEnabled = 'notifications_enabled';
  static const String _kDailyReminderEnabled = 'daily_reminder_enabled';
  static const String _kThemeMode = 'theme_mode';

  // Variabel state (data)
  bool _notificationsEnabled = true;
  bool _dailyReminderEnabled = false;
  ThemeMode _themeMode = ThemeMode.dark; // Default ke tema "Pelita Jiwa"

  // Getter (agar UI bisa membaca data)
  bool get notificationsEnabled => _notificationsEnabled;
  bool get dailyReminderEnabled => _dailyReminderEnabled;
  ThemeMode get themeMode => _themeMode;

  late SharedPreferences _prefs;

  // Konstruktor: Panggil loadSettings() saat provider ini dibuat
  SettingProvider() {
    _loadSettings();
  }

  // --- LOGIKA UTAMA ---

  // 1. Memuat pengaturan saat aplikasi dibuka
  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Ambil data tersimpan, jika tidak ada, gunakan default
    _notificationsEnabled = _prefs.getBool(_kNotificationsEnabled) ?? true;
    _dailyReminderEnabled = _prefs.getBool(_kDailyReminderEnabled) ?? false;
    
    // Ambil tema (disimpan sebagai String 'system', 'light', atau 'dark')
    final themeString = _prefs.getString(_kThemeMode) ?? 'dark';
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.toString().split('.').last == themeString,
      orElse: () => ThemeMode.dark,
    );
    
    notifyListeners(); // Beri tahu UI bahwa data sudah dimuat
  }

  // 2. Fungsi untuk mengubah Notifikasi
  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    await _prefs.setBool(_kNotificationsEnabled, value);
    notifyListeners();
  }

  // 3. Fungsi untuk mengubah Pengingat Harian
  Future<void> toggleDailyReminder(bool value) async {
    _dailyReminderEnabled = value;
    await _prefs.setBool(_kDailyReminderEnabled, value);
    notifyListeners();
  }

  // 4. Fungsi untuk mengubah Tema
  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await _prefs.setString(_kThemeMode, isDark ? 'dark' : 'light');
    notifyListeners();
  }
}