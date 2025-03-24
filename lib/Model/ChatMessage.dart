import 'package:intl/intl.dart';

class ChatMessage {
  int messageId;
  String emotion;
  String text;
  DateTime entryDate;
  String source; // Include source attribute

  ChatMessage({
    required this.messageId,
    required this.emotion,
    required this.text,
    required this.entryDate,
    required this.source, // Initialize source attribute
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      parsedDate = _parseDate(json['entryDate']);
    } catch (e) {
      // Handle error gracefully and use the current date as a fallback
      parsedDate = DateTime.now();
    }

    return ChatMessage(
      messageId: json['messageId'],
      emotion: json['emotion'],
      text: json['text'],
      entryDate: parsedDate,
      source: json['source'], // Parse source attribute
    );
  }

  Map<String, dynamic> toJson() => {
    'messageId': messageId,
    'emotion': emotion,
    'text': text,
    'entryDate': entryDate.toIso8601String(),
    'source': source, // Include source in JSON serialization
  };

  static DateTime _parseDate(String dateStr) {
    // Use DateFormat to parse the date string
    final dateFormat = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", 'en_US');
    return dateFormat.parseUtc(dateStr);
  }
}
