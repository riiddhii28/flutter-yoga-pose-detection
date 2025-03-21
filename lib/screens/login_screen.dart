import 'package:flutter/material.dart';
import '../services/firebase_auth_service.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  void _login() async {
    var user = await _authService.signIn(emailController.text, passwordController.text);
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      print("Login failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text("Login")),
            TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
            }, child: Text("Don't have an account? Sign up")),
          ],
        ),
      ),
    );
  }
}
