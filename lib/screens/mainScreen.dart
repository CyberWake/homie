import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home_temperature/authentication/authenticationWrapper.dart';

import 'file:///C:/Users/VK/Desktop/home_temperature/lib/auth/userAuth.dart';
import 'file:///C:/Users/VK/Desktop/home_temperature/lib/models/enums.dart';
import 'file:///C:/Users/VK/Desktop/home_temperature/lib/models/sensorData.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, @required this.title}) : super(key: key);
  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  UserAuth _userAuth = UserAuth();
  double height;
  double width;

  SensorData data = SensorData(
      temperature: "0", humidity: "0", isRaining: false, intensity: 0);
  @override
  void initState() {
    readData();
    super.initState();
  }

  void readData() {
    StreamSubscription<Event> _sensorDataSubscription;
    _sensorDataSubscription = databaseReference.onValue.listen((Event event) {
      setState(() {
        data = SensorData.fromDocument(event.snapshot);
      });
    });
  }

  String getIntensity() {
    if (data.intensity > 2500) {
      return "Heavy Rainfall";
    } else if (data.intensity > 2000) {
      return "Moderate Rainfall";
    } else if (data.intensity > 1500) {
      return "Started Raining";
    } else if (data.intensity > 1000) {
      return "Drizzling";
    }
    return " ";
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _userAuth.signOut();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => Authentication(AuthIndex.LOGIN)));
            },
            icon: Icon(Icons.power_settings_new_outlined),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          data.isRaining
              ? Stack(children: [
                  Align(
                    alignment: data.intensity > 2500
                        ? Alignment.topLeft
                        : data.intensity > 2000
                            ? Alignment.topLeft
                            : Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical:
                              data.intensity > 2000 && data.intensity < 2500
                                  ? 60.0
                                  : data.intensity > 2500
                                      ? 60
                                      : 40),
                      child: Image.asset(
                        'assets/rain.gif',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  data.intensity > 2000 && data.intensity < 2500
                      ? Container()
                      : Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 40.0),
                            child: Image.asset(
                              'assets/rain.gif',
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                  Align(
                    alignment: data.intensity > 2500
                        ? Alignment.topRight
                        : data.intensity > 2000
                            ? Alignment.topRight
                            : Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical:
                              data.intensity > 2000 && data.intensity < 2500
                                  ? 60.0
                                  : data.intensity > 2500
                                      ? 60
                                      : 40),
                      child: Image.asset(
                        'assets/rain.gif',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ])
              : Container(),
          Center(
            child: Image.asset('assets/house-icon.png'),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                data.isRaining
                    ? Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text(
                          getIntensity(),
                          style: TextStyle(
                              fontSize: 22,
                              color: Colors.pink,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: data.isRaining
                      ? height * 0.37 + height * 0.1
                      : height * 0.52,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Text(
                      '${data.temperature} °C',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.002,
                    ),
                    Text(
                      '${data.humidity} %',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
