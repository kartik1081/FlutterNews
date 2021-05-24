import 'package:flutter/material.dart';
import 'package:news/views/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News',
      theme: new ThemeData(
        primaryColor: Colors.white,
        brightness: Brightness.light,
      ),
      home: Home(),
    );
  }
}
