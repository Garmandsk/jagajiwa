class Video{
  final String knowledge_video_id;
  final DateTime created_at;
  final String title;
  final String subtitle;
  final int duration;
  final String video_url;

  Video({
    required this.knowledge_video_id,
    required this.created_at,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.video_url,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      knowledge_video_id: json['knowledge_video_id'],
      created_at: DateTime.parse(json['created_at']),
      title: json['title'] ?? 'Tanpa Judul',    
      subtitle: json['subtitle'],
      duration: json['duration'],
      video_url: json['video_url'],
    );
  }
}