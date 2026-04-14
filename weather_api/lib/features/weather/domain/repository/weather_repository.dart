import 'package:weather_api/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<List<Weather>> getFiveDayForecast(double lat, double lon);
}
