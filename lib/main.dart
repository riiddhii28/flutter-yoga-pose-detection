import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 

  runApp(YogaBlissApp());
}

class YogaBlissApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "YogaBliss",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: getAppRoutes(),
    );
  }
}
