import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_api/features/weather/data/api/weather_api_service.dart';
import 'package:weather_api/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:weather_api/features/weather/domain/entities/weather.dart';
import 'package:weather_api/features/weather/domain/usecases/get_commute_forecast.dart';

class CommuteScreen extends StatelessWidget {
  const CommuteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'd MMM',
    ).format(DateTime.now()).toUpperCase();

    final apiService = WeatherApiService();
    final repository = WeatherRepositoryImpl(apiService);
    final getCommuteWeather = GetCommuteForecast(repository);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Map<String, Weather>>(
            future: getCommuteWeather.execute(52.3676, 4.9041),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orangeAccent),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }

              if (snapshot.hasData) {
                final morning = snapshot.data!["morning"]!;
                final evening = snapshot.data!['evening']!;

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "DAILY COMMUTE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Header Date Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "TODAY, $formattedDate",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "AMSTERDAM",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Weather Forecast Cards
                      Row(
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
                              temp: "${evening.temp.round()}°C",
                              time: "4:00 PM",
                              desc: evening.description,
                              colors: [Colors.deepPurpleAccent, Colors.indigo],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      _buildTrainCard(),
                    ],
                  ),
                );
              }

              // Fallback for unexpected empty data
              return const Center(
                child: Text(
                  "No data available",
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper method for Weather Cards
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
          colors: [
            colors[0].withValues(alpha: 0.8),
            colors[1].withValues(alpha: 0.8),
          ],
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

  // Helper method for the Train UI
  Widget _buildTrainCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orangeAccent.withValues(alpha: 0.5),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const Text(
            "BEST TRAIN OPTIONS",
            style: TextStyle(
              color: Colors.orangeAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _trainRow("09:07", "09:24", "NS Intercity", "Zuid"),
          const Divider(color: Colors.white10),
          _trainRow("18:03", "18:21", "NS Sprinter", "Centraal"),
        ],
      ),
    );
  }

  Widget _trainRow(String start, String end, String type, String dest) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.train, color: Colors.white70),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$start → $end",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                type,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          Text(dest, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
