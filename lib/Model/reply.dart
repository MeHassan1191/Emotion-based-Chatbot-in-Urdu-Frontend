// lib/Model/Reply.dart

class Reply {
  final String reply;
  final String emotion;

  Reply({required this.reply, required this.emotion});

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      reply: json['reply'],
      emotion: json['emotion'],
    );
  }
}
