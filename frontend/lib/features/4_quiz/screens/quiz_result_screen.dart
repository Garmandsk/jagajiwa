import 'package:flutter/material.dart';
import 'package:frontend/core/utils/quiz_result_helper.dart';
import 'package:go_router/go_router.dart';

class QuizResultScreen extends StatelessWidget {
  final int riskLevel;
  final int score;

  const QuizResultScreen({
    super.key,
    required this.riskLevel,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Colors.green;
    String desc = "Bagus! Pertahankan kebiasaan sehatmu.";

    if (riskLevel == 3) {
      color = Colors.orange;
      desc = "Hati-hati, kamu mulai menunjukkan tanda-tanda kecanduan.";
    } else if (riskLevel == 4) {
      color = Colors.red;
      desc = "Sebaiknya segera cari bantuan profesional atau batasi aksesmu.";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Icon(Icons.health_and_safety, size: 100, color: color),
            const SizedBox(height: 24),
            const Text(
              "Hasil Analisis",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              QuizResultHelper.getQuizResultText(riskLevel),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  // Kembali ke halaman Intro (pop sampai route pertama)
                  context.go("/quiz");
                },
                child: const Text(
                  "Kembali ke Beranda",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
