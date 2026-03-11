import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../../app_router.dart';
import '../../common_widgets/custom_button_widget.dart';
import '../../common_widgets/interests_grid_card_view.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';

class OnBoardingPreferencesPage extends ConsumerStatefulWidget {
  const OnBoardingPreferencesPage({super.key});

  @override
  ConsumerState<OnBoardingPreferencesPage> createState() =>
      _OnBoardingPreferencesPageState();
}

class _OnBoardingPreferencesPageState extends ConsumerState<OnBoardingPreferencesPage> {
  @override
  void initState() {
    Future.microtask(() async {
      if (!mounted) return;
      final notifier = ref.read(onboardingScreenProvider.notifier);

      final state = ref.read(onboardingScreenProvider);
      if (state.interests.isEmpty) {
        await notifier.getInterests();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String userName  = ref.read(onboardingScreenProvider).userFirstName ?? '';
    String displayMsg =
        "${AppLocalizations.of(context).almost_there} $userName${AppLocalizations.of(context).what_interest_you}";
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildDashboardUi(displayMsg),
    ).loaderDialog(context, ref.watch(onboardingScreenProvider).isLoading);
  }

  categoryView(BuildContext context) {
    final state = ref.watch(onboardingScreenProvider);
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    return GridView.builder(
        padding: EdgeInsets.only(top: 0),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: DeviceHelper.isMobile(context) ? 135.h : 160.h),
        itemCount: state.interests.length,
        itemBuilder: (BuildContext context, int index) {
          var interest = state.interests[index];
          final isSelected = state.interestsMap[interest.id] ?? false;
          return GestureDetector(
            onTap: () {
              stateNotifier.updateInterestMap(interest.id);
            },
            child: InterestsGridCardView(
              imageUrl: interest.image ?? "",
              title: interest.name ?? '',
              isSelected: isSelected,
            ),
          );
        });
  }

  Widget _buildBottomUi() {
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
      child: Column(
        children: [
          CustomButton(
            onPressed: () async {
              await stateNotifier.submitUserInterests(() {
                ref.read(navigationProvider).removeAllAndNavigate(
                      path: onboardingLoadingPagePath,
                      context: context,
                    );
              });
            },
            text: AppLocalizations.of(context).complete,
          ),
          18.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  ref.read(navigationProvider).removeTopPage(context: context);
                },
                child: textBoldPoppins(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 11,
                  text: AppLocalizations.of(context).back,
                ),
              ),
              8.horizontalSpace,
              GestureDetector(
                onTap: () {
                  ref.read(navigationProvider).removeAllAndNavigate(
                      context: context, path: onboardingLoadingPagePath);
                },
                child: textBoldPoppins(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 11,
                  text: AppLocalizations.of(context).skip,
                ),
              )
            ],
          ),
          18.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Icon(
                  Icons.circle,
                  size: 11,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          12.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildDashboardUi(String displayMsg) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath['onboarding_background'] ?? ''),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
              child: Column(
                children: [
                  65.verticalSpace,
                  textBoldPoppins(
                      text: displayMsg,
                      fontSize: 20,
                      textOverflow: TextOverflow.visible,
                      color: Theme.of(context).textTheme.bodyLarge?.color),
                  20.verticalSpace,
                  categoryView(context),
                  128.verticalSpace
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 1,
            right: 1,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  height: 140.h,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: _buildBottomUi(),
          ),
        ],
      ),
    );
  }

}
