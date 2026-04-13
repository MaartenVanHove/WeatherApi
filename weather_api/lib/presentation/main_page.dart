import 'package:flutter/material.dart';
import 'package:weather_api/data/api/api_service.dart';
import 'package:weather_api/data/repositories/weather_repository_impl.dart';
import 'package:weather_api/domain/entities/weather.dart';
import 'package:weather_api/domain/usecases/get_commute_forecast.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("DAILY COMMUTE")),
      body: Column(
        children: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              final apiService = WeatherApiService();
              final repository = WeatherRepositoryImpl(apiService);

              final getCommuteWeather = GetCommuteForecast(repository);

              try {
                final commute = await getCommuteWeather.execute(
                  52.3676,
                  4.9041,
                );

                final morning = commute['morning']!;
                final evening = commute['evening']!;

                print("MORNING: ${morning.temp}°C, ${morning.description}");
                print("EVENING: ${evening.temp}°C, ${evening.description}");
              } catch (e) {
                print("Error: $e");
              }
            },
          ),
        ],
      ),
    );
  }
}
