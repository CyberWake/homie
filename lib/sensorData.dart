import 'package:firebase_database/firebase_database.dart';

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
