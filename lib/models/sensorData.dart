import 'package:firebase_database/firebase_database.dart';

import 'file:///C:/Users/VK/Desktop/home_temperature/lib/auth/userAuth.dart';

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
    UserAuth _userAuth = UserAuth();
    return SensorData(
      temperature: document.value['${_userAuth.user.uid}']['TemperatureSensor']
          ['temp'],
      humidity: document.value['${_userAuth.user.uid}']['TemperatureSensor']
          ['hum'],
      isRaining: document.value['${_userAuth.user.uid}']['RainSensor']
          ['raining'],
      intensity: document.value['${_userAuth.user.uid}']['RainSensor']
          ['intensity'],
    );
  }
}
