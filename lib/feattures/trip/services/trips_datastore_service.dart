import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/Trip.dart';

// listenToTrips - This function will query the Amplify DataStore for the active and upcoming trips and stream a list of them.
// listenToPastTrips - This function will query the Amplify DataStore for past trips and stream a list of them.
// getTripStream - This function will query the Amplify DataStore for a specific trip and stream a list of that.
// addTrip, deleteTrip, and updateTrip is for adding, deleting, or updating the trips in the Amplify DataStore.

final tripsDataStoreServiceProvider = Provider<TripsDataStoreService>((ref) {
  final service = TripsDataStoreService();
  return service;
});

class TripsDataStoreService {
  TripsDataStoreService();

  Stream<List<Trip>> listenToTrips() {
    return Amplify.DataStore.observeQuery(
      Trip.classType,
      sortBy: [Trip.STARTDATE.ascending()],
    )
        .map((event) => event.items
            .where((element) =>
                element.endDate!.getDateTime().isAfter(DateTime.now()))
            .toList())
        .handleError(
      (error) {
        debugPrint('listenToTrips: A Stream error happened');
      },
    );
  }

  Stream<List<Trip>> listenToPastTrips() {
    return Amplify.DataStore.observeQuery(
      Trip.classType,
      sortBy: [Trip.STARTDATE.ascending()],
    )
        .map((event) => event.items
            .where((element) =>
                element.endDate!.getDateTime().isBefore(DateTime.now()))
            .toList())
        .handleError(
      (error) {
        debugPrint('listenToTrips: A Stream error happened');
      },
    );
  }

  Stream<Trip> getTripStream(String id) {
    final tripStream =
        Amplify.DataStore.observeQuery(Trip.classType, where: Trip.ID.eq(id))
            .map((event) => event.items.toList().single);

    return tripStream;
  }

  Future<void> addTrip(Trip trip) async {
    try {
      await Amplify.DataStore.save(trip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> deleteTrip(Trip trip) async {
    try {
      await Amplify.DataStore.delete(trip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> updateTrip(Trip updatedTrip) async {
    try {
      final tripsWithId = await Amplify.DataStore.query(
        Trip.classType,
        where: Trip.ID.eq(updatedTrip.id),
      );

      final oldTrip = tripsWithId.first;
      final newTrip = oldTrip.copyWith(
        // id: oldTrip.id,
        tripName: updatedTrip.tripName,
        destination: updatedTrip.destination,
        startDate: updatedTrip.startDate,
        endDate: updatedTrip.endDate,
        tripImageKey: updatedTrip.tripImageKey,
        tripImageUrl: updatedTrip.tripImageUrl,
      );

      await Amplify.DataStore.save(newTrip);
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
  }
}
