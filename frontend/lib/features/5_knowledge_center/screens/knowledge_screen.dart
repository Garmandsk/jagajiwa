import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import 'package:frontend/features/5_knowledge_center/providers/knowledge_provider.dart';
import 'package:frontend/features/5_knowledge_center/widgets/knowledge_list_card.dart';
import 'package:frontend/core/models/article_model.dart';
import 'package:frontend/core/models/video_model.dart';
import 'package:frontend/core/models/infographic_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../app/widgets/ai_chatbot_fab.dart';
import '../../../app/widgets/navigation.dart';

class KnowledgeScreen extends StatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  State<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends State<KnowledgeScreen> {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      // ================= APP BAR =================
      appBar: AppBar(
        title: const Text(
          'Pusat Pengetahuan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).colorScheme.onSurface,

        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Builder(
              builder: (context) {
                final isDark =
                    Theme.of(context).brightness == Brightness.dark;

                final iconColor = isDark
                    ? Colors.amber
                    : Theme.of(context).colorScheme.onSurface;

                final bgColor = isDark
                    ? Colors.amber.withOpacity(0.2)
                    : Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.15);

                return CircleAvatar(
                  backgroundColor: bgColor,
                  child: IconButton(
                    splashRadius: 22,
                    icon: FaIcon(
                      FontAwesomeIcons.dice,
                      size: 16,
                      color: iconColor,
                    ),
                    onPressed: () => context.push('/loss-simulation'),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ===== TAB BUTTON =====
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  _buildTabButton('Artikel', 0),
                  _buildTabButton('Infografis', 1),
                  _buildTabButton('Video', 2),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ===== SEARCH =====
            TextField(
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
              onChanged: (value) {
                context.read<KnowledgeProvider>().updateSearchQuery(value);
              },
            ),

            const SizedBox(height: 20),

            // ===== LIST CONTENT =====
            Expanded(
              child: Consumer<KnowledgeProvider>(
                builder: (context, provider, _) {
                  final items = provider.getFilteredList(_selectedTabIndex);

                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (items.isEmpty) {
                    return const Center(child: Text('Tidak ada konten.'));
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
                          onTap: () => context.push(
                            '/knowledge/article-detail',
                            extra: item,
                          ),
                        );
                      }

                      if (item is Infographic) {
                        return KnowledgeListCard(
                          title: item.title,
                          subtitle: item.subtitle,
                          image_url: item.image_url ?? '',
                          icon: Icons.image_outlined,
                          onTap: () => _showInfographicDialog(
                            context,
                            item.title,
                            item.subtitle,
                            item.image_url,
                          ),
                        );
                      }

                      if (item is Video) {
                        final videoId =
                        YoutubePlayer.convertUrlToId(item.video_url ?? '');
                        if (videoId == null) return const SizedBox.shrink();
                        return _buildVideoCard(context, videoId, item.title);
                      }

                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ================= NAVBAR =================
      bottomNavigationBar: const MainNavigationBar(currentIndex: 3),
    );
  }

  // ================= TAB BUTTON =================
  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedTabIndex = index);
          context.read<KnowledgeProvider>().updateSelectedTab(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ================= INFOGRAPHIC DIALOG =================
  void _showInfographicDialog(
      BuildContext context,
      String title,
      String subtitle,
      String? imageUrl,
      ) {
    if (imageUrl == null || imageUrl.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text(subtitle),
            const SizedBox(height: 10),
            CachedNetworkImage(imageUrl: imageUrl),
          ],
        ),
      ),
    );
  }

  // ================= VIDEO CARD =================
  Widget _buildVideoCard(BuildContext context, String videoId, String title) {
    return GestureDetector(
      onTap: () => _showVideoPlayerModal(context, videoId),
      child: Card(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: 'https://img.youtube.com/vi/$videoId/mqdefault.jpg',
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVideoPlayerModal(BuildContext context, String videoId) {
    final controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );

    showModalBottomSheet(
      context: context,
      builder: (_) => YoutubePlayer(controller: controller),
    ).whenComplete(controller.dispose);
  }
}
