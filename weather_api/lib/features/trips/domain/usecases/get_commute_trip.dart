import 'package:weather_api/features/trips/domain/entities/trip.dart';
import 'package:weather_api/features/trips/domain/repository/transport_repository.dart';

class GetCommuteTrip {
  final TripRepository tripRepository;

  const GetCommuteTrip({required this.tripRepository});

  Future<Trip> execute(
    String fromStation,
    String toStation,
    DateTime arrivalTime,
  ) async {
    final List<Trip> trips = await tripRepository.getTrip(
      fromStation,
      toStation,
      arrivalTime,
    );

    // TODO: Figure out which trip is the best one.

    return trips[0];
  }
}
