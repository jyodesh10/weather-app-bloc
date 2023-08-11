part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}
class WeatherLoadingState extends WeatherState {}
class WeatherLoadedState extends WeatherState {
  final CurrentWeatherModel data;

  const WeatherLoadedState({required this.data});

  @override
  List<Object> get props => [data];
}
class WeatherErrorState extends WeatherState {
  final String error;

  const WeatherErrorState(this.error);
  @override
  List<Object> get props => [error];
}
