import 'package:flutter/material.dart';
import 'package:urdu_chatbot/ApiHandler/Api.dart';
import 'package:urdu_chatbot/LoggedIn/LoggedIn.dart';
import 'package:urdu_chatbot/Screens/Avatar%20Selection.dart';
import 'package:urdu_chatbot/Screens/Signup.dart';// Import your ApiProvider class

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    // Call the loginUser function from ApiProvider
    final bool loginSuccess = await ApiProvider.loginUser(username, password);

    if (loginSuccess) {
      loggedIn=username;
      // If login is successful, navigate to AvatarSelection screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AvatarSelection()),
      );
    } else {
      // If login fails, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please check your username and password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'lib/Assets/Images/img.png',
                  width: 300,
                  height: 300,
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
                controller: usernameController,
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
                controller: passwordController,
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
              SizedBox(height: 28.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                ),
                onPressed: loginUser, // Call the loginUser function when the button is pressed
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 9,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't have an account?"),
                  GestureDetector(
                    child: Text(
                      "Signup",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
