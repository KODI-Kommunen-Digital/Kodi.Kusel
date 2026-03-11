import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:domain/model/request_model/digifit/digifit_update_exercise_request_model.dart';
import 'package:domain/model/response_model/digifit/digifit_cache_data_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kusel/firebase_api.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/no_network/network_status_screen_provider.dart';
import 'package:kusel/theme_manager/theme_manager_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_router.dart';
import 'firebase_option/firebase_options.dart';
import 'locale/localization_manager.dart';
import 'offline_router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Hive.registerAdapter(DigifitCacheDataResponseModelAdapter());
  Hive.registerAdapter(DigifitInformationResponseModelAdapter());
  Hive.registerAdapter(DigifitInformationDataModelAdapter());
  Hive.registerAdapter(DigifitInformationUserStatsModelAdapter());
  Hive.registerAdapter(DigifitInformationParcoursModelAdapter());
  Hive.registerAdapter(DigifitInformationStationModelAdapter());
  Hive.registerAdapter(DigifitInformationActionsModelAdapter());
  Hive.registerAdapter(DigifitUpdateExerciseRequestModelAdapter());
  Hive.registerAdapter(DigifitExerciseRecordModelAdapter());

  /// Matomo Tracking Initialization
  MatomoService.initialize(
      siteId: '1', url: 'https://dev.boundless-innovation.com/analytics/matomo.php');

  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(prefs),
  ], child: MyApp()));
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context,
      Widget child,
      ScrollableDetails details,
      ) {
    return child;
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  StreamSubscription<List<ConnectivityResult>>? subscription;

  late final FirebaseApi firebaseApi; // Use late instead of initializing directly


  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);


    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,     // bottom bar color
        systemNavigationBarIconBrightness: Brightness.dark, // icon color
      ),
    );

    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) {
        return MaterialApp.router(
          key: ValueKey(ref.watch(networkStatusProvider).isNetworkAvailable),
          locale: ref.watch(localeManagerProvider).currentLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: (ref.watch(networkStatusProvider).isNetworkAvailable)
              ? ref.read(mobileRouterProvider)
              : ref.read(noInternetRouterProvider),
          theme: ref.watch(themeManagerProvider).currentSelectedTheme,
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: child!,
              );
            });
      },
    );
  }

  @override
  void initState() {
    Future.microtask(() async {
      {
        final firebaseApi = ref.read(firebaseApiProvider);
        await firebaseApi.initNotifications();
        ref.read(localeManagerProvider.notifier).initialLocaleSetUp();
        ref.read(networkStatusProvider.notifier).checkNetworkStatus();
      }
    });

    super.initState();

    final connectivity = Connectivity();
    subscription = connectivity.onConnectivityChanged.listen((results) {
      final isConnected = results.isNotEmpty && results.any((r) => r != ConnectivityResult.none);

      final notifier = ref.read(networkStatusProvider.notifier);
      final current = ref.read(networkStatusProvider).isNetworkAvailable;

      if (current != isConnected) {
        notifier.updateNetworkStatus(isConnected);

        final router = isConnected
            ? ref.read(mobileRouterProvider)
            : ref.read(noInternetRouterProvider);

        router.go('/');
      }
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
