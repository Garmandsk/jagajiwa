import 'package:flutter/material.dart';

class QuizOptionWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  // tambahan untuk ikon kiri (opsional)
  final IconData? leadingIcon;

  const QuizOptionWidget({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(vertical: 7),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E2A48) : Colors.black,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            // border lembut seperti figma ketika selected
            color: isSelected ? const Color(0xFFDDE8D1) : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            // ICON KIRI (opsional)
            if (leadingIcon != null) ...[
              Icon(leadingIcon, color: Colors.white, size: 20),
              const SizedBox(width: 12),
            ],

            // TEXT
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // RADIO KANAN
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
