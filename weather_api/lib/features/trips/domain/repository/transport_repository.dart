import 'package:weather_api/features/trips/domain/entities/trip.dart';

abstract class TripRepository {
  Future<List<Trip>> getTrip(
    String fromStation,
    String toStation,
    DateTime arrivalTime,
  );
}
