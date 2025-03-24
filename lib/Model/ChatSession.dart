class ChatSession {
  final int sessionId;
  final String title;
  final DateTime creationDate;

  ChatSession({required this.sessionId, required this.title, required this.creationDate});

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      sessionId: json['sessionId'],
      title: json['title'],
      creationDate: DateTime.parse(json['creationDate']),
    );
  }
}