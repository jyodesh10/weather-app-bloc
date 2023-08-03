import 'package:weather_bloc/data/datasources/weather_datasource.dart';

import '../models/current_weather_model.dart';

class WeatherRepository {

  Future<CurrentWeatherModel> getCurrentWeather() async {
    return WeatherDataSource().fetchCurrentWeather();
  }
  
}