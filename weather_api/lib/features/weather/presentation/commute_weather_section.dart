import 'package:flutter/material.dart';
import 'package:weather_api/features/weather/domain/entities/weather.dart';
import 'package:weather_api/features/weather/domain/usecases/get_commute_forecast.dart';

class CommuteWeatherSection extends StatelessWidget {
  final GetCommuteForecast getCommuteWeather;

  const CommuteWeatherSection({super.key, required this.getCommuteWeather});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Weather>>(
      future: getCommuteWeather.execute(52.3676, 4.9041),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.orangeAccent),
          );
        }
        if (snapshot.hasData) {
          final morning = snapshot.data!["morning"]!;
          final afternoon = snapshot.data!['afternoon']!;
          return Row(
            children: [
              Expanded(
                child: _buildWeatherCard(
                  title: "MORNING",
                  temp: "${morning.temp.round()}°C",
                  time: "9:00 AM",
                  desc: morning.description,
                  colors: [Colors.orangeAccent, Colors.deepOrange],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildWeatherCard(
                  title: "EVENING",
                  temp: "${afternoon.temp.round()}°C",
                  time: "4:00 PM",
                  desc: afternoon.description,
                  colors: [Colors.deepPurpleAccent, Colors.indigo],
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildWeatherCard({
    required String title,
    required String temp,
    required String time,
    required String desc,
    required List<Color> colors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colors[0].withOpacity(0.8), colors[1].withOpacity(0.8)],
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            temp,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            desc,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
