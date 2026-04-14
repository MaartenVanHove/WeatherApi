import 'dart:ffi';

class Leg {
  const Leg({
    required String name,
    required String direction,
    required String origin,
    required String destination,
    required DateTime plannedTime,
    required String orginTrack,
    required String destinationTrack,
    required int stops,
  });

  factory Leg.fromListItem(Map<String, dynamic> json) {
    return Leg(
      name: json['name'] as String,
      direction: json['direction'] as String,
      origin: json['origin']['name'],
      destination: json['destination']['name'] as String,
      plannedTime: DateTime.parse(json['origin']['plannedDateTime'] as String),
      orginTrack: json['origin']['plannedTrack'],
      destinationTrack: json['destination']['plannedTrack'],
      stops: json['stops'] as int,
    );
  }
}
