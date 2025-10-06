import 'package:flutter/material.dart';

class QuizResultHelper {
  // Fungsi statis untuk mendapatkan teks
  static String getQuizResultText(int? score) {
    switch (score) {
      case 2:
        return 'Risiko Rendah';
      case 3:
        return 'Risiko Sedang';
      case 4:
        return 'Risiko Tinggi';
      default:
        return 'Belum Pernah Mengambil Kuis';
    }
  }

  // Fungsi statis untuk mendapatkan warna
  static Color getQuizResultColor(int? score) {
    switch (score) {
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}