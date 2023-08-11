import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/presentation/bloc/bloc/weather_bloc.dart';
import 'package:weather_bloc/presentation/bloc/cubit/location_cubit.dart';
import 'package:weather_bloc/presentation/bloc/cubit/swipe_cubit.dart';
import 'package:weather_bloc/presentation/screens/home/home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SwipeCubit()),
        BlocProvider(create: (context) => LocationCubit()..loadLocation()),
        BlocProvider(create: (context) => WeatherBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
