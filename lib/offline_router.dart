import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/digifit_exercise_detail_screen.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/params/digifit_exercise_details_params.dart';
import 'package:kusel/screens/digifit_screens/digifit_overview/digifit_overview_screen.dart';
import 'package:kusel/screens/digifit_screens/digifit_overview/params/digifit_overview_params.dart';
import 'package:kusel/screens/digifit_screens/digifit_qr_scanner/digifit_qr_scanner_screen.dart';
import 'package:kusel/screens/digifit_screens/digifit_start/digifit_information_screen.dart';
import 'package:kusel/screens/digifit_screens/digifit_trophies/digifit_trophies_screen.dart';
import 'package:kusel/screens/full_image/full_image_screen.dart';
import 'package:kusel/screens/no_network/network_status_screen.dart';
import 'package:kusel/screens/splash/splash_screen.dart';

// FOR NO INTERNET ROUTE

const offlineSplashScreenPath = "/";
const offlineDigifitStartScreenPath = "/offlineDigifitStartScreen";
const noNetworkScreenPath = "/noNetworkScreen";

const offlineDigifitTrophiesScreenPath = "/offlineDigifitTrophiesScreenPath";

// DigiFit screen path
const offlineDigifitOverViewScreenPath = "/offlineDigifitOverViewScreenPath";
const offlineDigifitQRScannerScreenPath = "/offlineDigifitQRScannerScreenPath";
const offlineDigifitExerciseDetailScreenPath =
    "/offlineDigifitExerciseDetailScreenPath";

const offlineFullImageScreenPath = '/fullImageScreenPath';

final noInternetRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: offlineSplashScreenPath,
    routes: routes,
    debugLogDiagnostics: true,
  );
});

List<RouteBase> routes = [
  GoRoute(path: offlineSplashScreenPath, builder: (_, state) => SplashScreen()),
  GoRoute(
      path: noNetworkScreenPath, builder: (_, state) => NetworkStatusScreen()),
  GoRoute(
      path: offlineDigifitStartScreenPath,
      builder: (_, state) => DigifitInformationScreen()),
  GoRoute(
      path: offlineDigifitTrophiesScreenPath,
      builder: (_, __) => DigifitTrophiesScreen()),
  GoRoute(
      path: offlineDigifitOverViewScreenPath,
      builder: (_, state) => DigifitOverviewScreen(
          digifitOverviewScreenParams:
              state.extra as DigifitOverviewScreenParams)),
  GoRoute(
      path: offlineDigifitQRScannerScreenPath,
      builder: (_, __) => DigifitQRScannerScreen()),
  GoRoute(
      path: offlineDigifitExerciseDetailScreenPath,
      builder: (_, state) => DigifitExerciseDetailScreen(
            digifitExerciseDetailsParams:
                state.extra as DigifitExerciseDetailsParams,
          )),
  GoRoute(
      path: offlineFullImageScreenPath,
      builder: (_, state) => FullImageScreen(
          fullImageScreenParams: state.extra as FullImageScreenParams)),
];
