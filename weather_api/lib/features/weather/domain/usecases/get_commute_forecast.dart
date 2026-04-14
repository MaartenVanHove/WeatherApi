// domain/usecases/get_commute_forecast.dart
import 'package:weather_api/domain/entities/weather.dart';
import 'package:weather_api/domain/repositories/weather_repository.dart';

class GetCommuteForecast {
  final WeatherRepository repository;

  GetCommuteForecast(this.repository);

  Future<Map<String, Weather>> execute(double lat, double lon) async {
    final List<Weather> fullList = await repository.getFiveDayForecast(
      lat,
      lon,
    );

    // Filter logic: Find the first item that is tomorrow at 09:00
    // and tomorrow at 18:00
    final morning = fullList.firstWhere(
      (w) => w.time.hour == 9 && w.time.day == DateTime.now().day + 1,
      orElse: () => fullList.first, // Fallback
    );

    final evening = fullList.firstWhere(
      (w) => w.time.hour == 16 && w.time.day == DateTime.now().day + 1,
      orElse: () => fullList.first,
    );

    return {'morning': morning, 'evening': evening};
  }
}
