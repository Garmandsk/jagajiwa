import 'package:flutter/material.dart';

class AppTheme {
  // Warna aksen yang melambangkan harapan
  static const Color accentColor = Color(0xFFFFC107); // Contoh: Emas lembut (Amber)
  static const Color darkBackgroundColor = Color(0xFF121212); // Abu-abu sangat tua
  static const Color lightCardColor = Color(0xFFFFFFFF); // Putih bersih untuk kartu

   // Tema Terang (sebagai opsi)
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: accentColor,
    // ... konfigurasi tema terang lainnya
  );

  // Tema Gelap "Pelita Jiwa"
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackgroundColor,
    // primarySwatch: Colors.amber, // Gunakan swatch amber untuk konsistensi
    primaryColor: accentColor,    
    colorScheme: const ColorScheme.dark(
      primary: accentColor,
      secondary: accentColor,
      background: darkBackgroundColor,
      surface: darkBackgroundColor, // Warna dasar permukaan
    ),
    // Kartu akan berwarna terang di atas latar belakang gelap
    cardTheme: const CardThemeData(
      color: lightCardColor,
      elevation: 2.0,
    ),
    // Atur warna teks agar kontras dengan kartu putih
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundColor,
      elevation: 0,
    ),
  );
}