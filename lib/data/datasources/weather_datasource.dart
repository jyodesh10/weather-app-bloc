import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../constants.dart';
import '../models/current_weather_model.dart';

class WeatherDataSource{
    Future<CurrentWeatherModel> fetchCurrentWeather() async {
      final response = await http.get(Uri.parse('$baseUrl/current.json'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userJson = jsonDecode(response.body);
        return CurrentWeatherModel.fromJson(userJson);
      } else {
        throw Exception('Failed to fetch user profile');
      }
    }

}