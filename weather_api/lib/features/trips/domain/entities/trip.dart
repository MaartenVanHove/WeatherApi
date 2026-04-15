import 'package:weather_api/features/trips/domain/entities/leg.dart';

class Trip {
  final String? tripId;
  final List<Leg> legs;
  final int durationInMinutes;

  const Trip({
    this.tripId,
    required this.legs,
    required this.durationInMinutes,
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripId: json['idx'].toString(),
      legs: (json['legs'] as List)
          .map((legJson) => Leg.fromListItem(legJson))
          .toList(),
      durationInMinutes: json['plannedDurationInMinutes'],
    );
  }
}
