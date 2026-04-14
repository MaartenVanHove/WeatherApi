import 'dart:convert';

import 'package:weather_api/features/trips/data/api/transport_api_service.dart';
import 'package:weather_api/features/trips/domain/entities/trip.dart';
import 'package:weather_api/features/trips/domain/repository/transport_repository.dart';

class Transportrepositoryimpl implements TripRepository {
  final TransportApiService apiService;

  Transportrepositoryimpl(this.apiService);

  @override
  Future<List<Trip>> getTrip(
    // Change return type to List<Trip>
    String fromStation,
    String toStation,
    String arrivalTime,
  ) async {
    final response = await apiService.fetchTrips(
      fromStation,
      toStation,
      arrivalTime,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> list = data['trips'];

      return list.map((item) => Trip.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Trips');
    }
  }
}
