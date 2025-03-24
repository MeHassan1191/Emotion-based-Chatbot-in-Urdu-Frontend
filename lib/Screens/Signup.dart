import 'package:flutter/material.dart';
import 'package:urdu_chatbot/ApiHandler/Api.dart';
import 'package:urdu_chatbot/LoggedIn/LoggedIn.dart';
import 'package:urdu_chatbot/Screens/Avatar%20Selection.dart';
import 'package:urdu_chatbot/Screens/Login.dart'; // Import ApiProvider class

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SignUpForm(),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Image.asset(
                'lib/Assets/Images/img.png', // Add your image path here
                width: 200, // Adjust width as needed
                height: 200, // Adjust height as needed
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Username:",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5,),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.tealAccent,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Email:",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5,),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.tealAccent,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "Password:",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5,),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.tealAccent,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 25),
              ),
              onPressed: () {
                _signup(); // Call signup function on button press
              },
              child: Text(
                "Signup",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 9,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already a User?"),
                GestureDetector(
                  child: Text(
                    "login",
                    style: TextStyle(color: Colors.blue),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to handle signup
  void _signup() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      // Call signup API function
      bool success = await ApiProvider.signupUser(username, password, email);

      if (success) {
        // Signup successful
        // Show success message or navigate to another screen
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Signup successful!'),
          backgroundColor: Colors.green,
        ));
        loggedIn=username;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AvatarSelection()),
        );
      } else {
        // Signup failed
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Signup failed! Please try again.'),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      // Username, email, or password is empty
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields.'),
        backgroundColor: Colors.red,
      ));
    }
  }
}

