import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';

import 'src/screen_homepage.dart';
import 'src/screen_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
     home: Login(),
      //BarcodeScanning(
    //    camera: firstCamera,
   //   ),
    ),
  );
}
