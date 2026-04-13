import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
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
