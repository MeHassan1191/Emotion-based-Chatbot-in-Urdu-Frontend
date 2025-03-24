import 'package:flutter/material.dart';
import 'package:urdu_chatbot/LoggedIn/LoggedIn.dart';
import 'package:urdu_chatbot/Screens/ChatScreen.dart';
import 'package:urdu_chatbot/Screens/Login.dart';

class AvatarSelection extends StatefulWidget {
  const AvatarSelection({super.key});

  @override
  State<AvatarSelection> createState() => _AvatarSelectionState();
}

class _AvatarSelectionState extends State<AvatarSelection> {
  String _selected = 'Male';
  Color _maleColor = Colors.blueGrey;
  Color _femaleColor = Colors.white;
  Color _angryColor = Colors.white;

  void _selectAvatar(String avatar) {
    setState(() {
      _selected = avatar;
      if (avatar == 'Male') {
        _maleColor = Colors.blueGrey;
        _femaleColor = Colors.white;
        _angryColor = Colors.white;
      } else if (avatar == 'Female') {
        _maleColor = Colors.white;
        _femaleColor = Colors.blueGrey;
        _angryColor = Colors.white;
      } else if (avatar == 'Angry') {
        _maleColor = Colors.white;
        _femaleColor = Colors.white;
        _angryColor = Colors.blueGrey;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Align(
            alignment: Alignment(0.0, 0.8),
            child: Image(
              image: AssetImage("lib/Assets/Images/img.png"),
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAvatarOption('Male', "lib/Assets/Images/img.png", _maleColor),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                _buildAvatarOption('Female', "lib/Assets/Images/img.png", _femaleColor),
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                _buildAvatarOption('Angry', "lib/Assets/Images/img.png", _angryColor),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Align(
              alignment: Alignment(0.0, -0.1),
              child: Text(
                "Please Choose an Avatar to ",
                textAlign: TextAlign.start,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                  fontSize: 20,
                  color: Colors.teal,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text(
              "Start a Chat.",
              textAlign: TextAlign.start,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                fontSize: 20,
                color: Colors.teal,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Align(
              alignment: Alignment(-0.0, -0.0),
              child: MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SimpleChatScreen(selectedAvatar: _selected),
                    ),
                  );
                },
                color: Color(0xff1003f1),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Color(0xff808080), width: 1),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Start Chat",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                textColor: Color(0xfff8fcfc),
                height: 55,
                minWidth: 180,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Align(
              alignment: Alignment(-0.0, 0.0),
              child: MaterialButton(
                onPressed: () {
                  loggedIn='';
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                color: Color(0xfffe001d),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: Color(0xff808080), width: 1),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                textColor: Color(0xfffbfdfe),
                height: 55,
                minWidth: 180,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarOption(String name, String imagePath, Color backgroundColor) {
    return GestureDetector(
      onTap: () {
        _selectAvatar(name);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: backgroundColor,
        ),
        width: 190,
        height: 190,
        child: Column(
          children: [
            SizedBox(height: 8),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
