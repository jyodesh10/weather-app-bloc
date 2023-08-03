import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/constants.dart';
import 'package:weather_bloc/presentation/bloc/bloc/weather_bloc.dart';
import 'package:weather_bloc/presentation/bloc/cubit/swipe_cubit.dart';

import '../../../data/models/current_weather_model.dart';
import '../../../widgets/custom_clipper.dart';
import '../../../widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController locController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(minutes: 15), (timer) {
      BlocProvider.of<WeatherBloc>(context).add(const LoadCurrentWeather());
    });
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
                    Future.delayed(const Duration(seconds: 1),
                    () => BlocProvider.of<WeatherBloc>(context).add(const LoadCurrentWeather()),
                    );
                  },
                  child: SafeArea(
                    child: Column(
                      children: [
                        _buildDayContainer(context, state, weatherState.data),
                        const SizedBox(
                          height: 25,
                        ),
                        _buildNightContainer(context, state, weatherState.data)
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Text('No data');
        },
      ),
    );
  }

  _buildDayContainer(
      BuildContext context, bool state, CurrentWeatherModel weatherState) {
    return state != true
        ? Expanded(
            flex: 2,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                int sensitivity = 8;
                if (details.delta.dy > sensitivity) {
                  // Down Swipe
                  context.read<SwipeCubit>().swipeDownEvent();
                } else if (details.delta.dy < -sensitivity) {
                  // Up Swipe
                }
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20)
                      .copyWith(top: 20)
                      .copyWith(bottom: 20),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: primary, borderRadius: BorderRadius.circular(40)),
                  child: Stack(
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
                                      style:
                                          titleStyle.copyWith(color: white))),
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
                          Text(
                            weatherState.current.tempC.toString().split('.')[0],
                            style: headingStyle.copyWith(
                                color: white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold),
                          ),
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
                        child: Image.asset(
                          "assets/weather.png",
                          height: 60,
                        ),
                      )
                    ],
                  )),
            ))
        : Expanded(
            flex: 5,
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 20),
              decoration: BoxDecoration(
                  color: primaryDrk,
                  gradient: const LinearGradient(
                      colors: [primaryDrk, primaryMidDrk, primaryLightDrk],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.3, 0.6, 1]),
                  borderRadius: BorderRadius.circular(40)),
              child: Stack(
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
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        //top
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 1, child: Text("Day", style: titleStyle)),
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
                                      onTap: menutap,
                                      child: const Icon(
                                        Icons.menu_rounded,
                                        color: white,
                                        size: 25,
                                      ),
                                    ))),
                          ],
                        ),

                        //image,
                        SizedBox(
                          height: 250,
                          child: Hero(
                              tag: 'day',
                              child: Image.asset("assets/weather.png")),
                        ),
                        //degree
                        Text(
                          weatherState.current.tempC.toString().split('.')[0],
                          style: headingStyle.copyWith(
                              fontSize: 70, fontWeight: FontWeight.bold),
                        ),
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
                                      TextSpan(text: "%", style: subtitleStyle)
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
                                      TextSpan(text: "In", style: subtitleStyle)
                                    ])),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ));
  }

  _buildNightContainer(
      BuildContext context, bool state, CurrentWeatherModel weatherState) {
    return state != true
        ? Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20)
                  .copyWith(bottom: 20),
              decoration: BoxDecoration(
                  color: dark,
                  gradient: const LinearGradient(
                      colors: [darklight, darkmid, darkdrk],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1, 0.4, 1]),
                  borderRadius: BorderRadius.circular(40)),
              child: Stack(
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
                  Container(
                    height: double.infinity,
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
                            const Expanded(
                                flex: 1,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.menu_rounded,
                                      color: white,
                                      size: 25,
                                    ))),
                          ],
                        ),

                        //image,
                        SizedBox(
                          height: 250,
                          child: Image.asset("assets/night.png"),
                        ),
                        //degree
                        Text(
                          weatherState.current.tempC.toString().split('.')[0],
                          style: headingStyle.copyWith(
                              fontSize: 70, fontWeight: FontWeight.bold),
                        ),
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
                                      TextSpan(text: "%", style: subtitleStyle)
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
                                      TextSpan(text: "In", style: subtitleStyle)
                                    ])),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ))
        : Expanded(
            flex: 2,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                int sensitivity = 8;
                if (details.delta.dy > sensitivity) {
                  // Down Swipe
                } else if (details.delta.dy < -sensitivity) {
                  context.read<SwipeCubit>().swipeUpEvent();
                  // Up Swipe
                }
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20)
                      .copyWith(bottom: 20),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      color: dark, borderRadius: BorderRadius.circular(40)),
                  child: Stack(
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
                                      style: titleStyle.copyWith(
                                          color: whiteDrk))),
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
                          Text(
                            weatherState.current.tempC.toString().split('.')[0],
                            style: headingStyle.copyWith(
                                color: whiteDrk,
                                fontSize: 50,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          //swipe text
                          Text(
                            'Swipe up to see details',
                            style: subtitleStyle.copyWith(color: whiteDrk),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Image.asset(
                        "assets/night.png",
                        height: 60,
                      )
                    ],
                  )),
            ));
  }

  void menutap() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgrd,
          title: Text(
            'Settings',
            style: titleStyle,
          ),
          content: BlocProvider(
            create: (context) => WeatherBloc(),
            child: Builder(
              builder: (context) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("Loaction", style: subtitleStyle)),
                          Expanded(
                              flex: 1,
                              child: TextField(
                                controller: locController,
                                style: subtitleStyle,
                                decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: white))),
                              )),
                        ],
                      ),
                      MaterialButton(
                          color: primary,
                          child: Text('Submit', style: titleStyle),
                          onPressed: () {
                            // context.read<WeatherBloc>().location = locController.text;
                            BlocProvider.of<WeatherBloc>(context)
                                .add(UpdateLocation(locController.text));
                            BlocProvider.of<WeatherBloc>(context).add(const LoadCurrentWeather());
                            Navigator.pop(context);
                          })
                    ],
                  ),
                );
              }
            ),
          ),
        );
      },
    );
  }
}
