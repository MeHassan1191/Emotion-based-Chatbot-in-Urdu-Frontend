import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:urdu_chatbot/Model/ChatMessage.dart';
import 'package:urdu_chatbot/Model/ChatSession.dart';
import 'package:urdu_chatbot/Model/User.dart';
import 'package:urdu_chatbot/Model/Reply.dart';

class ApiProvider {
  static const String baseUrl = 'http://127.0.0.1:5000'; // Replace with your API base URL

  // Function to perform user login
  static Future<bool> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Login successful
      return true;
    } else {
      // Login failed
      return false;
    }
  }

  // Function to fetch all users
  static Future<List<User>> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      // Parse response body
      final List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      // Return empty list on error
      return [];
    }
  }

  // Function to fetch sessions for a user with a specific chatbot
  static Future<List<ChatSession>> getUserSessions(String username, int chatbotId) async {
    final response = await http.get(Uri.parse('$baseUrl/sessions/$username/$chatbotId'));

    if (response.statusCode == 200) {
      // Parse response body
      final List<dynamic> sessionsJson = jsonDecode(response.body);
      return sessionsJson.map((sessionJson) => ChatSession.fromJson(sessionJson)).toList();
    } else {
      // Return empty list on error
      return [];
    }
  }

  // Function to fetch messages for a session
  static Future<List<ChatMessage>> getSessionMessages(int sessionId) async {
    final response = await http.get(Uri.parse('$baseUrl/messages/$sessionId'));

    if (response.statusCode == 200) {
      final List<dynamic> messagesJson = jsonDecode(response.body);
      return messagesJson.map((messageJson) => ChatMessage.fromJson(messageJson)).toList();
    } else {
      throw Exception('Failed to fetch session messages');
    }
  }

  // Function to generate a reply
  static Future<Reply> generateReply(String sentence,String type) async {
    final response = await http.post(
      Uri.parse('$baseUrl/generateReply'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sentence': sentence,
        'type':type
      }),
    );

    if (response.statusCode == 200) {
      // Parse the JSON response into a Reply object
      final Map<String, dynamic> replyJson = jsonDecode(response.body);
      return Reply.fromJson(replyJson);
    } else {
      throw Exception('Failed to generate reply');
    }
  }

  // Function to create a new chat session
  static Future<Map<String, dynamic>> createSession(String title, int userId, int botId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create_session'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': title,
        'userId': userId,
        'bot_id': botId,
      }),
    );

    if (response.statusCode == 200) {
      // Parse the JSON response
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create session');
    }
  }
  static Future<int> getUserId(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/user_id/$username'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['user_id'];
    } else {
      throw Exception('Failed to get user ID');
    }
  }
  static Future<String> getEmotion(String sentence) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get_emotion'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sentence': sentence,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['emotion'];
    } else {
      throw Exception('Failed to determine emotion');
    }
  }
  static Future<void> saveMessages(String emotion, String source, String text, String entryDate, int sessionId) async {
    final String apiUrl = '$baseUrl/savemessages'; // Corrected API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'emotion': emotion,
          'source': source,
          'text': text,
          'entryDate': entryDate,
          'sessionId': sessionId, // Removed toString()
        }),
      );

      if (response.statusCode == 200) {
        print('Data saved successfully');
      } else {
        print('Failed to save data: ${response.statusCode}');
        print(entryDate);
      }
    } catch (e) {
      print('Exception while calling API: $e');
    }
  }
  static Future<void> deleteSession(int sessionId) async {
    final String apiUrl = '$baseUrl/delete_session/$sessionId';

    try {
      final response = await http.delete(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        print('Session deleted successfully');
      } else {
        print('Failed to delete session: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while calling API: $e');
    }
  }
  static Future<bool> signupUser(String username, String password, String gender) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'email': gender,
      }),
    );

    if (response.statusCode == 200) {
      // Signup successful
      return true;
    } else {
      // Signup failed
      return false;
    }
  }
}
