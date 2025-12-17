import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _generateDummyEmail(String username) {
    // Pastikan username lowercase dan tanpa spasi agar aman
    final cleanName = username.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return '$cleanName@supabase.io'; // Domain fiktif
  }

  // 1. Tambahkan fungsi generate nama (untuk dipanggil di UI Sign Up)
  Future<String?> generateNewAnoname() async {
    try {
      final name = await _supabase.rpc('get_new_anonymous_name');
      return name as String?;
    } catch (e) {
      return null;
    }
  }

  // 2. Update signUp untuk menerima 'anoname'
  Future<bool> signUp({
    required String username,
    required String password,
    required String anoname, // Jika Anda pakai fitur pilih anoname
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Generate email otomatis
      final dummyEmail = _generateDummyEmail(username);

      await _supabase.auth.signUp(
        email: dummyEmail, // Kirim email palsu
        password: password,
        data: {
          'username': username,
          'anoname': anoname,
        }, 
      );

      print('User signed up with username: $username and anoname: $anoname');
      
      _isLoading = false;
      notifyListeners();
      return true;

    } on AuthException catch (e) {
      _errorMessage = e.message;
      // Handle jika username sudah dipakai (karena email jadi duplikat)
      print(e.message);
      if (e.message.contains('already registered')) {
        _errorMessage = 'Username ini sudah digunakan.';
      }
    } catch (e) {
      print(e);
      _errorMessage = 'Terjadi kesalahan tak terduga.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // --- FUNGSI SIGN IN (UBAH INI) ---
  // Ganti 'email' jadi 'username'
  Future<bool> signIn({
    required String username, 
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Generate email dari username yang diinput
      final dummyEmail = _generateDummyEmail(username);

      await _supabase.auth.signInWithPassword(
        email: dummyEmail, // Login pakai email palsu
        password: password,
      );
      
      _isLoading = false;
      notifyListeners();
      return true;

    } on AuthException {
      _errorMessage = 'Username atau kata sandi salah.';
    } catch (e) {
      _errorMessage = 'Gagal terhubung ke server.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // --- FUNGSI SIGN OUT ---
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}