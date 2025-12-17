import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/app/theme/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import jika pakai ikon Dadu

class LossSimulationScreen extends StatefulWidget {
  const LossSimulationScreen({super.key});

  @override
  State<LossSimulationScreen> createState() => _LossSimulationScreenState();
}

class _LossSimulationScreenState extends State<LossSimulationScreen> {
  // --- KONFIGURASI GAME ---
  final int _gridSize = 6;
  final double _betAmount = 50000;
  
  // --- STATE ---
  double _virtualBalance = 10000000;
  bool _isSpinning = false;
  List<IconData> _gridSymbols = [];
  String _currentMessage = "Selamat Pagi, Siang, dan Malam. Siap Kalah?";
  
  final List<IconData> _availableSymbols = [
    FontAwesomeIcons.dice,   // Ikon Dadu (Judi)
    Icons.square_rounded,
    Icons.circle_rounded,
    Icons.star_rounded,
    FontAwesomeIcons.xmark,  // Tanda Silang
  ];

  final List<String> _messages = [
    "Kekalahan Adalah Hal Mutlak",
    "Berhenti. Adalah Kemenangan Sejati",
    "Uang ini bisa untuk beli makan sebulan.",
    "Bandar selalu menang, ingat itu.",
    "Hanya angka virtual, tapi sakitnya nyata?",
    "Terus kejar, sampai habis tak bersisa.",
    "Sistem ini dirancang untuk mengambil uangmu.",
  ];

  @override
  void initState() {
    super.initState();
    _randomizeGrid();
  }

  void _randomizeGrid() {
    setState(() {
      _gridSymbols = List.generate(
        _gridSize * _gridSize, 
        (index) => _availableSymbols[Random().nextInt(_availableSymbols.length)],
      );
    });
  }

  void _startLossSimulation() {
    if (_virtualBalance < _betAmount) {
      _showGameOverDialog();
      return;
    }

    setState(() {
      _isSpinning = true;
      _virtualBalance -= _betAmount;
    });

    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      _randomizeGrid();
      
      if (timer.tick >= 20) { 
        timer.cancel();
        setState(() {
          _isSpinning = false;
          _currentMessage = _messages[Random().nextInt(_messages.length)];
        });
      }
    });
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(amount);
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Dialog menggunakan warna surface (putih)
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text("Saldo Habis", 
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface)
        ),
        content: Text(
          "Dalam simulasi ini, uang Anda habis dalam waktu singkat. Di dunia nyata, dampaknya permanen. Berhenti selagi bisa.",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text("Saya Mengerti", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil warna langsung dari Theme Data "Pelita Jiwa" yang sudah kita buat
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // 1. Latar Belakang Gelap (Background)
      backgroundColor: colorScheme.surface,
      
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: colorScheme.onSurface.withOpacity(0.1),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Text(
          'Simulasi Kekalahan',
          // Teks Putih (onBackground)
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            

            // --- 2. INFO SALDO (KARTU PUTIH/SURFACE) ---
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface, // Putih (Pelita)
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text("Saldo Fiktif Anda", 
                    style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(_virtualBalance),
                    style: TextStyle(
                      fontSize: 26, 
                      fontWeight: FontWeight.w900, 
                      // Teks Hitam (onSurface), kecuali kritis
                      color: _virtualBalance < 500000 ? Colors.red : colorScheme.onSurface
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- 3. HEADER TEXT (PUTIH/ON BACKGROUND) ---
            SizedBox(
              height: 70,
              child: Text(
                _currentMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurface, // Putih kontras
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- 4. GAME GRID (KARTU PUTIH/SURFACE) ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.greyku, // Putih
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    // Glow tipis warna Emas (Primary)
                    color: colorScheme.primary.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 1,
                  )
                ],
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _gridSize,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _gridSymbols.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppTheme.darkBackgroundColor, // Abu-abu sangat muda untuk sel
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _gridSymbols[index],
                        color: AppTheme.lightCardColor, // Ikon Hitam
                        size: 28,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height:50),

            // --- 5. TOMBOL AKSI (EMAS/PRIMARY) ---
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSpinning ? null : _startLossSimulation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary, // Emas/Amber
                  foregroundColor: colorScheme.onPrimary, // Hitam
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isSpinning 
                  ? SizedBox(
                      height: 24, width: 24, 
                      child: CircularProgressIndicator(
                        color: colorScheme.onPrimary, // Hitam
                        strokeWidth: 3
                      )
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         Text(
                          "Mulai Kalah (${_formatCurrency(_betAmount)})",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        // Ikon Dadu atau Panah (sesuai preferensi Anda)
                        const FaIcon(FontAwesomeIcons.dice, size: 20), 
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