import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_bloc/constants.dart';
import 'package:weather_bloc/presentation/bloc/bloc/weather_bloc.dart';
import 'package:weather_bloc/presentation/bloc/cubit/swipe_cubit.dart';

import '../../../data/models/current_weather_model.dart';
import '../../../widgets/custom_buttom.dart';
import '../../../widgets/custom_clipper.dart';
import '../../../widgets/shimmer_loading.dart';
import '../../bloc/cubit/location_cubit.dart';
import '../settings/settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String location;

  @override
  void initState() {
    super.initState();
    loadLocation().then((value) {
      BlocProvider.of<WeatherBloc>(context).add(LoadCurrentWeather(location));
      Timer.periodic(const Duration(minutes: 20), (timer) {
        BlocProvider.of<WeatherBloc>(context).add(LoadCurrentWeather(location));
        // BlocProvider.of<WeatherBloc>(context).add(LoadCurrentWeather(context.read<LocationCubit>().state));
      });
    });
  }

  Future<void> loadLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('location') ?? 'lalitpur';
    location =  name;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgrd,
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, weatherState) {
          if (weatherState is WeatherLoadingState) {
            return const ShimmerLoading();
          }
          if (weatherState is WeatherLoadedState) {
            return BlocBuilder<SwipeCubit, bool>(
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: () async {
                    Future.delayed(
                      const Duration(seconds: 1),
                      () => BlocProvider.of<WeatherBloc>(context)
                          .add(LoadCurrentWeather(context.read<LocationCubit>().state)),
                    );
                  },
                  child: SafeArea(
                    child: Column(
                      children: [
                        _buildDayContainer(context, state, weatherState.data),
                        // const SizedBox(
                        //   height: 25,
                        // ),
                        _buildNightContainer(context, state, weatherState.data),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          if (weatherState is WeatherErrorState){
            return Center(child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(weatherState.error, style: titleStyle, ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  color: primary,
                  onPressed: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(), 
                      ) 
                    );
                  },
                  title: "Change Location"
                ),
              ],
            ));
          }
          return const Center(child: Text('No data, style: titleStyle,'));
        },
      ),
    );
  }

  _buildDayContainer(
      BuildContext context, bool state, CurrentWeatherModel weatherState) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        int sensitivity = 8;
        if (details.delta.dy > sensitivity) {
          // Down Swipe
          context.read<SwipeCubit>().swipeDownEvent();
        } else if (details.delta.dy < -sensitivity) {
          context.read<SwipeCubit>().swipeUpEvent();
          // Up Swipe
        }
      },
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: state != true ? deviceHeight * 0.23 : deviceHeight * 0.65,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 20)
              .copyWith(top: 20)
              .copyWith(bottom: 20),
          padding: state != true ? const EdgeInsets.all(25) : EdgeInsets.zero,
          // decoration: BoxDecoration(
          //     color: primary, borderRadius: BorderRadius.circular(40)),
          decoration: BoxDecoration(
              color: primaryDrk,
              gradient: const LinearGradient(
                  colors: [primaryDrk, primaryMidDrk, primaryLightDrk],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.3, 0.6, 1]),
              borderRadius: BorderRadius.circular(40)),
          child: state != true
              ? Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text("Day",
                                    style: titleStyle.copyWith(color: white))),
                            const Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.api_rounded,
                                  color: white,
                                  size: 25,
                                )),
                            Expanded(flex: 1, child: Container()),
                          ],
                        ),
                        const Spacer(),
                        //degree
                        RichText(
                            text: TextSpan(
                                text: weatherState.current.tempC
                                    .toString()
                                    .split('.')[0],
                                style: headingStyle.copyWith(
                                    fontSize: 50, fontWeight: FontWeight.bold),
                                children: [
                              TextSpan(
                                text: "°C",
                                style: headingStyle.copyWith(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              )
                            ])),
                        const Spacer(),
                        //swipe text
                        Text(
                          'Swipe down to see details',
                          style: subtitleStyle.copyWith(color: white),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Hero(
                      tag: 'day',
                      child: Image.network(
                        weatherState.current.condition.icon
                            .toString()
                            .replaceAll(RegExp(r'//'), 'https://'),
                        // "assets/weather.png",
                        height: 60,
                      ),
                    )
                  ],
                )
              : Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ClipPath(
                      clipper: ClipPathClipper(),
                      child: Container(
                        height: 220,
                        decoration: const BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(40))),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        height: deviceHeight * 0.65,
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          children: [
                            //top
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text("Day", style: titleStyle)),
                                const Expanded(
                                    flex: 1,
                                    child: Icon(
                                      Icons.api_rounded,
                                      color: white,
                                      size: 25,
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: /* menutap */ () {
                                            Navigator.push(
                                              context, 
                                              MaterialPageRoute(
                                                builder: (context) => SettingsScreen(), 
                                              ) 
                                            );
                                          },
                                          child: const Icon(
                                            Icons.menu_rounded,
                                            color: white,
                                            size: 25,
                                          ),
                                        ))),
                              ],
                            ),
                            const Spacer(),
                            //image
                            SizedBox(
                              height: 200,
                              child: Hero(
                                  tag: 'day',
                                  child: Image.network(
                                    weatherState.current.condition.icon
                                        .toString()
                                        .replaceAll(
                                          RegExp(r'//'),
                                          'https://',
                                        ),
                                    scale: 0.4,
                                    // "assets/weather.png"
                                  )),
                            ),
                            //condition text
                            Text(
                              weatherState.current.condition.text.toString(),
                              style: subtitleStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                            //degree
                            RichText(
                                text: TextSpan(
                                    text: weatherState.current.tempC
                                        .toString()
                                        .split('.')[0],
                                    style: headingStyle.copyWith(
                                        fontSize: 70,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                  TextSpan(
                                    text: "°C",
                                    style: headingStyle.copyWith(
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold),
                                  )
                                ])),
                            //location
                            Text(weatherState.location.name,
                                style: headingStyle),
                            const Spacer(),
                            //more info
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "Wind From",
                                      style: subtitleStyle,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            text: weatherState.current.windKph
                                                .toString(),
                                            style: headingStyle,
                                            children: <TextSpan>[
                                          TextSpan(
                                              text: "k/h", style: subtitleStyle)
                                        ])),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "Humidity",
                                      style: subtitleStyle,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            text: weatherState.current.humidity
                                                .toString(),
                                            style: headingStyle,
                                            children: <TextSpan>[
                                          TextSpan(
                                              text: "%", style: subtitleStyle)
                                        ])),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text("Precipitation", style: subtitleStyle),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            text: weatherState.current.precipIn
                                                .toString(),
                                            style: headingStyle,
                                            children: <TextSpan>[
                                          TextSpan(
                                              text: "In", style: subtitleStyle)
                                        ])),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
    );
  }

  _buildNightContainer(
      BuildContext context, bool state, CurrentWeatherModel weatherState) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        int sensitivity = 2;
        if (details.delta.dy > sensitivity) {
          context.read<SwipeCubit>().swipeDownEvent();
          // Down Swipe
        } else if (details.delta.dy < -sensitivity) {
          context.read<SwipeCubit>().swipeUpEvent();
          // Up Swipe
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: state != true ? deviceHeight * 0.65 : deviceHeight * 0.23,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
        padding: state != true ? EdgeInsets.zero : const EdgeInsets.all(25),
        decoration: BoxDecoration(
            color: dark,
            gradient: const LinearGradient(
                colors: [darklight, darkmid, darkdrk],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.1, 0.4, 1]),
            borderRadius: BorderRadius.circular(40)),
        child: state != true
            ? Stack(
                alignment: Alignment.topCenter,
                children: [
                  ClipPath(
                    clipper: ClipPathClipper(),
                    child: Container(
                      height: 220,
                      decoration: const BoxDecoration(
                          color: dark,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(40))),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      height: deviceHeight * 0.65,
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          //top
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Text("Night", style: titleStyle)),
                              const Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.api_rounded,
                                    color: white,
                                    size: 25,
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context, 
                                            MaterialPageRoute(
                                              builder: (context) => SettingsScreen(), 
                                            ) 
                                          );
                                        },
                                        child: const Icon(
                                          Icons.menu_rounded,
                                          color: white,
                                          size: 25,
                                        ),
                                      ))),
                            ],
                          ),
                          const Spacer(),
                          //image,
                          SizedBox(
                            height: 200,
                            child: Hero(
                                tag: "night",
                                child: Image.network(
                                  weatherState.forecast.forecastday.first.hour
                                      .where((element) =>
                                          element.time.split(" ")[1] == "20:00")
                                      .first
                                      .condition
                                      .icon
                                      .replaceAll(RegExp(r'//'), 'https://'),
                                  scale: 0.4,
                                  // "assets/night.png"
                                )),
                          ),
                          //condition text
                          Text(
                            weatherState.forecast.forecastday.first.hour
                                .where((element) =>
                                    element.time.split(" ")[1] == "20:00")
                                .first
                                .condition
                                .text
                                .toString(),
                            style: subtitleStyle.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          //degree
                          RichText(
                              text: TextSpan(
                                  text: weatherState
                                      .forecast.forecastday.first.hour
                                      .where((element) =>
                                          element.time.split(" ")[1] == "20:00")
                                      .first
                                      .tempC
                                      .toString()
                                      .split('.')[0],
                                  style: headingStyle.copyWith(
                                      fontSize: 70,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                TextSpan(
                                  text: "°C",
                                  style: headingStyle.copyWith(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                )
                              ])),
                          //location
                          Text(weatherState.location.name, style: headingStyle),
                          const Spacer(),
                          //more info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Wind From",
                                    style: subtitleStyle,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          text: weatherState
                                              .forecast.forecastday.first.hour
                                              .where((element) =>
                                                  element.time.split(" ")[1] ==
                                                  "20:00")
                                              .first
                                              .windKph
                                              .toString(),
                                          style: headingStyle,
                                          children: <TextSpan>[
                                        TextSpan(
                                            text: "k/h", style: subtitleStyle)
                                      ])),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    "Humidity",
                                    style: subtitleStyle,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          text: weatherState
                                              .forecast.forecastday.first.hour
                                              .where((element) =>
                                                  element.time.split(" ")[1] ==
                                                  "20:00")
                                              .first
                                              .humidity
                                              .toString(),
                                          style: headingStyle,
                                          children: <TextSpan>[
                                        TextSpan(
                                            text: "%", style: subtitleStyle)
                                      ])),
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Precipitation", style: subtitleStyle),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  RichText(
                                      text: TextSpan(
                                          text: weatherState
                                              .forecast.forecastday.first.hour
                                              .where((element) =>
                                                  element.time.split(" ")[1] ==
                                                  "20:00")
                                              .first
                                              .precipIn
                                              .toString(),
                                          style: headingStyle,
                                          children: <TextSpan>[
                                        TextSpan(
                                            text: "In", style: subtitleStyle)
                                      ])),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Stack(
                alignment: Alignment.topRight,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("Night",
                                  style: titleStyle.copyWith(color: whiteDrk))),
                          const Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.api_rounded,
                                color: whiteDrk,
                                size: 25,
                              )),
                          Expanded(flex: 1, child: Container()),
                        ],
                      ),
                      const Spacer(),
                      //degree
                      RichText(
                          text: TextSpan(
                              text: weatherState
                                .forecast.forecastday.first.hour
                                .where((element) =>
                                    element.time.split(" ")[1] == "20:00")
                                .first
                                .tempC
                                .toString()
                                .split('.')[0],
                              style: headingStyle.copyWith(
                                  fontSize: 50, fontWeight: FontWeight.bold),
                              children: [
                            TextSpan(
                              text: "°C",
                              style: headingStyle.copyWith(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            )
                          ])),
                      const Spacer(),
                      //swipe text
                      Text(
                        'Swipe up to see details',
                        style: subtitleStyle.copyWith(color: whiteDrk),
                      ),
                      const Spacer(),
                    ],
                  ),
                  Hero(
                    tag: "night",
                    child: Image.network(
                      weatherState.forecast.forecastday.first.hour
                          .where((element) =>
                              element.time.split(" ")[1] == "20:00")
                          .first
                          .condition
                          .icon
                          .replaceAll(RegExp(r'//'), 'https://'),
                      // "assets/night.png",
                      height: 60,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
