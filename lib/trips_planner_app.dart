import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'common/navigation/router/routes.dart';
import 'common/utils/colors.dart';
import 'feattures/trip/ui/edit_trip_page/edit_trip_page.dart';
import 'feattures/trip/ui/tip_page/trip_page.dart';
import 'feattures/trip/ui/trips_list/trips_list_page.dart';
import 'models/Trip.dart';

class TripsPlannerApp extends StatelessWidget {
  const TripsPlannerApp({
    required this.isAmplifySuccessfullyConfigured,
    Key? key,
  }) : super(key: key);

  final bool isAmplifySuccessfullyConfigured;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: AppRoute.home.name,
          builder: (context, state) => isAmplifySuccessfullyConfigured
              ? const TripsListPage()
              : const Scaffold(
                  body: Center(
                    child: Text(
                      'Tried to reconfigure Amplify; '
                      'this can occur when your app restarts on Android.',
                    ),
                  ),
                ),
        ),
        GoRoute(
          path: '/trip/:id',
          name: AppRoute.trip.name,
          builder: (context, state) {
            final tripId = state.params['id']!;
            return TripPage(tripId: tripId);
          },
        ),
        GoRoute(
          path: '/edittrip/:id',
          name: AppRoute.edittrip.name,
          builder: (context, state) {
            return EditTripPage(
              trip: state.extra! as Trip,
            );
          },
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text(state.error.toString()),
        ),
      ),
    );

    return Authenticator(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate,
        builder: Authenticator.builder(),
        theme: ThemeData(
          primarySwatch: primaryColor,
          backgroundColor: const Color(0xff82CFEA),
        ),
      ),
    );
  }
}