import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/2_auth/providers/auth_provider.dart';
import 'package:frontend/app/widgets/auth_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<AuthProvider>();
      
      final success = await provider.signIn(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        context.go('/home'); // Navigasi ke Beranda jika sukses
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Gagal masuk'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white, // Background bawah putih
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Melengkung Hitam
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(200, 60), // Membuat lengkungan bawah
                ),
              ),
              child: Center(
                // Logo Bunga/Titik
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/jajiw.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 0),
                  ],
                ),
              ),
            ),

            // 2. Form Konten
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Masuk ke JagaJiwa',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),

                    // Input Username                   
                    AuthTextField(
                      label: 'Username',
                      hint: 'Masukkan username Anda...',
                      icon: Icons.person, // Ganti ikon
                      controller: _usernameController, // Pakai controller username
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username wajib diisi!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Input Password
                    AuthTextField(
                      label: 'Kata Sandi',
                      hint: 'Masukkan kata sandi Anda...',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      controller: _passwordController,
                      validator: (value) =>
                          value != null && value.length < 6 ? 'Minimal 6 karakter' : null,
                    ),
                    const SizedBox(height: 30),

                    // Tombol Masuk
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleSignIn,
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
                                    'Masuk',
                                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward, color: Colors.white),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Tombol Sosial Media (UI Saja)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          // 1. Beri padding agar garis tidak menempel ketat pada ikon
                          padding: const EdgeInsets.all(12.0), 
                          
                          // 2. Gunakan BoxDecoration untuk membuat garis
                          decoration: BoxDecoration(
                            // Bentuk border: BoxShape.circle (Lingkaran) atau BoxShape.rectangle (Kotak)
                            shape: BoxShape.circle, 
                            
                            // Pengaturan garis border
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onPrimary, // Warna garis
                              width: 2.0, // Ketebalan garis
                            ),
                          ),
                          
                          // 3. Ikon Anda ada di dalam sini

                        ),                
                                                Container(
                          // 1. Beri padding agar garis tidak menempel ketat pada ikon
                          padding: const EdgeInsets.all(12.0), 
                          
                          // 2. Gunakan BoxDecoration untuk membuat garis
                          decoration: BoxDecoration(
                            // Bentuk border: BoxShape.circle (Lingkaran) atau BoxShape.rectangle (Kotak)
                            shape: BoxShape.circle, 
                            
                            // Pengaturan garis border
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onPrimary, // Warna garis
                              width: 2.0, // Ketebalan garis
                            ),
                          ),
                          
                          // 3. Ikon Anda ada di dalam sini
                        ),
                        Container(
                          // 1. Beri padding agar garis tidak menempel ketat pada ikon
                          padding: const EdgeInsets.all(12.0), 
                          
                          // 2. Gunakan BoxDecoration untuk membuat garis
                          decoration: BoxDecoration(
                            // Bentuk border: BoxShape.circle (Lingkaran) atau BoxShape.rectangle (Kotak)
                            shape: BoxShape.circle, 
                            
                            // Pengaturan garis border
                            border: Border.all(
                              color: Theme.of(context).colorScheme.onPrimary, // Warna garis
                              width: 2.0, // Ketebalan garis
                            ),
                          ),
                          
                          // 3. Ikon Anda ada di dalam sini

                        )
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Link Daftar & Lupa Password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Belum punya akun? "),
                        GestureDetector(
                          onTap: () => context.go('/sign-up'),
                          child: const Text(
                            "Daftar",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Lupa Kata Sandi",
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        shape: BoxShape.circle,
      ),
      child: FaIcon(icon, size: 20),
    );
  }
}