import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(YogaBlissApp());
}

class YogaBlissApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YogaBliss',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
