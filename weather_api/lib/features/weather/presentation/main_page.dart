import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_api/features/trips/data/api/transport_api_service.dart';
import 'package:weather_api/features/trips/data/repository/transportRepositoryImpl.dart';
import 'package:weather_api/features/trips/domain/entities/leg.dart';
import 'package:weather_api/features/trips/domain/usecases/get_commute_trip.dart';
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

    final now = DateTime.now();

    final DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      8, // Hour
      30, // Minute
    );

    final getCommuteWeather = GetCommuteForecast(
      WeatherRepositoryImpl(WeatherApiService()),
    );
    final getCommuteTrip = GetCommuteTrip(TripRepositoryImpl(TripApiService()));

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: Padding(
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
                Container(
                  width: double.infinity,
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
                FutureBuilder<Map<String, Weather>>(
                  future: getCommuteWeather.execute(52.3676, 4.9041),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orangeAccent,
                        ),
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
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: FutureBuilder(
                    future: getCommuteTrip.execute('asdm', 'ass', dateTime),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text(
                          "Error getting trips",
                          style: TextStyle(color: Colors.red),
                        );
                      }
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: _buildTrainCard(snapshot.data!.legs),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
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

  Widget _buildTrainCard(List<Leg> legs) {
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
        mainAxisSize: MainAxisSize.min,
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
          for (int i = 0; i < legs.length; i++) ...[
            if (i > 0) const Divider(color: Colors.white10, height: 20),
            _trainRow(legs[i]),
          ],
        ],
      ),
    );
  }

  Widget _trainRow(Leg leg) {
    final startTime = leg.plannedTimeDepartment.toString().substring(11, 16);
    final endTime = leg.plannedTimeArrival.toString().substring(11, 16);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const Icon(Icons.train, color: Colors.orangeAccent, size: 22),
              const SizedBox(height: 4),
              Text(
                "${leg.stops} stops",
                style: const TextStyle(color: Colors.white38, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$startTime → $endTime",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${leg.name} • Dir: ${leg.direction}",
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _stationTrackRow(leg.origin, leg.originTrack),
                const Icon(
                  Icons.arrow_downward,
                  size: 12,
                  color: Colors.white24,
                ),
                _stationTrackRow(leg.destination, leg.destinationTrack),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stationTrackRow(String station, String track) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            station,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            track,
            style: const TextStyle(
              color: Colors.orangeAccent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
