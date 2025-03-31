import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart'; 
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YogaBliss',
      theme: ThemeData(
        primaryColor: Color(0xFFA89A8D), // Soft Taupe
        scaffoldBackgroundColor: Color(0xFFE9E8E7), // Light Beige
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF1D1B1A)), // Dark Charcoal
          bodyMedium: TextStyle(color: Color(0xFF1D1B1A)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6D3A3F), // Muted Wine Red
            foregroundColor: Colors.white, // White Text
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFA89A8D), // Primary Color
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: AuthCheck(),

      // ✅ Use the routes from routes.dart
      routes: getAppRoutes(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Color(0xFFE9E8E7),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/yoga_loader.png", height: 100),
                  SizedBox(height: 20),
                  CircularProgressIndicator(color: Color(0xFF6D3A3F)), 
                  SizedBox(height: 10),
                  Text(
                    "Loading YogaBliss...",
                    style: TextStyle(fontSize: 16, color: Color(0xFF1D1B1A)),
                  ),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return HomeScreen(); // ✅ If user is logged in, go to Home
        } else {
          return LoginScreen(); // ✅ If not logged in, go to Login
        }
      },
    );
  }
}
