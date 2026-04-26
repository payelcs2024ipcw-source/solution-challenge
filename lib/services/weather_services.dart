import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = 'b62005cba3ea04edb266b3f8d89a502c';

  static Future<Map<String, dynamic>> getWeatherPrediction(String city) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final weather = data['weather'][0]['main'];
        final temp = data['main']['temp'];
        return {
          'weather': weather,
          'temperature': temp,
          'prediction': _predictNeeds(weather, temp.toDouble()),
        };
      }
      return {'prediction': 'Unable to fetch weather data'};
    } catch (e) {
      return {'prediction': 'Weather service unavailable'};
    }
  }

  static String _predictNeeds(String weather, double temp) {
    if (weather == 'Rain' || weather == 'Thunderstorm') {
      return 'Heavy rain expected — shelter and food needs likely to increase';
    } else if (temp > 40) {
      return 'Extreme heat alert — medical volunteers urgently needed';
    } else if (temp < 10) {
      return 'Cold weather — shelter and warm food needs expected';
    } else {
      return 'Normal weather — standard volunteer coverage sufficient';
    }
  }
}