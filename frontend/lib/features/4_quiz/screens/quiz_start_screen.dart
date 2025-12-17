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
  void initState() {
    super.initState();

    /// RESET QUIZ AGAR TIDAK LANGSUNG KE TERIMA KASIH
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<QuizProvider>().resetQuiz();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  bool _canProceed(QuizProvider provider, quiz) {
    /// HALAMAN TERAKHIR BOLEH LANGSUNG SELESAI
    if (provider.currentIndex == provider.length - 1) return true;

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

    if (!_canProceed(provider, quiz)) return;

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
        final isLast = provider.currentIndex == provider.length - 1;
        final enabled = _canProceed(provider, quiz);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// ================= TOP BAR (HILANG DI HALAMAN TERAKHIR)
                  if (!isLast)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.close, color: colors.onBackground),
                          onPressed: _showExitConfirmation,
                        ),

                        Text(
                          "Kuesioner",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.onBackground,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Text(
                            "${provider.currentIndex + 1} / ${provider.totalSteps}",
                          ),
                        ),
                      ],
                    ),


                  const SizedBox(height: 30),

                  /// ================= QUESTION
                  Text(
                    quiz.question,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colors.onBackground, // 🔥 FIX DARK MODE
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// ================= CONTENT
                  if (!isLast)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (quiz.isNumberPicker)
                              QuizNumberWidget(
                                selected:
                                provider.answers[provider.currentIndex]
                                as int? ??
                                    18,
                                onSelected: (v) => provider.setAnswer(
                                    provider.currentIndex, v),
                              ),

                            if (!quiz.isNumberPicker &&
                                quiz.options != null)
                              ...List.generate(quiz.options!.length, (i) {
                                return QuizOptionWidget(
                                  text: quiz.options![i],
                                  isSelected:
                                  provider.answers[provider.currentIndex] ==
                                      i,
                                  onTap: () => provider.setAnswer(
                                      provider.currentIndex, i),
                                );
                              }),

                            if (quiz.isTextInput)
                              TextField(
                                controller: _textController,
                                maxLines: 4,
                                cursorColor: Colors.black,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Tulis jawaban kamu di sini...",
                                  hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
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

                  /// ================= BUTTONS
                  Row(
                    children: [
                      if (!isLast)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: provider.currentIndex > 0
                                ? () => _previous(provider)
                                : null,
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return theme.brightness == Brightness.dark
                                        ? Colors.white54
                                        : Colors.black26;
                                  }
                                  return theme.brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black;
                                },
                              ),
                              side: MaterialStateProperty.resolveWith<BorderSide>(
                                    (states) {
                                  return BorderSide(
                                    color: theme.brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                  );
                                },
                              ),
                            ),
                            child: const Text("Sebelumnya"),
                          ),
                        ),


                      if (!isLast) const SizedBox(width: 12),

                      Expanded(
                        child: FilledButton(
                          onPressed: enabled ? () => _next(provider) : null,
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                                // PUTIH TERANG WALAU DISABLED
                                return Colors.white;
                              },
                            ),
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                                // Background tetap terlihat walau disabled
                                if (states.contains(MaterialState.disabled)) {
                                  return Colors.white.withOpacity(0.25);
                                }
                                return colors.primary;
                              },
                            ),
                          ),
                          child: Text(isLast ? "Selesai" : "Selanjutnya"),
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
