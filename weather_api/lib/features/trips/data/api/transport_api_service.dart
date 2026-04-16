import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TripApiService {
  final String testUrl =
      "https://gateway.apiportal.ns.nl/reisinformatie-api/api/v3/trips?fromStation=asd&toStation=ass&dateTime=2026-04-14T15:30:00Z&searchForArrival=true&subscription-key=2499fb6797b4486b8b1832e6dc1ac64f";

  Future<http.Response> fetchTrips(
    String fromStation,
    String toStation,
    DateTime arrivalTime,
  ) async {
    // 2. Format it specifically for the NS API (yyyy-MM-ddTHH:mm:ss)
    // Do NOT use .toIso8601String() because it often adds the Z or offset
    String apiFormattedDate = DateFormat(
      "yyyy-MM-ddTHH:mm:ss",
    ).format(arrivalTime);
    return http.get(
      Uri.parse(
        "https://gateway.apiportal.ns.nl/reisinformatie-api/api/v3/trips?fromStation=$fromStation&toStation=$toStation&dateTime=$apiFormattedDate&searchForArrival=true&subscription-key=2499fb6797b4486b8b1832e6dc1ac64f",
      ),
    );
  }
}
