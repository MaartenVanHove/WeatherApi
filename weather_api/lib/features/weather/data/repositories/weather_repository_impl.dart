import 'dart:convert';

import 'package:weather_api/features/weather/data/api/weather_api_service.dart';
import 'package:weather_api/features/weather/domain/entities/weather.dart';
import 'package:weather_api/features/weather/domain/repository/weather_repository.dart'; // Import this to use jsonDecode

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherApiService apiService;

  WeatherRepositoryImpl(this.apiService);

  @override
  Future<List<Weather>> getFiveDayForecast(double lat, double lon) async {
    final response = await apiService.fetchWeather(lat, lon);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final List<dynamic> list = data['list'];

      return list.map((item) => Weather.fromListItem(item)).toList();
    } else {
      throw Exception('Failed to load Weather');
    }
  }
}
