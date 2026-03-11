import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/kusel_setting_screen/kusel_setting_screen_controller.dart';
import 'package:kusel/screens/kusel_setting_screen/legal_policy_screen.dart';
import 'package:kusel/screens/kusel_setting_screen/poilcy_type.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';

class KuselSettingScreen extends ConsumerStatefulWidget {
  const KuselSettingScreen({super.key});

  @override
  ConsumerState<KuselSettingScreen> createState() => _KuselSettingScreenState();
}

class _KuselSettingScreenState extends ConsumerState<KuselSettingScreen> {
  @override
  void initState() {
    final controller = ref.read(kuselSettingScreenProvider.notifier);
    Future.microtask(() {
      controller.fetchCurrentLanguage();
      controller.isUserLoggedIn();
      controller.getUserScore();
      controller.getAppVersion();
    });
    MatomoService.trackProfileScreenViewed();

    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(kuselSettingScreenProvider.notifier).getUserScore();
      },
      child: Scaffold(
        body: _buildBody(context),
      ).loaderDialog(context, ref.watch(kuselSettingScreenProvider).isLoading),
    );
  }

  _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          26.verticalSpace,
          _buildHeadingText(AppLocalizations.of(context).my_profile),
          22.verticalSpace,
          _buildSettingCard(context)
        ],
      ),
    );
  }

  _buildHeader(BuildContext context) {
    return SizedBox(
      height: 200.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
              top: 0.h,
              left: 0.w,
              right: 0.w,
              child: CommonBackgroundClipperWidget(
                clipperType: UpstreamWaveClipper(),
                imageUrl: imagePath['home_screen_background'] ?? '',
                isStaticImage: true,
                height: 120.h,
              )),
          Positioned(
              right: 0.w,
              left: 0.w,
              top: 26.h,
              child: SizedBox(
                height: 190.h,
                width: 180.w,
                child: ImageUtil.loadAssetImage(
                    imageUrl: imagePath["setting_boldi"] ?? '',
                    context: context,
                    fit: BoxFit.contain),
              ))
        ],
      ),
    );
  }

  _buildHeadingText(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w),
      child: textBoldPoppins(
          text: label,
          color: Theme.of(context).textTheme.bodyLarge!.color,
          fontSize: 24),
    );
  }

  _buildSettingCard(BuildContext context) {
    final state = ref.watch(kuselSettingScreenProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTextSettingCard(
                  context,
                  AppLocalizations.of(context).digifit_parcours,
                  state.totalPoints.toString(),
                  AppLocalizations.of(context).points,
                  () {}),
              _buildTextSettingCard(
                  context,
                  AppLocalizations.of(context).treasure_pass,
                  state.totalStamp.toString(),
                  AppLocalizations.of(context).rubber_stamp,
                  () {}),
            ],
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildImageSettingCard(
                  context,
                  AppLocalizations.of(context).profile_setting,
                  'setting_profile', () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: '$kuselSettingScreenPath/$profileSettingScreenPath',
                    context: context);
              }),
              _buildImageSettingCard(
                  context, AppLocalizations.of(context).my_fav, 'my_fav', () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: '$kuselSettingScreenPath/$kuselFavScreenPath',
                    context: context);
              }),
            ],
          ),
          32.verticalSpace,
          _buildFunctionCard(context),
          100.verticalSpace
        ],
      ),
    );
  }

  _buildTextSettingCard(BuildContext context, String tileTitle,
      String numericValue, String numericValueHeading, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160.h,
        width: 160.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r), color: Colors.white),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              height: 110.h,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                color: Theme.of(context).cardTheme.color),
              child: Column(
                children: [
                  textSemiBoldPoppins(
                      text: numericValue,
                      color: Theme.of(context).primaryColor,
                      fontSize: 58),
                  textRegularPoppins(
                      text: numericValueHeading,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14)
                ],
              ),
            ),
            16.verticalSpace,
            Padding(
              padding: const EdgeInsets.only(right: 34.0),
              child: textRegularMontserrat(
                  text: tileTitle,
                  color: Theme.of(context).textTheme.displayMedium!.color,
                  fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  _buildImageSettingCard(BuildContext context, String tileTitle,
      String imagePath, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160.h,
        width: 160.w,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r), color: Colors.white),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 32.w),
                height: 100.h,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Theme.of(context).cardTheme.color,),
                child: ImageUtil.loadLocalSvgImage(
                    imageUrl: imagePath,
                    context: context,
                    fit: BoxFit.contain)),
            16.verticalSpace,
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: textRegularMontserrat(
                  text: tileTitle,
                  color: Theme.of(context).textTheme.displayMedium!.color,
                  fontSize: 12,
                  textOverflow: TextOverflow.visible),
            )
          ],
        ),
      ),
    );
  }

  _buildFunctionCard(BuildContext context) {
    double borderRadius = 10.r;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: Theme.of(context).canvasColor),
      child: _buildFunctionCardTile(context, borderRadius),
    );
  }

  _buildFunctionCardTile(BuildContext context, double borderRadius) {
    return Consumer(builder: (context, ref, _) {
      final state = ref.watch(kuselSettingScreenProvider);
      final controller = ref.read(kuselSettingScreenProvider.notifier);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //protection data

          _buildCommonArrowTile(
              context: context,
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: legalPolicyScreenPath,
                    context: context,
                    params: LegalPolicyScreenParams(
                        title: AppLocalizations.of(context)
                            .data_protection_information,
                        policyType: PolicyType.privacyPolicy));
              },
              title: AppLocalizations.of(context).data_protection_information,
              hasTopRadius: true,
              hasBottomRadius: false,
              borderRadius: borderRadius),

          _buildCommonArrowTile(
              context: context,
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: legalPolicyScreenPath,
                    context: context,
                    params: LegalPolicyScreenParams(
                        title: AppLocalizations.of(context).terms_of_use,
                        policyType: PolicyType.termsAndConditions));
              },
              title: AppLocalizations.of(context).terms_of_use,
              hasTopRadius: false,
              hasBottomRadius: false,
              borderRadius: borderRadius),

          _buildCommonArrowTile(
              context: context,
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: legalPolicyScreenPath,
                    context: context,
                    params: LegalPolicyScreenParams(
                        title: AppLocalizations.of(context).imprint_page,
                        policyType: PolicyType.imprintPage));
              },
              title: AppLocalizations.of(context).imprint_page,
              hasTopRadius: false,
              hasBottomRadius: false,
              borderRadius: borderRadius),

          _buildCommonArrowTile(
              context: context,
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: '$kuselSettingScreenPath/$subShellFeedbackScreenPath',
                    context: context);
              },
              title: AppLocalizations.of(context).feedback_setting,
              hasTopRadius: false,
              hasBottomRadius: false,
              borderRadius: borderRadius),

          _buildCommonArrowTile(
              context: context,
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: onboardingStartPagePath, context: context);
              },
              title: AppLocalizations.of(context).edit_onboarding_details,
              hasTopRadius: false,
              hasBottomRadius: false,
              borderRadius: borderRadius),

          Visibility(
            visible: state.isUserLoggedIn,
            child: _buildCommonArrowTile(
                context: context,
                onTap: () async{

                  final controller = ref.read(kuselSettingScreenProvider.notifier);
                  final router = GoRouter.of(context);

                  await controller.logoutUser(() async {
                   // await controller.isUserLoggedIn();
                  }, onSuccess: () async {
                   // await controller.getUserScore();
                  });

                  router.go(splashScreenPath);
                  router.refresh();
                  Future.microtask(() {
                    router.go(signInScreenPath);
                  });

                },
                title: AppLocalizations.of(context).logout,
                hasTopRadius: false,
                hasBottomRadius: false,
                borderRadius: borderRadius),
          ),

          Visibility(
            visible: !state.isUserLoggedIn,
            child: _buildCommonArrowTile(
                context: context,
                onTap: () {
                  ref.read(navigationProvider).removeAllAndNavigate(
                      path: signInScreenPath, context: context);
                },
                title: AppLocalizations.of(context).log_in_sign_up,
                hasTopRadius: false,
                hasBottomRadius: false,
                borderRadius: borderRadius),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(borderRadius),
                  bottomRight: Radius.circular(borderRadius)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textBoldMontserrat(
                    text: AppLocalizations.of(context).app_version,
                    color: Theme.of(context).textTheme.displayMedium!.color,
                    fontSize: 14),
                5.verticalSpace,
                textBoldMontserrat(
                    text: state.appVersion,
                    color: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .color!
                        .withOpacity(0.5),
                    fontSize: 14),
              ],
            ),
          )
        ],
      );
    });
  }

  _buildCommonArrowTile(
      {required BuildContext context,
      required Function() onTap,
      required String title,
      required bool hasTopRadius,
      required bool hasBottomRadius,
      required double borderRadius}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft:
                    hasTopRadius ? Radius.circular(borderRadius) : Radius.zero,
                topRight:
                    hasTopRadius ? Radius.circular(borderRadius) : Radius.zero,
                bottomLeft: hasBottomRadius
                    ? Radius.circular(borderRadius)
                    : Radius.zero,
                bottomRight: hasBottomRadius
                    ? Radius.circular(borderRadius)
                    : Radius.zero),
            border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textSemiBoldMontserrat(
                text: title,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 16),
            SizedBox(
              height: 20.h,
              width: 20.w,
              child: ImageUtil.loadLocalSvgImage(
                  imageUrl: 'forward_arrow', context: context),
            )
          ],
        ),
      ),
    );
  }

}
