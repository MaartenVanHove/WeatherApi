import 'dart:convert';

import 'package:weather_api/data/api/transport_api_service.dart';
import 'package:weather_api/domain/entities/transport/leg.dart';
import 'package:weather_api/domain/entities/transport/trip.dart';
import 'package:weather_api/domain/repositories/transport_repository.dart';
// Import this to use jsonDecode

class Transportrepositoryimpl implements TripRepository {
  final TransportApiService apiService;

  Transportrepositoryimpl(this.apiService);

  @override
  Future<List<Leg>> getTrip(
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
      return list.map((item) => Leg.fromListItem(item)).toList();
    } else {
      throw Exception('Failed to load Trips');
    }
  }
}
