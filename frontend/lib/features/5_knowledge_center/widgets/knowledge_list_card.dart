import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class KnowledgeListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? image_url;
  final IconData icon;
  final VoidCallback onTap;

  const KnowledgeListCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.image_url,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: GestureDetector(
        onTap: onTap,
        // Gunakan ClipRRect agar gambar di dalamnya ikut terpotong bulat
        child: Card(
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: image_url ?? '',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: const Center(child: CircularProgressIndicator.adaptive()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 150,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      )
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blueAccent.withOpacity(0.1),
                      child: Icon(icon, size: 30, color: Colors.blueAccent),
                    ),
                    Text(title, selectionColor: Colors.black, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(subtitle),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}