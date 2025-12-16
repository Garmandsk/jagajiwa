import 'package:flutter/material.dart';
import 'package:frontend/features/4_quiz/providers/quiz_provider.dart';
import 'package:frontend/features/4_quiz/screens/quiz_result_screen.dart';
import 'package:frontend/features/9_profile/providers/profile_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/quiz_model.dart';
import '../widgets/quiz_option_widget.dart';
import '../widgets/quiz_number_widget.dart';

class QuizStartScreen extends StatefulWidget {
  const QuizStartScreen({super.key});

  @override
  State<QuizStartScreen> createState() => _QuizStartScreenState();
}

class _QuizStartScreenState extends State<QuizStartScreen> {
  int currentIndex = 0;
  final Map<int, dynamic> answers = {};
  final TextEditingController textController = TextEditingController();

  // supaya tampilan tetap "4 of 14" seperti figma
  final int totalSteps = 16;

  final List<QuizModel> quizzes = [
    QuizModel(
      question: "Apa tujuan utama kamu mengisi kuesioner ini hari ini?",
      options: [
        "Untuk memeriksa kebiasaan saya terkait permainan/judi",
        "Untuk mengetahui apakah perilaku saya berisiko",
        "Untuk persiapan konsultasi profesional",
        "Saya hanya ingin memahami diri saya lebih baik",
        "Cuma ingin mencoba aplikasi ini",
      ],
    ),
    QuizModel(
      question: "Jenis kelamin kamu?",
      image: "assets/gender.png",
      options: [
        "Laki-laki",
        "Perempuan",
        "Lainnya / pilih untuk tidak menjawab",
      ],
    ),
    QuizModel(question: "Berapa usia kamu?", isNumberPicker: true),

    // ✅ Soal sesuai gambar
    QuizModel(
      question:
          "Dalam 12 bulan terakhir,\nseberapa sering kamu\nbertaruh/judi lebih dari yang\nkamu mampu untuk\nkehilangan?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    // Step 4/14
    QuizModel(
      question:
          "Dalam 12 bulan terakhir,\nseberapa sering kamu\nbertaruh/judi lebih dari yang\nkamu mampu untuk\nkehilangan?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    // Step 5/14 (sesuai gambar kanan)
    QuizModel(
      question:
          "Dalam 12 bulan terakhir,\napakah kamu pernah perlu\nbertaruh/judi dengan jumlah\nuang yang lebih besar agar\nterasa seru?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    // Step 6/14 (Ya / Tidak)
    QuizModel(
      question:
          "Dalam 12 bulan terakhir,\napakah kamu pernah kembali\nbermain untuk mencoba\nmenutup kerugian (balik\nmodal)?",
      image: "assets/step6.png", // ganti sesuai asset ilustrasi kamu
      options: ["Ya", "Tidak"],
    ),

    // Step 7/14
    QuizModel(
      question:
          "Apakah kamu pernah\nmeminjam uang atau menjual\nsesuatu demi berjudi?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    // Step 8/14
    QuizModel(
      question:
          "Apakah berjudi pernah\nmenimbulkan masalah\nkesehatan, termasuk stres atau\nrasa cemas?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    // Step 9/14
    QuizModel(
      question:
          "Apakah orang lain pernah\nmengkritik atau menyoroti\nkebiasaan berjudi kamu?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    // Step 10/14
    QuizModel(
      question: "Apakah kebiasaan berjudi\nmembuatmu merasa bersalah?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    // Step 11/14
    QuizModel(
      question:
          "Apakah berjudi menyebabkan\nkamu mengalami kesulitan\nkeuangan?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    // Step 12/14
    QuizModel(
      question:
          "Apakah berjudi pernah\nmengganggu pekerjaan,\nsekolah, atau kehidupan\nrumah tangga kamu?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    // Step 13/14
    QuizModel(
      question:
          "Apakah kamu pernah\nmencari bantuan profesional\nterkait kebiasaan berjudi?",
      image: "assets/step13.png", // ganti sesuai asset ilustrasi target
      options: ["Ya", "Tidak"],
    ),

    // Step 14/14 (Input bebas)
    QuizModel(
      question:
          "Tuliskan dengan bebas\napa yang kamu rasakan\nterkait kebiasaan berjudi\nkamu.",
      isTextInput: false,
    ),

    QuizModel(
      question: "Terima kasih sudah mengisi kuesioner ini!",
      image: "assets/finish_icon.png",
    ),
  ];

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  bool _canProceed(QuizModel quiz) {
    if (currentIndex == quizzes.length - 1) return true;

    if (quiz.isTextInput) return textController.text.trim().isNotEmpty;
    if (quiz.isNumberPicker) return answers[currentIndex] != null;
    if (quiz.options != null) return answers[currentIndex] != null;

    return true;
  }

  // ... class _QuizStartScreenState ...

  // Update fungsi _next
  void _next() async {
    final quiz = quizzes[currentIndex];

    if (quiz.isTextInput) {
      answers[currentIndex] = textController.text.trim();
    }

    if (!_canProceed(quiz)) return;

    if (currentIndex < quizzes.length - 1) {
      setState(() => currentIndex++);
    } else {
      // --- LOGIKA FINISH DI SINI ---
      _calculateAndFinish();
    }
  }

  Future<void> _calculateAndFinish() async {
    // 1. Hitung Skor (Logika Sederhana)
    // Asumsi: Jawaban index 0 = 0 poin, index 1 = 1 poin, dst.
    // Pertanyaan PGSI biasanya soal nomor 4 ke atas di list kamu.
    int totalScore = 0;

    answers.forEach((index, value) {
      // Kita hanya hitung skor jika jawabannya berupa angka (pilihan ganda)
      // dan bukan pertanyaan demografi (Nama, Umur, Gender)
      // Sesuaikan index ini dengan urutan soal kamu yang sebenarnya
      if (value is int && index >= 3 && index <= 12) {
        totalScore += value;
        print("quiz_start_screen: totalScore updated to $totalScore");
      }
    });

    // 2. Tentukan Resiko
    final provider = context.read<QuizProvider>();
    final riskLevel = provider.calculateRisk(totalScore);

    // 3. Simpan ke Supabase
    // Tampilkan loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await provider.saveQuizResult(totalScore, riskLevel);

      if (!mounted) return;
      await context.read<ProfileProvider>().fetchProfile();
      Navigator.pop(context); // Tutup loading

      // 4. Pindah ke Halaman Hasil
      context.pushReplacement(
        '/quiz/quiz-result',
        extra: {'score': totalScore, 'riskLevel': riskLevel},
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Tutup loading
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan: $e")));
    }
  }

  // ... rest of the code

  @override
  Widget build(BuildContext context) {
    final quiz = quizzes[currentIndex];
    final enabled = _canProceed(quiz);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (currentIndex > 0) {
                        setState(() => currentIndex--);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Icon(Icons.arrow_back_ios, size: 18),
                  ),
                  const Text(
                    "Penilaian",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      "${currentIndex + 1} of $totalSteps",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // QUESTION
              SizedBox(
                width: double.infinity,
                child: Text(
                  quiz.question,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (quiz.image != null)
                Center(child: Image.asset(quiz.image!, height: 180)),

              const SizedBox(height: 10),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (quiz.isNumberPicker)
                        QuizNumberWidget(
                          selected: (answers[currentIndex] as int?) ?? 18,
                          onSelected: (v) =>
                              setState(() => answers[currentIndex] = v),
                        ),

                      if (!quiz.isNumberPicker && quiz.options != null)
                        ...List.generate(quiz.options!.length, (i) {
                          return QuizOptionWidget(
                            text: quiz.options![i],
                            isSelected: answers[currentIndex] == i,
                            onTap: () =>
                                setState(() => answers[currentIndex] = i),
                          );
                        }),
                    ],
                  ),
                ),
              ),

              // BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: enabled ? Colors.black : Colors.black45,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: enabled ? _next : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Lanjutkan",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
