import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:temp/feattures/trip/ui/trips_list/trip_card.dart';
import '../../../../common/utils/colors.dart';
import '../../data/trips_repository.dart';
import 'add_trip_bottomsheet.dart';

class TripsListPage extends HookConsumerWidget {
  const TripsListPage({
    super.key,
  });

  void showAddTripDialog(BuildContext context) async {
    await showModalBottomSheet<void>(
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (BuildContext context) {
        return AddTripBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final tripsListValue = ref.watch(tripsListStreamProvider);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Amplify Trips Planner',
          ),
          backgroundColor: const Color(primaryColorDark),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showAddTripDialog(context);
          },
          backgroundColor: const Color(primaryColorDark),
          child: const Icon(Icons.add),
        ),
        body: tripsListValue.when(
            data: (trips) => trips.isEmpty
                ? const Center(
                    child: Text('No Trips'),
                  )
                : Column(
                    children: [
                      Flexible(
                        child: GridView.count(
                          crossAxisCount:
                              (orientation == Orientation.portrait) ? 2 : 3,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          padding: const EdgeInsets.all(4),
                          childAspectRatio:
                              (orientation == Orientation.portrait) ? 0.9 : 1.4,
                          children: trips.map((tripData) {
                            return TripCard(trip: tripData!);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
            error: (e, st) => const Center(
                  child: Text('Error'),
                ),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                )));
  }
}
