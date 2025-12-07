import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
    );
  }
}

// --- SCREEN UTAMA (HOMESCREEN) ---

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna yang mendekati gambar
    const Color redCard = Color(0xFF9E2C33);
    const Color brownCard = Color(0xFF966829);
    const Color goldCard = Color(0xFFB18838);

    // Menggunakan go_router untuk navigasi dummy
    void navigateTo(String route) {
      // context.go(route); // Aktifkan jika go_router sudah dikonfigurasi
      print('Navigating to $route');
    }

    return Scaffold(
      // Tidak menggunakan AppBar standar karena header "Hai, Qadrul" adalah bagian dari body
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Hai, Qadrul
            const Text(
              'Hai, Qadrul',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
                      onTap: () => navigateTo('/kuesioner'),
                    ),
                    const SizedBox(width: 15),
                    MainCard(
                      title: 'Forum Anonim',
                      icon: Icons.chat_bubble_outline,
                      color: redCard.withOpacity(0.8),
                      onTap: () => navigateTo('/forum'),
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
                      onTap: () => navigateTo('/pengetahuan'),
                    ),
                    const SizedBox(width: 15),
                    MainCard(
                      title: 'AI Chatbot',
                      icon: Icons.android,
                      color: goldCard,
                      onTap: () => navigateTo('/chatbot'),
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
                    color: Colors.black87,
                  ),
                ),
                GestureDetector(
                  onTap: () => navigateTo('/artikel'),
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

            // Kartu Rekomendasi Artikel
            Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black, // Warna dasar kartu gelap
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon centang
                  Icon(Icons.check_circle, color: Colors.white, size: 24),
                  SizedBox(height: 8),
                  // Teks rekomendasi
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
          navigateTo('/tambah');
        },
        backgroundColor: Colors.black, // Warna hitam
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: const Icon(Icons.home, color: Colors.black), onPressed: () => navigateTo('/')),
            IconButton(icon: const Icon(Icons.group, color: Colors.grey), onPressed: () => navigateTo('/komunitas')),
            const SizedBox(width: 40), // Jarak untuk FAB
            IconButton(icon: const Icon(Icons.menu_book, color: Colors.grey), onPressed: () => navigateTo('/artikel')),
            IconButton(icon: const Icon(Icons.person, color: Colors.grey), onPressed: () => context.go('/profile')),
          ],
        ),
      ),
    );
  }
}

// --- KODE INIT DUMMY UNTUK TESTING ---
// Anda dapat menjalankan ini di main.dart untuk melihat hasilnya.

/*
void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    // Route dummy lainnya untuk menghindari error go_router
    GoRoute(path: '/profile', builder: (context, state) => const Placeholder()),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'JagaJiwa App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        // menghilangkan efek splash go_router
        pageRouteBuilder: <T>(settings, builder) {
          return MaterialPageRoute<T>(
            builder: builder,
            settings: settings,
          );
        },
      ),
      routerConfig: _router,
    );
  }
}
*/