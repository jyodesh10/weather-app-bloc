import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<String> {
  LocationCubit() : super('') {
    loadLocation(); // Load the location when the cubit is created
  }

  // Load the name from shared preferences
  void loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('location') ?? 'lalitpur';
    emit(name);
  }

  // Save the name to shared preferences
  void saveLocation(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('location', name);
    emit(name);
  }
}