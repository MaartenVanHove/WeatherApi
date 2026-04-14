import 'package:weather_api/features/weather/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<List<Weather>> getFiveDayForecast(double lat, double lon);
}
