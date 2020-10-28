import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_temperature/mainScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      appId: '1:143748364967:android:dd16deb0a053b68a0fb982',
      apiKey: 'AIzaSyCzhBXkbsAcFKXrl04NI3b0PPhkbhexFXo',
      messagingSenderId: '143748364967',
      projectId: 'hometemperature-dd50f',
      databaseURL: 'https://hometemperature-dd50f.firebaseio.com/',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(title: 'Homie'),
    );
  }
}
