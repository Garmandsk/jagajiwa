import 'package:flutter/foundation.dart';
import 'package:frontend/core/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  Profile? _profile;
  Profile? get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // --- FUNGSI PENGAMBILAN DATA PROFIL ---
  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Dapatkan informasi pengguna yang sedang login saat ini
      // final user = _supabase.auth.currentUser;
      // if (user == null) {
      //   throw 'Pengguna tidak login!';
      // }

      // // 2. Lakukan query ke tabel 'profiles'
      // final response = await _supabase
      //     .from('profiles')
      //     .select()
      //     .eq('id', user.id) // Cari baris dimana kolom 'id' sama dengan id pengguna yang login
      //     .single(); // Kita berharap hanya ada 1 hasil, jadi gunakan .single()

      // // 3. Proses data jika berhasil
      // _profile = Profile.fromJson(response);

      // Di dalam ProfileProvider
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', '73345a4b-736e-41cf-885c-0eae026574a8') 
          .single(); // <-- BIANG KELADINYA DI SINI

      print('Response from Supabase: $response');
      
      // Kode selanjutnya adalah:
      _profile = Profile.fromJson(response);

    } catch (error) {
      _errorMessage = 'Gagal memuat profil: $error';
      print(_errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }

   // --- FUNGSI BARU UNTUK GENERATE NAMA ---
  Future<String?> generateNewAnoname() async {
    try {
      // Memanggil fungsi SQL 'get_new_anonymous_name' yang baru kita buat
      final newAnoname = await _supabase.rpc('get_new_anonymous_name');
      return newAnoname as String?;
    } catch (e) {
      print('Error generating new anoname: $e');
      return null;
    }
  }

  // --- FUNGSI BARU UNTUK UPDATE NAMA ---
  Future<bool> updateAnoname(String newAnoname) async {
    if (_profile == null) return false;

    try {
      await _supabase
        .from('profiles')
        .update({'anoname': newAnoname}) // Ganti kolom 'name' menjadi 'anonymous_name'
        .eq('id', _profile!.id);
      
      // Refresh data profil lokal setelah berhasil update
      await fetchProfile();
      
      return true;
    } catch (e) {
      print('Error updating anoname: $e');
      return false;
    }
  }
}