import 'package:flutter/material.dart';
import 'package:frontend/features/8_chatbot/widgets/keyboard_key_widget.dart';

class CustomKeyboardLayout extends StatelessWidget {
  final Function(String) onKeyPressed;
  const CustomKeyboardLayout({super.key, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Column(
        children: <Widget>[
          _buildKeyboardRow(['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p']),
          _buildKeyboardRow(['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'], horizontalPadding: 20),
          _buildSpecialRow(),
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys, {double horizontalPadding = 4}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: horizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: keys.map((key) => Expanded(child: KeyboardKey(text: key, onPressed: () => onKeyPressed(key)))).toList(),
      ),
    );
  }

  Widget _buildSpecialRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
      child: Row(
        children: <Widget>[
          const Expanded(
            flex: 14,
            child: KeyboardKey(icon: Icons.home_outlined, backgroundColor: Color(0xFF919191)),
          ),
          const SizedBox(width: 5),
          ...['z', 'x', 'c', 'v', 'b', 'n', 'm'].map((key) => Expanded(
                flex: 10,
                child: KeyboardKey(text: key, onPressed: () => onKeyPressed(key)),
              )).toList(),
          const SizedBox(width: 5),
          Expanded(
            flex: 14,
            child: KeyboardKey(icon: Icons.backspace_outlined, backgroundColor: Color(0xFF919191), onPressed: () => onKeyPressed('delete')),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 8.0, left: 4.0, right: 4.0),
      child: Row(
        children: <Widget>[
          const Expanded(flex: 16, child: KeyboardKey(text: '123', backgroundColor: Color(0xFF919191), fontSize: 14)),
          const SizedBox(width: 5),
          const Expanded(flex: 10, child: KeyboardKey(icon: Icons.sentiment_satisfied_alt_outlined, backgroundColor: Color(0xFF919191))),
          const SizedBox(width: 5),
          Expanded(flex: 38, child: KeyboardKey(text: 'space', fontSize: 14, onPressed: () => onKeyPressed('space'))),
          const SizedBox(width: 5),
          Expanded(flex: 18, child: KeyboardKey(text: 'return', backgroundColor: Color(0xFF919191), fontSize: 14, onPressed: () => onKeyPressed('return'))),
          const SizedBox(width: 5),
          const Expanded(flex: 10, child: KeyboardKey(icon: Icons.mic_none, backgroundColor: Color(0xFF919191))),
        ],        
      ),
    );
  }
}