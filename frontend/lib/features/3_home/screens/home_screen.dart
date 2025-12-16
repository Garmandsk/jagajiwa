import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:frontend/features/9_profile/providers/profile_provider.dart';
import 'package:frontend/features/5_knowledge_center/providers/knowledge_provider.dart';
import 'package:frontend/features/5_knowledge_center/widgets/knowledge_list_card.dart';
import 'package:frontend/core/models/article_model.dart';

import '../../../app/widgets/ai_chatbot_fab.dart';
import '../../../app/widgets/navigation.dart';

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
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
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
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  icon,
                  color: Colors.white.withOpacity(0.85),
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    /// Fetch artikel untuk rekomendasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KnowledgeProvider>().fetchArticles();
    });
  }

  void _push(String route, BuildContext context) {
    context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const redCard = Color(0xFF9E2C33);
    const brownCard = Color(0xFF966829);
    const goldCard = Color(0xFFB18838);

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        final username = profileProvider.profile?.username ?? 'Pengguna';

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,

          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hai, $username',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onBackground,
                  ),
                ),

                const SizedBox(height: 25),
                Column(
                  children: [
                    Row(
                      children: [
                        MainCard(
                          title: 'Kuesioner',
                          icon: Icons.assignment,
                          color: redCard,
                          onTap: () => _push('/quiz', context),
                        ),
                        const SizedBox(width: 15),
                        MainCard(
                          title: 'Forum Anonim',
                          icon: Icons.chat_bubble_outline,
                          color: redCard.withOpacity(0.85),
                          onTap: () => _push('/anonym-forum', context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        MainCard(
                          title: 'Pusat Pengetahuan',
                          icon: Icons.lightbulb_outline,
                          color: brownCard,
                          onTap: () => _push('/knowledge', context),
                        ),
                        const SizedBox(width: 15),
                        MainCard(
                          title: 'AI Chatbot',
                          icon: Icons.android,
                          color: goldCard,
                          onTap: () => _push('/chatbot', context),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rekomendasi Artikel',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _push('/knowledge', context),
                      child: Row(
                        children: [
                          Text(
                            'More',
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: theme.hintColor),
                          ),
                          Icon(Icons.chevron_right, color: theme.hintColor),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                Consumer<KnowledgeProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final articles = provider.articles.take(3).toList();

                    if (articles.isEmpty) {
                      return const Text('Belum ada artikel');
                    }

                    return Column(
                      children: articles.map((article) {
                        return KnowledgeListCard(
                          title: article.title,
                          subtitle: article.subtitle,
                          image_url: article.image_url ?? '',
                          icon: Icons.article_outlined,
                          onTap: () => context.push(
                            '/knowledge/article-detail',
                            extra: article,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),

          bottomNavigationBar: const MainNavigationBar(currentIndex: 0),

          floatingActionButton: const AiChatbotFab(),
        );
      },
    );
  }
}

