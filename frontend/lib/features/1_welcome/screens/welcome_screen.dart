import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      "image": "assets/images/welcome1.jpg",
      "title": "JagaJiwa",
      "desc":
          "Aplikasi penunjang kesehatan mental dengan dukungan AI dan komunitas positif.",
    },
    {
      "image": "assets/images/welcome2.jpg",
      "title": "Atur Kesehatan Mentalmu dengan AI",
      "desc":
          "Dapatkan rekomendasi aktivitas dan latihan berdasarkan kondisi emosimu.",
    },
    {
      "image": "assets/images/welcome3.jpg",
      "title": "Catat Mood & Emosimu Setiap Hari",
      "desc": "Pantau perubahan mood dengan pencatatan harian berbasis AI.",
    },
    {
      "image": "assets/images/welcome4.jpg",
      "title": "Tulis Jurnal & Curhat dengan Chatbot",
      "desc":
          "Ekspresikan perasaanmu dengan chatbot cerdas yang siap mendengarkan.",
    },
    {
      "image": "assets/images/welcome5.jpg",
      "title": "Konten Positif Bikin Hidup Tenang",
      "desc":
          "Akses konten positif untuk menenangkan pikiran dan membangun kebiasaan baik.",
    },
    {
      "image": "assets/images/welcome6.jpg",
      "title": "Komunitas yang Saling Mendukung",
      "desc":
          "Terhubung dengan komunitas yang peduli dan saling memberikan dukungan.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB1A79C), // warna coklat keabu Figma
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Selamat Datang",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            // ==== PAGEVIEW ====
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final item = pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          // ILLUSTRATION
                          Expanded(
                            flex: 3,
                            child: Image.asset(
                              item["image"]!,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 10),

                          // TITLE
                          Text(
                            item["title"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // DESCRIPTION
                          Text(
                            item["desc"]!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 25),

                          // BUTTON NEXT
                          GestureDetector(
                            onTap: () {
                              if (currentIndex < pages.length - 1) {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              } else {
                                // TODO: pindah ke halaman login/beranda
                                context.go("/sign-in");
                              }
                            },
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ==== INDICATOR ====
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: currentIndex == index ? 28 : 10,
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? Colors.white
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}