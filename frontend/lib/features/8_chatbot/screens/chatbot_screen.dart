import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; 
// Asumsi import untuk navigasi
// import 'package:go_router/go_router.dart'; 

// ----------------------------------------------------------------------
// CATATAN PENTING:
// Agar kode ini berfungsi dalam struktur aplikasi Anda:
// 1. Ganti 'main' di bawah dengan rute yang sesuai di GoRouter Anda.
// 2. Jika menggunakan GoRouter, hapus tombol 'Logout' sederhana ini.
// ----------------------------------------------------------------------


class AIChatBoxScreen extends StatelessWidget {
  // Ganti super.key dengan super.key jika menggunakan const constructor
  const AIChatBoxScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. App Bar (Diambil dari desain)
      appBar: AppBar(
        // Tombol kembali, mengarahkan ke Home
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            // Contoh navigasi kembali ke Home (jika menggunakan GoRouter/pop)
            // context.go('/home'); 
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'AI Chat Bot',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
        actions: const [
          // Simulasi Status Bar - Waktu dan Sinyal
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Text('9:41', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Icon(Icons.signal_cellular_4_bar, color: Colors.black, size: 18),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.battery_full, color: Colors.black, size: 18),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // 2. Area Pesan (Dapat di-scroll)
          const Expanded(
            child: ChatMessageList(),
          ),

          // 3. Area Input Pesan dan Keyboard
          const MessageInputAndKeyboard(),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// --- Daftar Pesan ---
// ----------------------------------------------------------------------

class ChatMessageList extends StatelessWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulasi data pesan sesuai desain
    final List<Map<String, dynamic>> messages = [
      {'text': 'Ada yang bisa saya bantu?', 'isUser': false},
      {'text': 'Apa itu balita?', 'isUser': true},
    ];

    return ListView.builder(
      reverse: true, // Untuk menampilkan pesan terbaru di bawah
      padding: const EdgeInsets.all(16.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[messages.length - 1 - index];
        return ChatBubble(
          text: message['text'],
          isUser: message['isUser'],
        );
      },
    );
  }
}

// ----------------------------------------------------------------------
// --- Bubble Pesan ---
// ----------------------------------------------------------------------

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // Icon Bot (di kiri)
            if (!isUser)
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  // Asset: Ikon Bot
                  child: Icon(Icons.android, color: Colors.white, size: 20),
                ),
              ),

            // Konten Pesan
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75),
              decoration: BoxDecoration(
                color: isUser ? Colors.black : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  // Sudut bawah sesuai arah pesan
                  bottomLeft: isUser ? const Radius.circular(15) : Radius.zero,
                  bottomRight: isUser ? Radius.zero : const Radius.circular(15),
                ),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),

            // Icon User (di kanan)
            if (isUser)
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  // Asset: Ikon User
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// --- Input Bar dan Keyboard Custom ---
// ----------------------------------------------------------------------

class MessageInputAndKeyboard extends StatelessWidget {
  const MessageInputAndKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Input Bar (Area "Ketik disini......")
          const InputBar(),
          
          // Keyboard
          Container(
            color: Colors.grey[300], // Warna latar belakang keyboard
            child: const CustomKeyboardLayout(),
          ),

          // Batang navigasi bawah (Home Indicator)
          Container(
            height: 34, 
            color: Colors.grey[300],
            child: Center(
              child: Container(
                width: 130,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------
// --- Widget Input Bar Saja ---
// ----------------------------------------------------------------------

class InputBar extends StatelessWidget {
  const InputBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: <Widget>[
            // Input Field
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Ketik disini......',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  readOnly: true, // Mencegah keyboard bawaan muncul
                ),
              ),
            ),

            // Tombol Kirim
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                // Asset: Ikon Kirim
                icon: const Icon(Icons.send, color: Colors.white, size: 22),
                onPressed: () {
                  // Aksi kirim pesan
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// --- Layout Keyboard Kustom (Simulasi UI) ---
// ----------------------------------------------------------------------

class CustomKeyboardLayout extends StatelessWidget {
  const CustomKeyboardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Column(
        children: <Widget>[
          // Baris 1: q w e r t y u i o p
          _buildKeyboardRow(['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p']),

          // Baris 2: a s d f g h j k l
          _buildKeyboardRow(['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'], horizontalPadding: 20),

          // Baris 3: Shift, z x c v b n m, Delete
          _buildSpecialRow(),

          // Baris 4: 123, Space, Return, Mic
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
        children: keys.map((key) => Expanded(child: KeyboardKey(text: key))).toList(),
      ),
    );
  }

  Widget _buildSpecialRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0),
      child: Row(
        children: <Widget>[
          // Tombol Shift/Home
          const Expanded(
            flex: 14,
            child: KeyboardKey(
              // Asset: Ikon Home (sesuai desain)
              icon: Icons.home_outlined, 
              backgroundColor: Color(0xFF919191),
            ),
          ),
          const SizedBox(width: 5),

          // Huruf z x c v b n m
          ..._buildKeyboardRow(['z', 'x', 'c', 'v', 'b', 'n', 'm'], horizontalPadding: 0)
              .children.map((e) => Expanded(flex: 10, child: e)).toList(),

          const SizedBox(width: 5),

          // Tombol Delete
          const Expanded(
            flex: 14,
            child: KeyboardKey(
              // Asset: Ikon Delete (backspace)
              icon: Icons.backspace_outlined,
              backgroundColor: Color(0xFF919191),
            ),
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
          // Tombol '123'
          const Expanded(
            flex: 16,
            child: KeyboardKey(
              text: '123',
              backgroundColor: Color(0xFF919191),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 5),

          // Tombol Emoji
          const Expanded(
            flex: 10,
            child: KeyboardKey(
              // Asset: Ikon Emoji
              icon: Icons.sentiment_satisfied_alt_outlined,
              backgroundColor: Color(0xFF919191),
            ),
          ),
          const SizedBox(width: 5),

          // Tombol Spasi
          const Expanded(
            flex: 38,
            child: KeyboardKey(
              text: 'space',
              fontSize: 14,
            ),
          ),

          const SizedBox(width: 5),

          // Tombol 'return'
          const Expanded(
            flex: 18,
            child: KeyboardKey(
              text: 'return',
              backgroundColor: Color(0xFF919191),
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 5),

          // Tombol Mic
          const Expanded(
            flex: 10,
            child: KeyboardKey(
              // Asset: Ikon Mic
              icon: Icons.mic_none,
              backgroundColor: Color(0xFF919191),
            ),
          ),
        ],        
      ),
    );
  }
}

extension on Widget {
  get children => null;
}

// ----------------------------------------------------------------------
// --- Widget Tombol Keyboard Individual ---
// ----------------------------------------------------------------------

class KeyboardKey extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final Color backgroundColor;
  final double fontSize;

  const KeyboardKey({
    super.key,
    this.text,
    this.icon,
    this.backgroundColor = Colors.white,
    this.fontSize = 20,
  }) : assert(text != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
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
            : Icon(
                icon,
                color: Colors.black,
                size: fontSize,
              ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// --- Main untuk menjalankan aplikasi (HANYA UNTUK DEBUGGING FILE INI) ---
// ----------------------------------------------------------------------

void main() {
  runApp(const AIChatBoxApp());
}

class AIChatBoxApp extends StatelessWidget {
  const AIChatBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat Bot UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      // Di sini Anda akan mengganti home: dengan rute GoRouter Anda,
      // misalnya: home: const AIChatBoxScreen()
      home: const AIChatBoxScreen(),
    );
  }
}