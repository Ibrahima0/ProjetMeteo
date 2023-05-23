import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = '3d72eb9c6a2dff0929b622988c5001ad';

  Future<Map<String, dynamic>> getCurrentWeather(String location) async {
    final endpoint = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey');
    final response = await http.get(endpoint);
    final body = jsonDecode(response.body);
    return body;
  }

  double convertToCelsius(double kelvin) {
    return kelvin - 273.15;
  }
}
