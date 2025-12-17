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
      case 5:
        return 'Tidak Berisiko';
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
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static IconData getQuizResultIcon(int? score) {
    switch (score) {
      case 2:
        return Icons.health_and_safety_outlined;
      case 3:
        return Icons.warning_amber_rounded;
      case 4:
        return Icons.report_problem_rounded;
      case 5:
        return Icons.verified_user_rounded;
      default:
        return Icons.help_outline;
    }
  }
}
