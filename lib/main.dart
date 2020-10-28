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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  SensorData data;
  @override
  void initState() {
    super.initState();
    readData();
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Temperature is: ${data.temperature}',
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              'Humidity is: ${data.humidity}',
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
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
