import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/quiz_model.dart';

class QuizProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  /* =====================================================
   * SECTION 1 — QUIZ DATA
   * ===================================================== */

  final int totalSteps = 15;

  final List<QuizModel> _quizzes = [
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

    QuizModel(
      question:
      "Dalam 12 bulan terakhir,\nseberapa sering kamu\nbertaruh/judi lebih dari yang\nkamu mampu untuk\nkehilangan?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    QuizModel(
      question:
      "Dalam 12 bulan terakhir,\napakah kamu pernah perlu\nbertaruh/judi dengan jumlah\nuang yang lebih besar agar\nterasa seru?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    QuizModel(
      question:
      "Dalam 12 bulan terakhir,\napakah kamu pernah kembali\nbermain untuk mencoba\nmenutup kerugian (balik modal)?",
      options: ["Ya", "Tidak"],
    ),

    QuizModel(
      question:
      "Apakah kamu pernah\nmeminjam uang atau menjual\nsesuatu demi berjudi?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    QuizModel(
      question:
      "Apakah berjudi pernah\nmenimbulkan masalah\nkesehatan, termasuk stres atau\nrasa cemas?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    QuizModel(
      question:
      "Apakah orang lain pernah\nmengkritik atau menyoroti\nkebiasaan berjudi kamu?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    QuizModel(
      question:
      "Apakah kebiasaan berjudi\nmembuatmu merasa bersalah?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    QuizModel(
      question:
      "Apakah berjudi menyebabkan\nkamu mengalami kesulitan\nkeuangan?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    QuizModel(
      question:
      "Apakah berjudi pernah\nmengganggu pekerjaan,\nsekolah, atau kehidupan\nrumah tangga kamu?",
      options: ["Tidak pernah", "Kadang - kadang", "Sering", "Hampir selalu"],
    ),

    QuizModel(
      question:
      "Apakah kamu pernah\nmencari bantuan profesional\nterkait kebiasaan berjudi?",
      options: ["Ya", "Tidak"],
    ),

    QuizModel(
      question:
      "Tuliskan dengan bebas\napa yang kamu rasakan\nterkait kebiasaan berjudi\nkamu.",
      isTextInput: true,
    ),

    QuizModel(
      question: "Terima kasih sudah mengisi kuesioner ini!",
      image: "assets/finish_icon.png",
    ),
  ];

  List<QuizModel> get quizzes => _quizzes;
  QuizModel getQuiz(int index) => _quizzes[index];
  int get length => _quizzes.length;

  /* =====================================================
   * SECTION 2 — QUIZ STATE
   * ===================================================== */

  int currentIndex = 0;
  final Map<int, dynamic> answers = {};

  void nextQuestion() {
    if (currentIndex < _quizzes.length - 1) {
      currentIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (currentIndex > 0) {
      currentIndex--;
      notifyListeners();
    }
  }

  void setAnswer(int index, dynamic value) {
    answers[index] = value;
    notifyListeners();
  }

  void resetQuiz() {
    currentIndex = 0;
    answers.clear();
    notifyListeners();
  }

  /* =====================================================
   * SECTION 3 — HISTORY (SUPABASE)
   * ===================================================== */

  List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> get history => _history;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchHistory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('quiz_results')
          .select()
          .eq('profile_id', user.id)
          .order('created_at', ascending: false);

      _history = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Error fetching history: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /* =====================================================
   * SECTION 4 — SAVE & SCORE
   * ===================================================== */

  Future<void> saveQuizResult(int score, int riskLevel) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.from('quiz_results').insert({
        'profile_id': user.id,
        'total_score': score,
        'risk_level': riskLevel,
      });

      await fetchHistory();
    } catch (e) {
      debugPrint("Error saving result: $e");
      rethrow;
    }
  }

  int calculateRisk(int score) {
    if (score == 0) return 5;
    if (score <= 2) return 2;
    if (score <= 7) return 3;
    return 4;
  }
}

