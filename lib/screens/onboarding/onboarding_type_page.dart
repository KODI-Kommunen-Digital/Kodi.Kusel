import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_selection_button.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../../app_router.dart';
import '../../common_widgets/custom_button_widget.dart';
import '../../common_widgets/text_styles.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';

class OnboardingTypePage extends ConsumerStatefulWidget {
  const OnboardingTypePage({super.key});

  @override
  ConsumerState<OnboardingTypePage> createState() =>
      _OnboardingStartPageState();
}

class _OnboardingStartPageState extends ConsumerState<OnboardingTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildDashboardUi(),
    ).loaderDialog(context, ref
        .watch(onboardingScreenProvider)
        .isLoading);
  }

  Widget _buildTypeScreenUi() {
    final state = ref.watch(onboardingScreenProvider);
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    return Column(
      children: [
        65.verticalSpace,
        textBoldPoppins(
            text: AppLocalizations
                .of(context)
                .ich_text,
            fontSize: 20,
            color: Theme
                .of(context)
                .textTheme
                .bodyLarge
                ?.color),
        20.verticalSpace,
        CustomSelectionButton(
            text: AppLocalizations
                .of(context)
                .i_live_in_district_onborading_type_page,
            isSelected: state.isResident,
            onTap: () {
              if (state.isResident) {
                stateNotifier.updateOnboardingType(null);
              } else {
                stateNotifier.updateOnboardingType(OnBoardingType.resident);
              }
            }),
        15.verticalSpace,
        CustomSelectionButton(
            text: AppLocalizations
                .of(context)
                .spend_my_free_time_here,
            isSelected: state.isTourist,
            onTap: () {
              if (state.isTourist) {
                stateNotifier.updateOnboardingType(null);
              } else {
                stateNotifier.updateOnboardingType(OnBoardingType.tourist);
              }
            }),
        12.verticalSpace,
        Visibility(
            visible: state.isErrorMsgVisible,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: textRegularPoppins(
                    text: AppLocalizations
                        .of(context)
                        .please_select_the_field,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .error,
                    fontSize: 11),
              ),
            ))
      ],
    );
  }

  Widget _buildBottomUi() {
    final state = ref.read(onboardingScreenProvider);
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);

    return Column(
      children: [
        CustomButton(
          onPressed:
          (!ref
              .watch(onboardingScreenProvider)
              .isInterestPageButtonVisible)
              ? null
              : () async {
            if (!state.isTourist && !state.isResident) {
              stateNotifier.updateErrorMsgStatus(true);
            } else {
              stateNotifier.updateErrorMsgStatus(false);
              stateNotifier.submitUserType();
              ref.read(navigationProvider).navigateUsingPath(
                  path: onboardingOptionPagePath, context: context);
            }
          },
          text: AppLocalizations
              .of(context)
              .next,
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
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge
                    ?.color,
                fontSize: 11,
                text: AppLocalizations
                    .of(context)
                    .back,
              ),
            ),
            8.horizontalSpace,
            GestureDetector(
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: onboardingOptionPagePath, context: context);
              },
              child: textBoldPoppins(
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge
                    ?.color,
                fontSize: 11,
                text: AppLocalizations
                    .of(context)
                    .skip,
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
                color: Theme
                    .of(context)
                    .primaryColor
                    .withAlpha(130),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Icon(
                Icons.circle,
                size: 8,
                color: Theme
                    .of(context)
                    .primaryColor
                    .withAlpha(130),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Icon(
                Icons.circle,
                size: 11,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Icon(
                Icons.circle,
                size: 8,
                color: Theme
                    .of(context)
                    .primaryColor
                    .withAlpha(130),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Icon(
                Icons.circle,
                size: 8,
                color: Theme
                    .of(context)
                    .primaryColor
                    .withAlpha(130),
              ),
            )
          ],
        ),
        12.verticalSpace,
      ],
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
      child: Stack(
        children: [ ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              height: 140.h,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
            child: Stack(
              children: [
                _buildTypeScreenUi(),
                Positioned(
                    bottom: 10, left: 0, right: 0, child: _buildBottomUi())
              ],
            ),
          )
        ],
      ),
    );
  }
}
