import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/features/5_knowledge_center/providers/knowledge_provider.dart';
import 'package:frontend/features/5_knowledge_center/widgets/knowledge_list_card.dart';
import 'package:frontend/core/models/article_model.dart';
import 'package:frontend/core/models/video_model.dart';
import 'package:frontend/core/models/infographic_model.dart';
// Import untuk fitur baru
import 'dart:ui'; // Untuk BackdropFilter
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
  // 0 = Artikel, 1 = Infografis, 2 = Video
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<KnowledgeProvider>();
      provider.fetchArticles();
      provider.fetchVideos();
      provider.fetchInfographics();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 🎯 FUNGSI BARU: Untuk navigasi Bottom Bar (Menggunakan context.go)
  void navigateBottomBar(String route) {
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // 1. APP BAR KUSTOM
      appBar: AppBar(
        // leading widget sudah dihapus

        // 🎯 PERUBAHAN DI SINI:
        title: const Text('Pusat Pengetahuan'), // Judul diletakkan langsung
        centerTitle: true,                      // <-- Tambahkan ini untuk mempusatkan judul

        // Tombol Filter Kustom
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.1),
              child: IconButton(
                icon: const FaIcon(FontAwesomeIcons.dice, color: Colors.white),
                onPressed: () => context.push("/loss-simulation"),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // 2. TOGGLE BUTTON KUSTOM
            const SizedBox(height:20),
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabButton(context, 'Artikel', 0),
                  _buildTabButton(context, 'Infografis', 1),
                  _buildTabButton(context, 'Video', 2),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 3. SEARCH BAR
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (query) {
                  Provider.of<KnowledgeProvider>(context, listen: false)
                      .updateSearchQuery(query);

                },
              ),
            ),
            const SizedBox(height: 30),

            // 4. DAFTAR KONTEN
            Expanded(
              child: Consumer<KnowledgeProvider>(
                builder: (context, provider, child) {
                  final items = provider.getFilteredList(
                    _selectedTabIndex,
                  );

                  if (provider.isLoading && items.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (items.isEmpty) {
                    return const Center(child: Text('Tidak ada konten ditemukan.'));
                  }

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      if (item is Article) {
                        return KnowledgeListCard(
                          title: item.title,
                          subtitle: item.subtitle,
                          image_url: item.image_url ?? '',
                          icon: Icons.article_outlined,
                          onTap: () {
                            context.push('/knowledge/article-detail', extra: item);
                          },
                        );
                      } else if (item is Infographic) {
                        return KnowledgeListCard(
                          title: item.title,
                          subtitle: item.subtitle,
                          icon:  Icons.image_outlined,
                          image_url: item.image_url,
                          onTap: () => _showInfographicDialog(context, item.title, item.subtitle, item.image_url),
                        );
                      } else if (item is Video) {
                        final videoId = YoutubePlayer.convertUrlToId(item.video_url ?? '');
                        if (videoId == null) return const SizedBox.shrink();

                        return _buildVideoCard(context, videoId, item.title);
                      }
                      return null;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 🎯 FLOATING ACTION BUTTON
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke Loss Simulation
          context.push('/loss-simulation');
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),

      // 🎯 BOTTOM NAVIGATION BAR
      bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
          // Home
          IconButton(
          icon: const Icon(Icons.home, color: Colors.grey),
          onPressed: () => navigateBottomBar('/home')
      ),
      // Komunitas (Forum Anonim)
      IconButton(
          icon: const Icon(Icons.group, color: Colors.grey),
          onPressed: () => navigateBottomBar('/anonym-forum')
      ),

      // 🎯 TOMBOL BARU: QUIZ/LOSS SIMULATION
      // Menggantikan SizedBox(width: 40)
      IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.grey, size: 30), // Menggunakan ikon lain, misalnya add_circle
          // Asumsi tombol ini mengarah ke halaman kuis
          onPressed: () => navigateBottomBar('/quiz') // Ganti '/quiz-start' dengan rute yang benar
      ),

      // Artikel (Knowledge) - Highlighted atau Greyed
      IconButton(
          icon: const Icon(Icons.menu_book, color: Colors.black), // Contoh: Di ProfileScreen ini seharusnya grey
          onPressed: () => navigateBottomBar('/knowledge')
      ),
      // Profil
      IconButton(
        icon: const Icon(Icons.person, color: Colors.grey),
        onPressed: () => navigateBottomBar('/profile')),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk membuat tombol tab
  Widget _buildTabButton(BuildContext context, String text, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
            Provider.of<KnowledgeProvider>(context, listen: false)
                .updateSelectedTab(index);
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey[300] : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  void _showInfographicDialog(BuildContext context, String title, String subtitle, String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return;
    print (title);
    print(subtitle);
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(color: Colors.black.withOpacity(0.3)),
              ),
            ),
            Center(
              child: Material(
                color: Colors.transparent,
                child: Card(
                  color: const Color.fromARGB(255, 224, 219, 219),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge
                        ),
                        // 2. SUBTITLE (DI LUAR INTERACTIVEVIEWER)
                        Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                        ),
                        const SizedBox(height: 12),
                        // 3. GAMBAR YANG BISA DI-ZOOM
                        InteractiveViewer(
                          boundaryMargin: const EdgeInsets.all(20),
                          minScale: 0.1,
                          maxScale: 4.0,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 2. WIDGET UNTUK KARTU VIDEO
  Widget _buildVideoCard(BuildContext context, String videoId, String title) {
    final thumbnailUrl = 'https://img.youtube.com/vi/$videoId/mqdefault.jpg';
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: GestureDetector(
        onTap: () {
          _showVideoPlayerModal(context, videoId);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Card( // Gunakan Card agar konsisten dengan tema
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: thumbnailUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180, // Beri tinggi tetap
                ),
                Container(color: Colors.black.withOpacity(0.3)),
                Icon(
                  Icons.play_circle_fill,
                  color: Colors.white.withOpacity(0.8),
                  size: 60,
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3. FUNGSI UNTUK MODAL VIDEO
  void _showVideoPlayerModal(BuildContext context, String videoId) {
    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[700],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 25),
                  YoutubePlayer(
                    controller: controller,
                    showVideoProgressIndicator: true,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ).whenComplete(() {
      controller.dispose();
    });
  }
}