import 'package:flutter/material.dart';
import 'package:urdu_chatbot/ApiHandler/Api.dart';
import 'package:urdu_chatbot/LoggedIn/LoggedIn.dart';
import 'package:urdu_chatbot/Model/ChatMessage.dart';
import 'package:urdu_chatbot/Model/ChatSession.dart';
import 'package:urdu_chatbot/Model/Reply.dart';
import 'package:urdu_chatbot/Screens/Login.dart';
import 'package:urdu_chatbot/Screens/PieGraph.dart';

String? bot;

class SimpleChatScreen extends StatefulWidget {
  final String selectedAvatar;

  SimpleChatScreen({required this.selectedAvatar});

  @override
  _SimpleChatScreenState createState() => _SimpleChatScreenState();
}

bool areOldMessages = false;

class _SimpleChatScreenState extends State<SimpleChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late Future<List<ChatSession>> _chatSessions;
  late int _sessionId;
  late int _selectedAvatar;
  late String _selAvater;
  String avatar="";

  String _selectedOption = 'Male'; // Default value for dropdown

  @override
  void initState() {
    super.initState();
    _selAvater=widget.selectedAvatar;
    print('Selected Avatar: ${widget.selectedAvatar}');
    avatar=widget.selectedAvatar;
    if(widget.selectedAvatar=='Male') {
      _selectedAvatar=1;
    } else if(widget.selectedAvatar=='Female')
      _selectedAvatar=2;
    else
      _selectedAvatar=3;
    _chatSessions = _fetchChatSessions(1); // Default chatbotId for 'Male'
  }


  Future<List<ChatSession>> _fetchChatSessions(int chatbotId) async {
    // Fetch chat sessions for the logged-in user with the specified chatbotId
    return ApiProvider.getUserSessions(loggedIn, chatbotId);
  }

  Future<void> _fetchSessionMessages(int sessionId) async {
    final messages = await ApiProvider.getSessionMessages(sessionId);
    setState(() {
      _messages.clear();
      _messages.addAll(messages.reversed.toList());
      areOldMessages = true;
    });
  }

  void _handleSubmitted(String text) async {
    // Get the user ID using the username
    try {
      final userId = await ApiProvider.getUserId(loggedIn);
      print(loggedIn+" "+userId.toString());// Corrected method call
      // Check if this is the first message being sent
      if (_messages.isEmpty) {
        try {
          avatar=widget.selectedAvatar;
          // Create a new session
          final newSession = await ApiProvider.createSession(
            text,
            userId,
            _selectedAvatar

          );

          // Display a message indicating the session creation
          print('New session created: ${newSession['sessionId']}');
          _sessionId = int.parse(newSession['sessionId']);
          _chatSessions = _fetchChatSessions(1);
          _selectedOption = 'Male';
          setState(() {

          });
        } catch (e) {
          print('Error creating session: $e');
        }
      }
    } catch (e) {
      print('Error getting user ID: $e');
    }

    // Clear the text controller
    _textController.clear();

    try {
      // Determine the emotion of the message
      final emotion = await ApiProvider.getEmotion(text);

      // Save the user message to the database
      await ApiProvider.saveMessages(
        emotion,
        'user',
        text,
        DateTime.now().toIso8601String(),
        _sessionId, // Replace with your session ID logic
      );

      // Fetch the generated reply
      final Reply replyResponse = await ApiProvider.generateReply(text,_selAvater);

// Save the generated reply to the database
      final replyMessage = replyResponse.reply; // Use the correct getter to access the reply
      final replyEntryDate = DateTime.now().toIso8601String();
      await ApiProvider.saveMessages(
        replyResponse.emotion, // Access emotion using the getter
        'bot',
        replyMessage,
        replyEntryDate,
        _sessionId,
      );


      // Update the UI with the user message and generated reply
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            messageId: _messages.length + 1,
            emotion: emotion,
            source: 'user',
            text: text,
            entryDate: DateTime.now(),
          ),
        );
        _messages.insert(
          0,
          ChatMessage(
            messageId: _messages.length + 2,
            emotion: replyResponse.emotion,
            source: 'bot',
            text: replyMessage,
            entryDate: DateTime.parse(replyEntryDate),
          ),
        );
      });
    } catch (e) {
      print('Error handling message: $e');
    }
  }




  void _clearMessages() {
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.teal),
        title: Text("$avatar Chatbot"),
        titleTextStyle: TextStyle(color: Colors.black,fontSize: 20),
        centerTitle: true,
      ),
      drawer: _buildDrawer()
      ,
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: true,
              padding: EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _buildMessage(index),
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildMessage(int index) {
    final ChatMessage message = _messages[index];
    bool isSentMessage = index.isEven;
    String _messagee="";
    if(isSentMessage){
      _messagee=message.text;
    }else{
      _messagee=message.text+"("+message.emotion+")";
    }


    return Container(
      alignment: isSentMessage ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isSentMessage ? Colors.teal : Colors.blue,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(
          _messagee,
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
  Map<String, double> _calculateEmotionDistribution(List<ChatMessage> messages) {
    Map<String, double> emotionDistribution = {
      'Happy': 0,
      'Sad': 0,
      'Neutral': 0,
      'Fear': 0,
      'Angry': 0,
    };

    for (var message in messages) {
      if (emotionDistribution.containsKey(message.emotion)) {
        emotionDistribution[message.emotion] = emotionDistribution[message.emotion]! + 1;
      }
    }

    return emotionDistribution;
  }

  Drawer _buildDrawer() {
    Map<String, double> emotionData = _calculateEmotionDistribution(_messages);

    return Drawer(
      child: FutureBuilder<List<ChatSession>>(
        future: _chatSessions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final chatSessions = snapshot.data ?? [];

            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'lib/Assets/Images/img.png',
                            width: 90,
                            height: 90,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Chat History",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _clearMessages();
                            areOldMessages = false;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Flexible(
                  child: Center(
                    child: DropdownButton<String>(
                      value: _selectedOption,
                      items: [
                        DropdownMenuItem(
                          value: 'Male',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: 'Female',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(
                          value: 'Angry',
                          child: Text('Angry'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                          avatar = _selectedOption;
                          int chatbotId;
                          if (_selectedOption == 'Male') {
                            chatbotId = 1;
                          } else if (_selectedOption == 'Female') {
                            chatbotId = 2;
                          } else {
                            chatbotId = 3;
                          }
                          _chatSessions = _fetchChatSessions(chatbotId);
                          _messages.clear();
                          _calculateEmotionDistribution(_messages);
                        });setState(() {

                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ...chatSessions.map((session) {
                  return Container(
                    margin: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await ApiProvider.deleteSession(session.sessionId);
                          _chatSessions = _fetchChatSessions(1);
                          _selectedOption = 'Male';
                          if (session.sessionId == _sessionId) {
                            _messages.clear();
                          }
                          setState(() {});
                        },
                      ),
                      title: Text(session.creationDate.day.toString()+":"+session.creationDate.month.toString()+":"+session.creationDate.year.toString()+"    "+session.title),
                      onTap: () {
                        _fetchSessionMessages(session.sessionId);
                      },
                    ),
                  );
                }).toList(),
                Divider(),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(height:200,child: EmotionPieChart(dataMap: emotionData)),
                ),
                Divider(),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: ListTile(
                    title: Text(
                      'Logout',
                      textAlign: TextAlign.center,
                    ),
                    tileColor: Colors.redAccent,
                    onTap: () {
                      loggedIn = '';
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }


  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              enabled: !areOldMessages, // Disable the text field if _areOldMessages is true
              decoration: InputDecoration.collapsed(hintText: 'Send a message'),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

}
