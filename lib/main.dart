import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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
      title: 'Home Temperature',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Home Temperature'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  StreamSubscription<Event> _sensorDataSubscription;

  SensorData data = SensorData(temperature: "0", humidity: "0");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Center(child: Image.asset('assets/house-icon.png')),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.19,
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

class SensorData {
  String temperature;
  String humidity;

  SensorData({
    this.temperature,
    this.humidity,
  });

  factory SensorData.fromDocument(DataSnapshot document) {
    return SensorData(
      temperature: document.value['Sensor']['temp'],
      humidity: document.value['Sensor']['hum'],
    );
  }
}
