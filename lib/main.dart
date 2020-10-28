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
      title: 'Homie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Homie'),
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

class SensorData {
  String temperature;
  String humidity;
  bool isRaining;
  int intensity;

  SensorData({
    this.temperature,
    this.humidity,
    this.isRaining,
    this.intensity,
  });

  factory SensorData.fromDocument(DataSnapshot document) {
    return SensorData(
      temperature: document.value['TemperatureSensor']['temp'],
      humidity: document.value['TemperatureSensor']['hum'],
      isRaining: document.value['RainSensor']['raining'],
      intensity: document.value['RainSensor']['intensity'],
    );
  }
}
