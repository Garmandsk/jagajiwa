class Profile{
  final String profile_id;
  final DateTime created_at;
  String? anoname;
  final String username;
  final int quiz_result;
  List<String> favorite_articles_id;

  Profile({
    required this.profile_id,
    required this.created_at,
    this.anoname,
    required this.username,
    required this.quiz_result,
    required this.favorite_articles_id,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    List<String> favorites = [];
    if (json['favorite_articles_id'] != null) {
      favorites = List<String>.from(json['favorite_articles_id']);
    }

    return Profile(
      profile_id: json['profile_id'],
      created_at: DateTime.parse(json['created_at']),
      anoname: json['anoname'] ?? 'Tanpa Nama',    
      username: json['username'] ?? 'User Anonim',
      quiz_result: json['quiz_result'],
      favorite_articles_id: favorites,
    );
  }
}