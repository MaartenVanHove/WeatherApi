import 'package:http/http.dart' as http;

class WeatherApiService {
  Future<http.Response> fetchWeather(double lat, double lon) async {
    return http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=1070a4c98c9064d52c01d85986243889",
      ),
    );
  }
}
