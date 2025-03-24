class User {
  final int userId;
  final String username;
  final String gender;

  User({required this.userId, required this.username, required this.gender});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      gender: json['gender'],
    );
  }
}