import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_temperature/authentication/authenticationWrapper.dart';
import 'file:///C:/Users/VK/Desktop/home_temperature/lib/screens/mainScreen.dart';
import 'file:///C:/Users/VK/Desktop/home_temperature/lib/screens/splashScreen.dart';
import 'package:provider/provider.dart';

import 'file:///C:/Users/VK/Desktop/home_temperature/lib/auth/userAuth.dart';
import 'file:///C:/Users/VK/Desktop/home_temperature/lib/models/enums.dart';
import 'file:///C:/Users/VK/Desktop/home_temperature/lib/models/provideUser.dart';

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
    UserAuth _userAuth = UserAuth();
    return ChangeNotifierProvider(
      create: (_) => CurrentUser(),
      child: StreamProvider<User>.value(
        value: UserAuth().account,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Homie',
          theme: ThemeData(
            backgroundColor: Color(0xFFEBEBEB),
            primaryColor: Color(0xFF253A52),
          ),
          home: SplashScreen(
              navigateAfterSeconds: _userAuth.user != null
                  ? MainScreen(
                      title: "Homie",
                    )
                  : Authentication(AuthIndex.REGISTER)),
        ),
      ),
    );
  }
}
