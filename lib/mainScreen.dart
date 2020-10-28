import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:home_temperature/sensorData.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> _sensorDataSubscription;
  double height;

  SensorData data = SensorData(
      temperature: "0", humidity: "0", isRaining: false, intensity: 0);
  @override
  void initState() {
    readData();
    super.initState();
  }

  void readData() {
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
    return "No info";
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          data.isRaining
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/rain.gif',
                    fit: BoxFit.fitWidth,
                  ),
                )
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
                        padding: EdgeInsets.only(top: height * 0.1),
                        child: Text(
                          getIntensity(),
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.pink,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Container(),
                SizedBox(
                  height: data.isRaining ? height * 0.37 : height * 0.5,
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
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.002,
                    ),
                    Text(
                      '${data.humidity}%',
                      style: Theme.of(context).textTheme.headline5,
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
