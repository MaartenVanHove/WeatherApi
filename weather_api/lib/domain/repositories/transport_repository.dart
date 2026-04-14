import 'package:weather_api/domain/entities/transport/leg.dart';

abstract class TripRepository {
  Future<List<Leg>> getTrip(
    String fromStation,
    String toStation,
    String arrivalTime,
  );
}
