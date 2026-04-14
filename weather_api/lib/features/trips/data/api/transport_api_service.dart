import 'package:http/http.dart' as http;

class TransportApiService {
  final String testUrl =
      "https://gateway.apiportal.ns.nl/reisinformatie-api/api/v3/trips?fromStation=asd&toStation=ass&dateTime=2026-04-14T15:30:00Z&searchForArrival=true&subscription-key=2499fb6797b4486b8b1832e6dc1ac64f";

  Future<http.Response> fetchTrips(
    String fromStation,
    String toStation,
    String arrivalTime,
  ) async {
    return http.get(
      Uri.parse(
        "https://gateway.apiportal.ns.nl/reisinformatie-api/api/v3/trips?fromStation=$fromStation&toStation=$toStation&dateTime=$arrivalTime&searchForArrival=true&subscription-key=2499fb6797b4486b8b1832e6dc1ac64f",
      ),
    );
  }
}
