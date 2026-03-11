import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../../common_widgets/custom_circular_progress_indicator.dart';
import '../../common_widgets/text_styles.dart';
import '../../images_path.dart';

class OnboardingLoadingPage extends ConsumerStatefulWidget {
  const OnboardingLoadingPage({super.key});

  @override
  ConsumerState<OnboardingLoadingPage> createState() =>
      _OnboardingLoadingPageState();
}

class _OnboardingLoadingPageState extends ConsumerState<OnboardingLoadingPage> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      ref.read(onboardingScreenProvider.notifier).startLoadingTimer(() {
        ref.read(navigationProvider).removeAllAndNavigate(
          context: context,
          path: onboardingFinishPagePath,
        );
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    String userName = ref.read(onboardingScreenProvider).userFirstName ?? '';
    String textMsg = "${AppLocalizations.of(context).thanks} $userName!";
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath['onboarding_background'] ?? ''),
            // your image path
            fit: BoxFit.cover, // cover the entire screen
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
          child: Column(
            children: [
              150.verticalSpace,
              Center(
                child: CustomCircularProgressIndicator(),
              ),
              30.verticalSpace,
              textBoldPoppins(
                  text: textMsg,
                  fontSize: 20,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              10.verticalSpace,
              textRegularPoppins(
                  text: AppLocalizations.of(context).preparing_the_app_text,
                  textOverflow: TextOverflow.visible,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 12)
            ],
          ),
        ),
      ),
    );
  }
}
