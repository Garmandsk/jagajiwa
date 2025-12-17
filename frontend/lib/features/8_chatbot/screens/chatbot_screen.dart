import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:frontend/features/8_chatbot/widgets/custom_keyboard_layout_widget.dart';
import 'package:frontend/features/8_chatbot/widgets/chat_message_list_widget.dart';

class AIChatBoxScreen extends StatefulWidget {
  const AIChatBoxScreen({super.key});

  @override
  State<AIChatBoxScreen> createState() => _AIChatBoxScreenState();
}

class _AIChatBoxScreenState extends State<AIChatBoxScreen> {
  final GlobalKey<_MessageInputAndKeyboardState> _keyboardKey = GlobalKey();
  
  // State untuk menyimpan daftar pesan
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Ada yang bisa saya bantu?', 'isUser': false},
  ];

  bool _isLoading = false; // Untuk status loading saat menunggu balasan AI

  void _hideKeyboard() {
    _keyboardKey.currentState?._hideKeyboard();
  }

  // --- LOGIKA AZURE OPENAI ---
  Future<void> _handleSendMessage(String userMessage) async {
    // 1. Tampilkan pesan user & loading
    setState(() {
      _messages.add({'text': userMessage, 'isUser': true});
      _isLoading = true;
    });

    final String endpoint = dotenv.env['AZURE_ENDPOINT'] ?? '';
    final String apiKey = dotenv.env['AZURE_API_KEY'] ?? '';
    final String modelName = dotenv.env['AZURE_MODEL_NAME'] ?? '';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          // Karena python pakai client = OpenAI(api_key=...), dia mengirimnya sebagai Bearer Token
          'Authorization': 'Bearer $apiKey', 
          
          // JAGA-JAGA: Jika 'Authorization' gagal, Azure kadang menerima header ini:
          // 'api-key': apiKey, 
        },
        body: json.encode({
          // PENTING: Parameter ini WAJIB ada untuk endpoint jenis ini
          "model": modelName, 
          
          "messages": [
            {"role": "system", "content": "You are a helpful assistant."},
            {"role": "user", "content": userMessage}
          ],
          // Konfigurasi tambahan (opsional, sesuaikan kebutuhan)
          "max_tokens": 500, 
          "temperature": 0.7,
        }),
      );

      print("Status Code: ${response.statusCode}"); // Untuk debugging
      print("Response Body: ${response.body}");     // Untuk debugging

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String botReply = responseData['choices'][0]['message']['content'];

        setState(() {
          _messages.add({'text': botReply, 'isUser': false});
        });
      } else {
        // Tampilkan error jika gagal
        final errorMsg = json.decode(response.body)['error']['message'] ?? 'Unknown Error';
        setState(() {
          _messages.add({'text': 'Error: $errorMsg', 'isUser': false});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'text': 'Error koneksi: $e', 'isUser': false});
      });
      print('Exception: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'AI Chat Bot',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: _hideKeyboard,
        child: Column(
          children: <Widget>[
            // Area Pesan
            Expanded(
              child: ChatMessageList(messages: _messages, isLoading: _isLoading),
            ),

            // Area Input
            // Kita pass fungsi _handleSendMessage ke widget input
            MessageInputAndKeyboard(
              key: _keyboardKey,
              onSendMessage: _handleSendMessage,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class MessageInputAndKeyboard extends StatefulWidget {
  final Function(String) onSendMessage; // Callback fungsi kirim
  final bool isLoading;

  const MessageInputAndKeyboard({
    super.key, 
    required this.onSendMessage,
    this.isLoading = false,
  });

  @override
  State<MessageInputAndKeyboard> createState() => _MessageInputAndKeyboardState();
}

// ... imports

class _MessageInputAndKeyboardState extends State<MessageInputAndKeyboard> {
  late final TextEditingController _controller;
  // 1. Tambahkan FocusNode agar bisa mendeteksi keyboard fisik
  final FocusNode _focusNode = FocusNode(); 
  
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.isLoading) {
      widget.onSendMessage(text);
      _controller.clear();
      // Opsional: Tutup keyboard custom setelah kirim
      // setState(() { _isKeyboardVisible = false; });
    }
    // Pastikan fokus tetap ada agar bisa lanjut ngetik pakai keyboard fisik
    _focusNode.requestFocus(); 
  }

  // Logika memproses input (digunakan oleh Keyboard Virtual & Fisik)
  void _onKeyPressed(String key) {
    if (widget.isLoading) return;

    if (key == 'space') {
      _controller.text += ' ';
    } else if (key == 'return') {
      _sendMessage();
    } else if (key == 'delete') {
      if (_controller.text.isNotEmpty) {
        _controller.text = _controller.text.substring(0, _controller.text.length - 1);
      }
    } else {
      _controller.text += key;
    }
    
    // Update posisi kursor agar selalu di akhir
    if (_controller.text.isNotEmpty) {
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    }
    setState(() {});
  }

  // 2. Fungsi baru untuk menangkap Keyboard Fisik
  void _handlePhysicalKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      // Tombol Enter
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        _onKeyPressed('return');
      } 
      // Tombol Backspace
      else if (event.logicalKey == LogicalKeyboardKey.backspace) {
        _onKeyPressed('delete');
      } 
      // Tombol Spasi
      else if (event.logicalKey == LogicalKeyboardKey.space) {
        _onKeyPressed('space');
      }
      // Tombol Huruf/Angka (karakter yang bisa dicetak)
      else if (event.character != null && event.character!.isNotEmpty) {
        // Abaikan tombol kontrol (seperti Ctrl, Alt, dll) agar tidak error
        if (!HardwareKeyboard.instance.isControlPressed && 
            !HardwareKeyboard.instance.isAltPressed) {
           _onKeyPressed(event.character!);
        }
      }
    }
  }

  void _showKeyboard() {
    setState(() {
      _isKeyboardVisible = true;
    });
    // Minta fokus agar keyboard fisik aktif saat Custom Keyboard muncul
    _focusNode.requestFocus(); 
  }

  void _hideKeyboard() {
    setState(() {
      _isKeyboardVisible = false;
    });
    // Hapus fokus saat keyboard ditutup (opsional)
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: GestureDetector(
                        onTap: _showKeyboard,
                        child: AbsorbPointer(
                          // AbsorbPointer mencegah TextField menangani tap sendiri
                          // tapi kita butuh KeyboardListener di sini
                          child: KeyboardListener(
                            focusNode: _focusNode,
                            onKeyEvent: _handlePhysicalKey, // Panggil fungsi fisik
                            child: TextField(
                              controller: _controller,
                              // autofocus: true, // Opsional: Langsung aktif saat layar dibuka
                              decoration: InputDecoration(
                                hintText: 'Ketik disini......',
                                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 16),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                              ),
                              readOnly: true, // Tetap readOnly agar keyboard HP ga muncul
                              showCursor: true, // Tampilkan kursor agar user tahu bisa ngetik
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: widget.isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : IconButton(
                        icon: const Icon(Icons.send, color: Colors.white, size: 22),
                        onPressed: _sendMessage,
                      ),
                  ),
                ],
              ),
            ),
          ),
          
          if (_isKeyboardVisible)
            Container(
              color: Colors.grey[300],
              child: CustomKeyboardLayout(onKeyPressed: _onKeyPressed),
            ),

          if (!_isKeyboardVisible)
            Container(
              height: 34, 
              color: Colors.grey[300],
              child: Center(
                child: Container(
                  width: 130, height: 5,
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

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose(); // Jangan lupa dispose
    super.dispose();
  }
}