import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
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
