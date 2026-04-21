class WeatherService {
  static Future<Map<String, dynamic>> getWeatherPrediction(String city) async {
    return {
      'prediction': 'Sunny weather expected in $city. Low flood risk.',
      'temperature': 32,
      'condition': 'Sunny',
    };
  }
}