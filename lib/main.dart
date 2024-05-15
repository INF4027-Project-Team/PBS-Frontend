import 'package:flutter/material.dart';
import'src/screens/view_homepage.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),

      home: 
      HomePage(),
    ),
  );
}
