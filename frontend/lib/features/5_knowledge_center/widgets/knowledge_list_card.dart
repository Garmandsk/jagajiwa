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
    // Tetapkan radius di satu variabel agar konsisten
    const double cardRadius = 30.0; 

    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // Hapus Container inner yang duplikat, cukup satu Container utama
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(cardRadius),
            border: Border.all(
              color: Colors.black.withOpacity(0.4),
              width: 1.5,
            ),
            // Tambahkan boxShadow jika ingin border terlihat lebih "tegas" (opsional)
            /*
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            */
          ),
          // PENTING: Clip content agar tidak keluar dari border radius container
          child: ClipRRect(
            borderRadius: BorderRadius.circular(cardRadius), // Samakan dengan radius border (30)
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.2,
                    child: CachedNetworkImage(
                      imageUrl: image_url ?? '',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      // Tidak perlu ClipRRect lagi di sini karena parent sudah di-clip
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: const Center(
                            child: CircularProgressIndicator.adaptive()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                // Content (Text & Icon)
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
                      const SizedBox(height: 8), // Beri sedikit jarak
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Pindahkan color ke sini
                        ),
                      ),
                      Text(subtitle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}