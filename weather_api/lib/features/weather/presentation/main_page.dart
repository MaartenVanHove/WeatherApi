import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import Data Layer (for initialization)
import 'package:weather_api/features/trips/data/api/transport_api_service.dart';
import 'package:weather_api/features/trips/data/repository/transportRepositoryImpl.dart';
import 'package:weather_api/features/trips/presentation/commute_trip_section.dart';
import 'package:weather_api/features/weather/data/api/weather_api_service.dart';
import 'package:weather_api/features/weather/data/repositories/weather_repository_impl.dart';

// Import Domain Layer (UseCases)
import 'package:weather_api/features/weather/domain/usecases/get_commute_forecast.dart';
import 'package:weather_api/features/trips/domain/usecases/get_commute_trip.dart';

// Import UI Sections
import 'commute_weather_section.dart';

class CommuteScreen extends StatelessWidget {
  const CommuteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Formatting and Time Setup
    final String formattedDate = DateFormat(
      'd MMM',
    ).format(DateTime.now()).toUpperCase();
    final now = DateTime.now();
    final DateTime targetTime = DateTime(now.year, now.month, now.day, 11, 00);

    // Dependency Setup
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

                _buildHeader(formattedDate),

                const SizedBox(height: 30),

                // --- Weather Section ---
                CommuteWeatherSection(getCommuteWeather: getCommuteWeather),

                const SizedBox(height: 25),

                // --- Trip Section ---
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: CommuteTripSection(
                      getCommuteTrip: getCommuteTrip,
                      dateTime: targetTime,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String date) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            "TODAY, $date",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              letterSpacing: 1.2,
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.white, size: 20),
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
    );
  }
}
