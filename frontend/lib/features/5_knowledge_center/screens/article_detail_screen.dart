import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/app/theme/app_theme.dart';
import 'package:frontend/core/models/article_model.dart';
import 'package:frontend/core/utils/knowledge_category_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:frontend/features/9_profile/providers/profile_provider.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final profileProvider = context.read<ProfileProvider>();
    final bool isFavorited = profileProvider.profile?.favorite_articles_id.contains(widget.article.knowledge_article_id) ?? false;
    print("article_detail_screen.dart: ${profileProvider.profile!.favorite_articles_id}");
    print("article_detail_screen.dart: ${widget.article.knowledge_article_id}");
    print("article_detail_screen.dart: ${isFavorited}");

    return Scaffold(      
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true, 
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.white.withAlpha(25),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  // Gunakan context.pop() dari GoRouter untuk kembali
                  onPressed: () => context.pop(), 
                ),
              ),
            ),
            title: Center(
              child: Text(
                "Pusat Pengetahuan",                          
              ),
            ),            
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white.withAlpha(25),
                  child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.dice, color: Colors.white),
                    onPressed: () => context.push("/loss-simulation"), 
                  ),
                ),
              ),
            ],    
            bottom: PreferredSize(
              // 2. Tentukan ukuran tinggi garis
              preferredSize: const Size.fromHeight(1.0),
              // 3. Buat Container sebagai garis
              child: Container(
                color: Colors.grey[800], // Warna garis Anda
                height: 1.0,
              ),
            ),
          ),
          // 7. Konten artikel sisanya
          SliverToBoxAdapter(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul (Besar)
                    Text(
                      widget.article.title,
                      style: Theme.of(context).textTheme.titleLarge
                    ),
                    Text(
                      widget.article.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                    const SizedBox(height: 12),
                    Chip(
                      avatar: Icon(
                        KnowledgeCategoryHelper.getCategoryIcon(widget.article.category),
                        size: 18,
                      ),
                      label: Text(
                        KnowledgeCategoryHelper.getCategoryText(widget.article.category),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.black,
                    ),
                    const SizedBox(height: 12),       
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [        
                        Row(
                          children: [
                            Text(
                              '${widget.article.read_time} Menit',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "-",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              DateFormat('d MMM y', 'id_ID').format(widget.article.created_at),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ]
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                isFavorited ? Icons.favorite : Icons.favorite_border_outlined,
                                color: isFavorited ? Colors.red : Colors.black,
                              ),
                              onPressed: () => profileProvider.toggleArticleFavorite(widget.article.knowledge_article_id),
                            ),
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: (){
                                SharePlus.instance.share(
                                  ShareParams(text: 'check out my website https://example.com')
                                );
                              } 
                            )
                          ]
                        ),
                      ],
                    ),
                    const Divider(
                      height: 24, 
                      color: Colors.black
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: widget.article.image_url ?? '',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Center(child: CircularProgressIndicator.adaptive()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 150,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        )
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.article.content,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "dawwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}