import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuizProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> get history => _history;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Ambil Riwayat Kuesioner
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

  // Simpan Hasil Baru
  Future<void> saveQuizResult(int score, int riskLevel) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase.from('quiz_results').insert({
        'profile_id': user.id,
        'total_score': score,
        'risk_level': riskLevel,
      });

      // Refresh list setelah simpan
      await fetchHistory();
    } catch (e) {
      debugPrint("Error saving result: $e");
      rethrow;
    }
  }

  // Helper Sederhana untuk Menentukan Resiko (Logika Dummy)
  // Bisa disesuaikan dengan logika PGSI (Problem Gambling Severity Index)
  int calculateRisk(int score) {
    if (score == 0) return 5;
    if (score <= 2) return 2;
    if (score <= 7) return 3;
    return 4;
  }
}
