part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable{
  const WeatherEvent();

  @override
  List<Object> get props => [];
}


class LoadCurrentWeather extends WeatherEvent {
  final String location;
  const LoadCurrentWeather(this.location);


  @override
  List<Object> get props => [];
}

class UpdateLocation extends WeatherEvent {
  final String newLocation;

  const UpdateLocation(this.newLocation);
}
