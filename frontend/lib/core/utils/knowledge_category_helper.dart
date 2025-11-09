import 'package:flutter/material.dart';

// Class ini bertugas mengubah ID kategori (angka) menjadi data
// yang bisa dibaca manusia (Teks dan Ikon)
class KnowledgeCategoryHelper {

  // Fungsi statis untuk mendapatkan Teks Kategori
  static String getCategoryText(int? categoryId) {
    switch (categoryId) {
      case 1:
        return 'Finansial';
      case 2:
        return 'Psikologi';
      case 3:
        return 'Kisah Nyata';
      case 4:
        return 'Statistik';
      case 5:
        return 'Dukungan';
      case 0: // 0 atau null
      default:
        return 'Tidak Ada Kategori';
    }
  }

  // Bonus: Fungsi untuk mendapatkan Ikon Kategori
  static IconData getCategoryIcon(int? categoryId) {
    switch (categoryId) {
      case 1:
        return Icons.account_balance_wallet_outlined; // Finansial
      case 2:
        return Icons.psychology_outlined; // Psikologi
      case 3:
        return Icons.person_outline; // Kisah Nyata
      case 4:
        return Icons.bar_chart_outlined; // Statistik
      case 5:
        return Icons.favorite_outline; // Dukungan
      case 0:
      default:
        return Icons.article_outlined; // Default
    }
  }
}