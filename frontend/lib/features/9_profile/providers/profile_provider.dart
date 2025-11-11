import 'package:flutter/foundation.dart';
import 'package:frontend/core/models/profile_model.dart'; // Pastikan model Anda benar
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  Profile? _profile;
  Profile? get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // --- FUNGSI PENGAMBILAN DATA PROFIL (DINAMIS) ---
  /*
  Future<void> fetchProfile() async {
    // Jangan fetch ulang jika data sudah ada
    if (_profile != null) return; 

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Dapatkan pengguna yang sedang login saat ini
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw 'Pengguna tidak login!';
      }

      // 2. Lakukan query ke tabel 'profiles' berdasarkan ID pengguna
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('profile_id', user.id) // Gunakan ID dinamis
          .single(); 

      // 3. Proses data jika berhasil
      _profile = Profile.fromJson(response);
      print('Response from Supabase: $response'); // Tetap simpan print untuk debug

    } catch (error) {
      _errorMessage = 'Gagal memuat profil: $error';
      print(_errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }
  */
   Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('profile_id', '73345a4b-736e-41cf-885c-0eae026574a8')
          .single(); 

      print('Response from Supabase: $response');
      _profile = Profile.fromJson(response);
    } catch (error) {
      _errorMessage = 'Gagal memuat profil: $error';
      print(_errorMessage);
    }
    _isLoading = false;
    notifyListeners();
  }

  // --- FUNGSI GENERATE NAMA (SUDAH BAGUS) ---
  Future<String?> generateNewAnoname() async {
    try {
      final newAnoname = await _supabase.rpc('get_new_anonymous_name');
      return newAnoname as String?;
    } catch (e) {
      print('Error generating new anoname: $e');
      return null;
    }
  }

  // --- FUNGSI UPDATE NAMA (SUDAH BAGUS, SEDIKIT REVISI) ---
  Future<bool> updateAnoname(String newAnoname) async {
    if (_profile == null) return false;

    try {
      await _supabase
        .from('profiles')
        .update({'anoname': newAnoname})
        .eq('profile_id', _profile!.profile_id);
      
      // Optimasi: Tidak perlu fetch ulang. Cukup update state lokal.
      _profile!.anoname = newAnoname; // Update objek profile di memori
      notifyListeners(); // Beri tahu UI (terutama Consumer)
      
      return true;
    } catch (e) {
      print('Error updating anoname: $e');
      return false;
    }
  }

  // --- FUNGSI TOGGLE FAVORIT (SUDAH BAGUS, SEDIKIT REVISI) ---
  Future<void> toggleArticleFavorite(String articleId) async {
    if (_profile == null) return;

    // Buat salinan list favorit
    final List<String> currentFavorites = List<String>.from(_profile!.favorite_articles_id);

    if (currentFavorites.contains(articleId)) {
      currentFavorites.remove(articleId);
    } else {
      currentFavorites.add(articleId);
    }

    // Optimasi: Update UI lokal dulu (Optimistic UI)
    _profile!.favorite_articles_id = currentFavorites;
    notifyListeners();
    print("UI di-update secara optimis");

    try {
      // Kirim perubahan ke Supabase di latar belakang
      await _supabase
        .from('profiles')
        .update({'favorite_articles_id': currentFavorites})
        .eq('profile_id', _profile!.profile_id);
    } catch (e) {
      print("Gagal update favorit ke Supabase: $e");    
    }  
  }
}