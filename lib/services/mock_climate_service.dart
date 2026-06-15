import 'dart:math';

class ClimateData {
  final double temperature;
  final int humidity;
  final int windSpeed;
  final double precipitation;

  ClimateData({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.precipitation,
  });
}

class ClimateSearchEntry {
  final double latitude;
  final double longitude;
  final ClimateData data;
  final DateTime timestamp;

  ClimateSearchEntry({
    required this.latitude,
    required this.longitude,
    required this.data,
    required this.timestamp,
  });

  String get label =>
      '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
}

class MockClimateService {
  final _random = Random();

  Future<ClimateData> getClimateData(double latitude, double longitude) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final baseTemp = 28 - (latitude.abs() * 0.4);
    final tempVariation = _random.nextDouble() * 6 - 3;
    final temperature = (baseTemp + tempVariation).clamp(10, 45);

    final baseHumidity = 70 - (longitude.abs() * 0.2).toInt();
    final humidity = (baseHumidity + _random.nextInt(20) - 10).clamp(20, 100);

    final windSpeed = _random.nextInt(25) + 2;

    final precipitation =
        double.parse((_random.nextDouble() * 15).toStringAsFixed(1));

    return ClimateData(
      temperature: double.parse(temperature.toStringAsFixed(1)),
      humidity: humidity,
      windSpeed: windSpeed,
      precipitation: precipitation,
    );
  }

  Future<ClimateData> getClimateDataForEto(
      double latitude, double longitude) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final baseTemp = 28 - (latitude.abs() * 0.4);
    final temperature = baseTemp + _random.nextDouble() * 4 - 2;
    final humidity = (65 + _random.nextInt(20) - 10).clamp(20, 100);

    return ClimateData(
      temperature: double.parse(temperature.toStringAsFixed(1)),
      humidity: humidity,
      windSpeed: 0,
      precipitation: 0,
    );
  }
}
