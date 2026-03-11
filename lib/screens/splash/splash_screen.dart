import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/offline_router.dart';
import 'package:kusel/screens/splash/splash_screen_provider.dart';

import '../no_network/network_status_screen_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _State();
}

class _State extends ConsumerState<SplashScreen> {
  @override
  @override
  void initState() {


    Future.microtask(() {
      final hasNetwork = ref.read(networkStatusProvider).isNetworkAvailable;
      ref.read(splashScreenProvider.notifier).startTimer(() {

        if (hasNetwork) {
          bool isOnboardingDone =
              ref.read(splashScreenProvider.notifier).isOnboardingDone();
          String path;
          if (isOnboardingDone) {
            path = homeScreenPath;
          } else {
            path = onboardingStartPagePath;
          }
          ref.read(navigationProvider).removeAllAndNavigate(
                context: context,
                path: path,
              );
        } else {
          ref.read(navigationProvider).removeAllAndNavigate(
              context: context, path: noNetworkScreenPath);
        }
      });
    });
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Center(
          child: Text(
        AppLocalizations.of(context).app_title,
        style: TextStyle(
            fontSize: 40,
            color: Theme.of(context).textTheme.labelSmall?.color,
            fontWeight: FontWeight.bold),
      )),
    ));
  }
}
