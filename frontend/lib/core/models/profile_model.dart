class Profile{
  final String id;
  final DateTime created_at;
  final String anoname;
  final String username;
  final int quiz_result;

  Profile({
    required this.id,
    required this.created_at,
    required this.anoname,
    required this.username,
    required this.quiz_result,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      created_at: DateTime.parse(json['created_at']),
      anoname: json['anoname'] ?? 'Tanpa Nama',    
      username: json['username'] ?? 'User Anonim',
      quiz_result: json['quiz_result'],
    );
  }
}