import 'package:flutter/material.dart';

class KeyboardKey extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Color backgroundColor;
  final double fontSize;
  final VoidCallback? onPressed;

  const KeyboardKey({
    super.key,
    this.text,
    this.icon,
    this.backgroundColor = Colors.white,
    this.fontSize = 20,
    this.onPressed,
  }) : assert(text != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 1),
                blurRadius: 0.5,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: text != null
              ? Text(
                  text!,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: text == 'space' || text == 'return' ? FontWeight.w500 : FontWeight.normal,
                    color: Colors.black,
                  ),
                )
              : Icon(icon, color: Colors.black, size: fontSize),
        ),
      ),
    );
  }
}