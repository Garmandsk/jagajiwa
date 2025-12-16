import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/quiz_provider.dart';
import '../widgets/quiz_option_widget.dart';
import '../widgets/quiz_number_widget.dart';
import '../../9_profile/providers/profile_provider.dart';

class QuizStartScreen extends StatefulWidget {
  const QuizStartScreen({super.key});

  @override
  State<QuizStartScreen> createState() => _QuizStartScreenState();
}

class _QuizStartScreenState extends State<QuizStartScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  bool _canProceed(quiz, QuizProvider provider) {
    if (quiz.isTextInput) {
      return _textController.text.trim().isNotEmpty;
    }
    return provider.answers[provider.currentIndex] != null;
  }

  void _next(QuizProvider provider) async {
    final quiz = provider.getQuiz(provider.currentIndex);

    if (quiz.isTextInput) {
      provider.setAnswer(
        provider.currentIndex,
        _textController.text.trim(),
      );
    }

    if (!_canProceed(quiz, provider)) return;

    if (provider.currentIndex < provider.length - 1) {
      provider.nextQuestion();
    } else {
      await _finishQuiz(provider);
    }
  }

  void _previous(QuizProvider provider) {
    provider.previousQuestion();
  }

  Future<void> _finishQuiz(QuizProvider provider) async {
    int totalScore = 0;

    provider.answers.forEach((index, value) {
      if (value is int && index >= 3) {
        totalScore += value;
      }
    });

    final riskLevel = provider.calculateRisk(totalScore);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await provider.saveQuizResult(totalScore, riskLevel);
    if (!mounted) return;

    await context.read<ProfileProvider>().fetchProfile();
    Navigator.pop(context);

    context.pushReplacement(
      '/quiz/quiz-result',
      extra: {'score': totalScore, 'riskLevel': riskLevel},
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Keluar dari Kuesioner?"),
        content: const Text(
          "Jawaban kamu tidak akan disimpan jika keluar sekarang.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/knowledge');
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Consumer<QuizProvider>(
      builder: (context, provider, _) {
        final quiz = provider.getQuiz(provider.currentIndex);
        final enabled = _canProceed(quiz, provider);

        return Scaffold(
          /// 🔥 PENTING: JANGAN PAKAI colors.surface
          backgroundColor: theme.scaffoldBackgroundColor,

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// ================= TOP BAR =================
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: colors.onSurface),
                          onPressed: _showExitConfirmation,
                        ),
                        Text(
                          "Kuesioner",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            "${provider.currentIndex + 1} / ${provider.totalSteps}",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colors.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// ================= QUESTION =================
                  Text(
                    quiz.question,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colors.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// ================= CONTENT =================
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (quiz.isNumberPicker)
                            QuizNumberWidget(
                              selected:
                              provider.answers[provider.currentIndex] as int? ??
                                  18,
                              onSelected: (v) =>
                                  provider.setAnswer(provider.currentIndex, v),
                            ),

                          if (!quiz.isNumberPicker && quiz.options != null)
                            ...List.generate(quiz.options!.length, (i) {
                              return QuizOptionWidget(
                                text: quiz.options![i],
                                isSelected:
                                provider.answers[provider.currentIndex] == i,
                                onTap: () => provider.setAnswer(
                                    provider.currentIndex, i),
                              );
                            }),

                          if (quiz.isTextInput)
                            TextField(
                              controller: _textController,
                              maxLines: 4,
                              style: TextStyle(color: colors.onSurface),
                              decoration: InputDecoration(
                                hintText: "Tulis jawaban kamu di sini...",
                                hintStyle:
                                TextStyle(color: colors.onSurfaceVariant),
                                filled: true,
                                fillColor: colors.surfaceContainerHighest,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// ================= BUTTONS =================
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: provider.currentIndex > 0
                              ? () => _previous(provider)
                              : null,
                          child: const Text("Sebelumnya"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: enabled ? () => _next(provider) : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                provider.currentIndex == provider.length - 1
                                    ? "Selesai"
                                    : "Selanjutnya",
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
