import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../../../data/models/current_weather_model.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  String location = 'kathmandu';
  WeatherBloc() : super(WeatherInitial()) {
    on<LoadCurrentWeather>((event, emit) async {
      emit(WeatherLoadingState());
      final response = await http.get(Uri.parse('$baseUrl/current.json?key=$weatherKey&q=$location'),);
      if (response.statusCode == 200) {
        final Map<String, dynamic> userJson = jsonDecode(response.body);
        var data = CurrentWeatherModel.fromJson(userJson);
        emit(WeatherLoadedState(data: data));
      } else {
        emit(WeatherErrorState());
      }
    });

    on<UpdateLocation>((event, emit) {
      location = event.newLocation;
      add(const LoadCurrentWeather());
    });
  }
}
