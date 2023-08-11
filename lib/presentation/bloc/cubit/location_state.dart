part of 'location_cubit.dart';

class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {
  final String location;

  const LocationInitial({required this.location});
  @override
  List<Object> get props => [location];
}
