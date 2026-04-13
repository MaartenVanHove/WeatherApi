import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_api/data/api/api_service.dart';
import 'package:weather_api/data/repositories/weather_repository_impl.dart';
import 'package:weather_api/domain/entities/weather.dart';
import 'package:weather_api/domain/usecases/get_commute_forecast.dart';
import 'package:weather_api/presentation/weather/weather_screen.dart';

class CommuteScreen extends StatelessWidget {
  const CommuteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      'd MMM',
    ).format(DateTime.now()).toUpperCase();
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "DAILY COMMUTE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "TODAY, $formattedDate",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.white70,
                              size: 24,
                            ),
                            SizedBox(width: 4),
                            Text(
                              "AMSTERDAM",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: _buildWeatherCard(
                          title: "MORNING",
                          temp: "6°C",
                          time: "9:00 AM",
                          desc: "Partly Cloudy",
                          colors: [Colors.orangeAccent, Colors.deepOrange],
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildWeatherCard(
                          title: "AFTERNOON",
                          temp: "11°C",
                          time: "6:00 PM",
                          desc: "Clear",
                          colors: [Colors.deepPurpleAccent, Colors.indigo],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildTrainCard(),
                ],
              ),
            ),
          ),
        ),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            colors[0].withValues(alpha: 0.8),
            colors[1].withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            temp,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            desc,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

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

// Column(
//         children: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () async {
//               final apiService = WeatherApiService();
//               final repository = WeatherRepositoryImpl(apiService);

//               final getCommuteWeather = GetCommuteForecast(repository);

//               try {
//                 final commute = await getCommuteWeather.execute(
//                   52.3676,
//                   4.9041,
//                 );

//                 final morning = commute['morning']!;
//                 final evening = commute['evening']!;

//                 print("MORNING: ${morning.temp}°C, ${morning.description}");
//                 print("EVENING: ${evening.temp}°C, ${evening.description}");
//               } catch (e) {
//                 print("Error: $e");
//               }
//             },
//           ),
//         ],
//       ),
