import 'package:flutter/material.dart';
import 'package:frontend/app/widgets/navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // Diperlukan untuk Consumer
import 'package:frontend/features/9_profile/providers/profile_provider.dart'; // Impor provider

// --- CUSTOM WIDGET UNTUK KARTU UTAMA ---
class MainCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MainCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120, // Ketinggian kartu
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    icon,
                    color: Colors.white.withOpacity(0.8),
                    size: 28,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MainNavigationBar(
        currentIndex: 1,
      ),
    );
  }
}

// --- SCREEN UTAMA (HOMESCREEN) ---

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Fungsi khusus untuk Bottom Navigation (yang harus menggunakan context.go)
  void navigateBottomBar(String route, BuildContext context) {
    context.go(route);
  }

  // Menggunakan context.push untuk navigasi keluar dari root (home)
  void navigateTo(String route, BuildContext context) {
    context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    // Warna yang mendekati gambar
    const Color redCard = Color(0xFF9E2C33);
    const Color brownCard = Color(0xFF966829);
    const Color goldCard = Color(0xFFB18838);

    // Di sini kita menggunakan Consumer untuk mendapatkan data profil
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        // Ambil username, gunakan 'Pengguna' jika belum dimuat atau null
        final username = profileProvider.profile?.username ?? 'Pengguna';

        return Scaffold(
          // 🎯 Latar belakang diubah menjadi HITAM agar teks putih terlihat
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Hai, [Username] - Menggunakan data dari provider
                Text(
                  'Hai, $username',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),

                // Bagian Kartu Utama 2x2
                Column(
                  children: [
                    // Baris 1: Kuesioner & Forum Anonim
                    Row(
                      children: [
                        MainCard(
                          title: 'Kuesioner',
                          icon: Icons.assignment,
                          color: redCard,
                          onTap: () => navigateTo('/quiz-start', context),
                        ),
                        const SizedBox(width: 15),
                        MainCard(
                          title: 'Forum Anonim',
                          icon: Icons.chat_bubble_outline,
                          color: redCard.withOpacity(0.8),
                          onTap: () => navigateTo('/anonym-forum', context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // Baris 2: Pusat Pengetahuan & AI Chatbot
                    Row(
                      children: [
                        MainCard(
                          title: 'Pusat Pengetahuan',
                          icon: Icons.lightbulb_outline,
                          color: brownCard,
                          onTap: () => navigateTo('/knowledge', context),
                        ),
                        const SizedBox(width: 15),
                        MainCard(
                          title: 'AI Chatbot',
                          icon: Icons.android,
                          color: goldCard,
                          onTap: () => navigateTo('/chatbot', context),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Rekomendasi Artikel Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rekomendasi Artikel',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => navigateTo('/knowledge', context),
                      child: const Row(
                        children: [
                          Text('More', style: TextStyle(color: Colors.grey)),
                          Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Kartu Rekomendasi Artikel (Dummy)
                Container(
                  height: 120,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black, // Tetap gelap
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 24),
                      SizedBox(height: 8),
                      Text(
                        'Yes, one or multiple',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Text(
                        "I'm experiencing physical pain in different place over my body.",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Action Button (+) di bagian bawah
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              navigateTo('/loss-simulation', context);
            },
            backgroundColor: Colors.black,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),

          // Bottom Navigation Bar
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.grey),
                    onPressed: () => navigateBottomBar('/home', context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.group, color: Colors.grey),
                    onPressed: () => navigateBottomBar('/anonym-forum', context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.grey, size: 30),
                    onPressed: () => navigateBottomBar('/quiz', context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu_book, color: Colors.black),
                    onPressed: () => navigateBottomBar('/knowledge', context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person, color: Colors.grey),
                    onPressed: () => navigateBottomBar('/profile', context),
                  ),
                ],
              ),
            ),
        );
      },
    );
  }
}
