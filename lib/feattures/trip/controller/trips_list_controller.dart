import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/Trip.dart';
import '../data/trips_repository.dart';

final tripsListControllerProvider = Provider<TripsListController>((ref) {
  return TripsListController(ref);
});

class TripsListController {
  TripsListController(this.ref);
  final Ref ref;

  Future<void> add({
    required String name,
    required String destination,
    required String startDate,
    required String endDate,
  }) async {
    Trip trip = Trip(
      tripName: name,
      destination: destination,
      startDate: TemporalDate(DateTime.parse(startDate)),
      endDate: TemporalDate(DateTime.parse(endDate)),
    );

    final tripsRepository = ref.read(tripsRepositoryProvider);

    await tripsRepository.add(trip);
  }
}