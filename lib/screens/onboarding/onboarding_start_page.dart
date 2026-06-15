import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/matomo_api.dart';

import '../../app_router.dart';
import '../../common_widgets/custom_button_widget.dart';
import '../../navigation/navigation.dart';
import '../dashboard/dashboard_screen_provider.dart';
import 'onboarding_screen_provider.dart';

class OnboardingStartPage extends ConsumerStatefulWidget {
  const OnboardingStartPage({super.key});

  @override
  ConsumerState<OnboardingStartPage> createState() =>
      _OnboardingStartPageState();
}

class _OnboardingStartPageState extends ConsumerState<OnboardingStartPage> {

  @override
  void initState() {
    Future.microtask(() async {
      if (!mounted) return;
      final notifier = ref.read(onboardingScreenProvider.notifier);
      await notifier.initialCall();

      if (notifier.isOnboardingDone()) {
        notifier.getOnboardingDetails();
      }
    });
    MatomoService.trackOnboardingScreenViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildDashboardUi(),
          Positioned(
            bottom: 10,
              left: 0,
              right: 0,
              child: _buildBottomUi()),
        ],
      ).loaderDialog(context, ref.watch(onboardingScreenProvider).isLoading),
    );
  }

  Widget _buildDashboardUi() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath['onboarding_background'] ?? ''),
          fit: BoxFit.cover,
        ),
      ),
      child: _customPageViewer(),
    );
  }

  Widget _customPageViewer() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
      child: Column(
        children: [
          50.verticalSpace,
          Image.asset(
            imagePath["onboarding_logo"] ?? '',
            width: 270.w,
            height: 210.h,
          ),
          textBoldPoppins(
              text: AppLocalizations.of(context).welcome_text,
              fontSize: 18,
              color: Theme.of(context).textTheme.bodyLarge?.color),
          20.verticalSpace,
          textRegularPoppins(
              text: AppLocalizations.of(context).welcome_para_first,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              textOverflow: TextOverflow.visible,
              fontSize: 12),
          16.verticalSpace,
          textRegularPoppins(
              text: AppLocalizations.of(context).welcome_para_second,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              textOverflow: TextOverflow.visible,
              fontSize: 12),
        ],
      ),
    );
  }

  Widget _buildBottomUi() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
      child: Column(
        children: [
          CustomButton(
              onPressed: () async{
                ref.read(navigationProvider).navigateUsingPath(
                    path: onboardingNamePagePath, context: context);
              },
              text: AppLocalizations.of(context).lets_get_started
            ),
          18.verticalSpace,
          GestureDetector(
            onTap: () {
              ref.read(navigationProvider).removeAllAndNavigate(
                  path: homeScreenPath, context: context);
            },
            child: textSemiBoldMontserrat(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              text: AppLocalizations.of(context).another_time,
            ),
          ),
          18.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Icon(
                  Icons.circle,
                  size: 11,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Icon(
                  Icons.circle,
                  size: 8,
                  color: Theme.of(context).primaryColor.withAlpha(130),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Icon(
                  Icons.circle,
                  size: 8,
                  color: Theme.of(context).primaryColor.withAlpha(130),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Icon(
                  Icons.circle,
                  size: 8,
                  color: Theme.of(context).primaryColor.withAlpha(130),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Icon(
                  Icons.circle,
                  size: 8,
                  color: Theme.of(context).primaryColor.withAlpha(130),
                ),
              )
            ],
          ),
          12.verticalSpace,
        ],
      ),
    );
  }
}
