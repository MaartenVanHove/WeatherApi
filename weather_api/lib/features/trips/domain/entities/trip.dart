import 'package:weather_api/features/trips/domain/entities/leg.dart';

class Trip {
  final String? tripId;
  final List<Leg> legs;

  const Trip({this.tripId, required this.legs});

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      tripId: json['idx'] as String?,
      legs: (json['legs'] as List)
          .map((legJson) => Leg.fromListItem(legJson))
          .toList(),
    );
  }
}
