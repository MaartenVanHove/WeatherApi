import 'dart:ffi';

class Leg {
  final String name;
  final String direction;
  final String origin;
  final String destination;
  final DateTime plannedTime;
  final String originTrack; // Fixed spelling to 'origin'
  final String destinationTrack;
  final int stops;

  const Leg({
    required this.name,
    required this.direction,
    required this.origin,
    required this.destination,
    required this.plannedTime,
    required this.originTrack,
    required this.destinationTrack,
    required this.stops,
  });

  factory Leg.fromListItem(Map<String, dynamic> json) {
    return Leg(
      name: json['name'] as String,
      direction: json['direction'] as String,
      origin: json['origin']['name'] as String,
      destination: json['destination']['name'] as String,
      plannedTime: DateTime.parse(json['origin']['plannedDateTime'] as String),
      originTrack: json['origin']['plannedTrack'] ?? 'N/A',
      destinationTrack: json['destination']['plannedTrack'] ?? 'N/A',
      // Handling 'stops'—if it's a list in JSON, we take the length
      stops: json['stops'] is List
          ? (json['stops'] as List).length
          : (json['stops'] as int),
    );
  }
}
