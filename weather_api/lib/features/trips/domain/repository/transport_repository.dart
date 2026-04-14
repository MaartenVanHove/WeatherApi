import 'package:weather_api/domain/entities/transport/trip.dart';

abstract class TripRepository {
  Future<List<Trip>> getTrip(
    String fromStation,
    String toStation,
    String arrivalTime,
  );
}
