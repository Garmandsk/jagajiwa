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
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    Color resultColor;
    String desc;

    switch (riskLevel) {
      case 3:
        resultColor = Colors.orange;
        desc =
        "Hati-hati, kamu mulai menunjukkan tanda-tanda kecanduan.";
        break;
      case 4:
        resultColor = Colors.red;
        desc =
        "Sebaiknya segera cari bantuan profesional atau batasi aksesmu.";
        break;
      default:
        resultColor = Colors.green;
        desc = "Bagus! Pertahankan kebiasaan sehatmu.";
    }

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              /// ICON
              Icon(
                Icons.health_and_safety,
                size: 100,
                color: resultColor,
              ),

              const SizedBox(height: 24),

              /// TITLE
              Text(
                "Hasil Analisis:",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colors.onBackground.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 2),

              /// RESULT TEXT
              Text(
                QuizResultHelper.getQuizResultText(riskLevel),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: resultColor,
                ),
              ),

              const SizedBox(height: 16),

              /// DESCRIPTION
              Text(
                desc,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onBackground,
                  height: 1.5,
                ),
              ),

              const Spacer(),

              /// BUTTON
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    context.go("/quiz");
                  },
                  child: const Text("Kembali ke Beranda"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
