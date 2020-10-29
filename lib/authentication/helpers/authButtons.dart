import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/VK/Desktop/home_temperature/lib/screens/mainScreen.dart';

import 'file:///C:/Users/VK/Desktop/home_temperature/lib/auth/userAuth.dart';

class AuthButtons {
  static final UserAuth _userAuth = UserAuth();

  static Widget socialLogin(
      {Size size, void Function() newAccountCallback, BuildContext context}) {
    double fontOne = (size.height * 0.015) / 11;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            await _userAuth.signInWithGoogle(context).then((result) {
              if (result == false) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Something went wrong try again')));
              } else if (result == true) {
                Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => MainScreen(
                              title: "Homie",
                            )));
              } else {
                newAccountCallback();
              }
            });
          },
          child: Image.asset(
            "assets/google.png",
            scale: fontOne * 9,
          ),
        ),
      ],
    );
  }
}
