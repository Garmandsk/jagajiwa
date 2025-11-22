import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/2_auth/providers/auth_provider.dart';
import 'package:frontend/app/widgets/auth_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(); // Tambahan username
  final _anonameController = TextEditingController(); 
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isGeneratingAnoname = false;

  // Fungsi untuk mengambil nama acak
  Future<void> _rollNewAnoname() async {
    setState(() => _isGeneratingAnoname = true);
    // Panggil fungsi baru di AuthProvider
    final name = await context.read<AuthProvider>().generateNewAnoname();
    if (name != null) {
      _anonameController.text = name;
    }
    setState(() => _isGeneratingAnoname = false);
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      // Pastikan anoname terisi
      if (_anonameController.text.isEmpty) {
        await _rollNewAnoname(); // Coba generate lagi jika kosong
      }

      final provider = context.read<AuthProvider>();
      final success = await provider.signUp(        
        password: _passwordController.text,
        username: _usernameController.text.trim(),
        anoname: _anonameController.text, // <-- Kirim nama yang dipilih
      );

      if (success && mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun berhasil dibuat!'), backgroundColor: Colors.green),
        );
        context.go('/home'); 
      } else if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage ?? 'Gagal'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Generate nama awal saat layar dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rollNewAnoname();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
             // 1. Header Melengkung Hitam (Sama)
            Container(
              height: 200, // Sedikit lebih pendek
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(200, 50),
                ),
              ),
              child: const Center(child: Icon(Icons.grain, size: 60, color: Colors.white)),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Daftar Akun JagaJiwa',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Input Username (Penting untuk profil)
                    AuthTextField(
                      label: 'Username',
                      hint: 'Buat username...',
                      icon: Icons.person_outline,
                      controller: _usernameController,
                      validator: (value) => value!.isEmpty ? 'Username wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),                    

                    AuthTextField(
                      label: 'Kata Sandi',
                      hint: 'Masukkan kata sandi...',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: _passwordController,
                      validator: (value) => value!.length < 6 ? 'Minimal 6 karakter' : null,
                    ),
                    const SizedBox(height: 16),

                    // Konfirmasi Password
                    AuthTextField(
                      label: 'Konfirmasi Kata Sandi',
                      hint: 'Masukkan ulang kata sandi...',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Kata sandi tidak sama!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // --- INPUT ANONAME BARU ---
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Nama Anonim Anda (Publik)',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _anonameController,
                            readOnly: true, // User tidak boleh ngetik manual biar format terjaga
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Generating...',
                              hintStyle: const TextStyle(color: Colors.grey),
                              filled: true,
                              fillColor: Colors.black,
                              prefixIcon: const Icon(Icons.masks, color: Colors.white), // Ikon topeng/anonim
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Tombol Roll
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: _isGeneratingAnoname ? null : _rollNewAnoname,
                            icon: _isGeneratingAnoname 
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Icon(Icons.sync, color: Colors.white),
                            tooltip: 'Ganti Nama Acak',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Daftar',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward, color: Colors.white),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sudah punya akun? "),
                        GestureDetector(
                          onTap: () => context.go('/sign-in'),
                          child: const Text(
                            "Masuk",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}