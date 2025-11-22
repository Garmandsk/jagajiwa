import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Menggunakan ValueNotifier untuk toggle visibility password
    final obscureText = ValueNotifier<bool>(isPassword);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas field (Alamat Email, Kata Sandi)
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        
        // Input Field
        ValueListenableBuilder<bool>(
          valueListenable: obscureText,
          builder: (context, isObscured, child) {
            return TextFormField(
              controller: controller,
              obscureText: isObscured,
              validator: validator,
              style: const TextStyle(color: Colors.white), // Teks input putih
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.black, // Latar belakang hitam sesuai desain
                
                // Ikon di kiri
                prefixIcon: Icon(icon, color: Colors.white),
                
                // Ikon mata (hanya jika password)
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          isObscured ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () => obscureText.value = !isObscured,
                      )
                    : null,

                // Border rounded 30px
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                errorStyle: const TextStyle(
                  color: Colors.red, 
                  fontWeight: FontWeight.bold
                ),
                // Border saat error (Merah/Peach sesuai desain)
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}