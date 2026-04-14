import 'package:weather_api/domain/entities/transport/leg.dart';

class Trip {
  const Trip({
    required List<Leg> legs,
    required DateTime startTime,
    required DateTime endTime,
  });
}
