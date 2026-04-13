import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(), // City.
          Row(
            children: [Container(), Container()],
          ), // Morning and afternoon weather.
        ],
      ),
    );
  }
}
