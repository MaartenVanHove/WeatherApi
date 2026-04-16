import 'package:flutter/material.dart';
import 'package:weather_api/features/trips/domain/entities/leg.dart';
import 'package:weather_api/features/trips/domain/entities/trip.dart';
import 'package:weather_api/features/trips/domain/usecases/get_commute_trip.dart';

class CommuteTripSection extends StatelessWidget {
  final GetCommuteTrip getCommuteTrip;
  final DateTime dateTime;

  const CommuteTripSection({
    super.key,
    required this.getCommuteTrip,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCommuteTrip.execute('asdm', 'ass', dateTime),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        }
        if (snapshot.hasError) {
          return const Text(
            "Error getting trips",
            style: TextStyle(color: Colors.red),
          );
        }
        if (snapshot.hasData) {
          return _buildAvailableTrips(snapshot.data!);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAvailableTrips(List<Trip> trips) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "BEST TRAIN OPTIONS",
            style: TextStyle(
              color: Colors.orangeAccent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          for (int i = 0; i < trips.length; i++) ...[
            if (trips.isEmpty)
              Text("No available Trips", style: TextStyle(color: Colors.red)),
            _buildTripItem(trips[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildTripItem(Trip trip) {
    final firstLeg = trip.legs.first;
    final lastLeg = trip.legs.last;

    final startTime = firstLeg.plannedTimeDepartment.toString().substring(
      11,
      16,
    );
    final endTime = lastLeg.plannedTimeArrival.toString().substring(11, 16);

    return InkWell(
      onTap: () => print("CLICK!!"),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upper Row: The Visual Route Map
            Row(
              children: [
                for (int i = 0; i < trip.legs.length; i++) ...[
                  if (i > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  _buildTransportPill(),
                ],
                const Spacer(),
                Text(
                  "${trip.durationInMinutes} min",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Lower Row: Times and Main Direction
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      startTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "→",
                        style: TextStyle(color: Colors.orangeAccent),
                      ),
                    ),
                    Text(
                      endTime,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportPill() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.train, color: Colors.white, size: 24),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildTrainCard(List<Leg> legs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.orangeAccent.withValues(alpha: 0.5),
          width: 3,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "BEST TRAIN OPTIONS",
            style: TextStyle(
              color: Colors.orangeAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          for (int i = 0; i < legs.length; i++) ...[
            if (i > 0) const Divider(color: Colors.white10, height: 20),
            _trainRow(legs[i]),
          ],
        ],
      ),
    );
  }

  Widget _trainRow(Leg leg) {
    final startTime = leg.plannedTimeDepartment.toString().substring(11, 16);
    final endTime = leg.plannedTimeArrival.toString().substring(11, 16);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              const Icon(Icons.train, color: Colors.orangeAccent, size: 22),
              const SizedBox(height: 4),
              Text(
                "${leg.stops} stops",
                style: const TextStyle(color: Colors.white38, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$startTime → $endTime",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${leg.name} • Dir: ${leg.direction}",
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _stationTrackRow(leg.origin, leg.originTrack),
                const Icon(
                  Icons.arrow_downward,
                  size: 12,
                  color: Colors.white24,
                ),
                _stationTrackRow(leg.destination, leg.destinationTrack),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stationTrackRow(String station, String track) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            station,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            track,
            style: const TextStyle(
              color: Colors.orangeAccent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
