import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';
import 'custom_clipper.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black38,
      highlightColor: Colors.black54,
      period: const Duration(milliseconds: 1000),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                            child: Hero(
                                tag: 'day',
                                child: Image.asset("assets/weather.png")),
                          ),
                          //degree
                          Text(
                            '32',
                            style: headingStyle.copyWith(
                                fontSize: 70, fontWeight: FontWeight.bold),
                          ),
                          //location
                          Text('Kathmandu', style: headingStyle),
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
                                          text: "15",
                                          style: headingStyle,
                                          children: <TextSpan>[
                                        TextSpan(text: "km", style: subtitleStyle)
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
                                          text: "29",
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
                                          text: "45",
                                          style: headingStyle,
                                          children: <TextSpan>[
                                        TextSpan(text: "%", style: subtitleStyle)
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
              )
            ),
            const SizedBox(
              height: 25,
            ),
            Expanded(
              flex: 2,
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
                            '32',
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
                  )
                )
            )
          ],
        ),
      )
    );
  }
}