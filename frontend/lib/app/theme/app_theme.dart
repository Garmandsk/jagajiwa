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
    primaryColor: accentColor,

    // --- INI ADALAH BAGIAN KUNCI (ColorScheme) ---
    colorScheme: const ColorScheme.dark(
      background: darkBackgroundColor, // Latar belakang utama (gelap)
      surface: lightCardColor,        // Latar belakang 'permukaan' seperti Card (terang)
      
      onBackground: Colors.white,       // Teks DI ATAS background (gelap) -> Putih
      onSurface: Colors.black87,      // Teks DI ATAS surface (terang) -> Hitam
      
      primary: accentColor,           // Warna aksen (tombol, dll)
      onPrimary: Colors.black,          // Teks DI ATAS warna aksen (misal, di tombol)
    ),

    // Tentukan CardTheme untuk menggunakan warna 'surface'
    cardTheme: CardThemeData(
      color: lightCardColor, // Menggunakan warna 'surface'
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // --- TEXT THEME (SEKARANG TANPA WARNA EKSPLISIT) ---
    // Flutter akan otomatis memilih warna dari ColorScheme 
    // (onBackground atau onSurface)
    textTheme: const TextTheme(
      // === DISPLAY ===
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),

      // === HEADLINE ===
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),

      // === TITLE ===
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),

      // === BODY ===
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),

      // === LABEL ===
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
    ),
    
    // Anda masih bisa menimpa style tertentu jika perlu
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Colors.white, // Teks AppBar harus putih
        fontSize: 22, 
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.white), // Ikon AppBar jadi putih
    ),

    // Atur tombol agar menggunakan warna yang tepat
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor, // Tombol pakai warna aksen
        foregroundColor: Colors.black, // Teks tombol (onPrimary)
      ),
    ),
  );
}