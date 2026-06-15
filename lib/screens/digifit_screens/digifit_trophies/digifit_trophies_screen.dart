import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_user_trophies_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/digifit/digifit_text_image_card.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/get_slug.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/offline_router.dart';
import 'package:kusel/screens/digifit_screens/digifit_exercise_detail/params/digifit_exercise_details_params.dart';
import 'package:kusel/screens/digifit_screens/digifit_trophies/digifit_user_trophies_controller.dart';
import 'package:kusel/screens/no_network/network_status_screen_provider.dart';

import '../../../app_router.dart';
import '../../../common_widgets/digifit/digifit_status_widget.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../common_widgets/toast_message.dart';
import '../../../images_path.dart';
import '../../../matomo_api.dart';
import '../../../navigation/navigation.dart';

class DigifitTrophiesScreen extends ConsumerStatefulWidget {
  const DigifitTrophiesScreen({super.key});

  @override
  ConsumerState<DigifitTrophiesScreen> createState() =>
      _DigifitTrophiesScreenState();
}

class _DigifitTrophiesScreenState extends ConsumerState<DigifitTrophiesScreen> {
  @override
  void initState() {
    Future.microtask(() async {
      bool networkStatus =
          await ref.read(networkStatusProvider.notifier).checkNetworkStatus();
      if (networkStatus) {
        ref
            .read(digifitUserTrophiesControllerProvider.notifier)
            .fetchDigifitUserTrophies();
      }
    });
    MatomoService.trackDigifitTrophiesViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(digifitUserTrophiesControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main scroll content
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Stack(
                  children: [
                    // Background
                    CommonBackgroundClipperWidget(
                      height: 110.h,
                      clipperType: UpstreamWaveClipper(),
                      imageUrl: imagePath['home_screen_background'] ?? '',
                      isStaticImage: true,
                    ),
                    Positioned(
                      top: 30.h,
                      left: 10.r,
                      child: _buildHeadingArrowSection(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 100.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDigifitTrophiesScreenUi(),
                          30.verticalSpace,
                          FeedbackCardWidget(
                            height: 270.h,
                            onTap: () {
                              ref.read(navigationProvider).navigateUsingPath(
                                  path: feedbackScreenPath, context: context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (isLoading)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    ref.read(navigationProvider).removeDialog(context: context);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        height: 100.h,
                        width: 100.w,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _buildHeadingArrowSection() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            ref.read(navigationProvider).removeTopPage(context: context);
          },
          icon: Icon(
              size: DeviceHelper.isMobile(context) ? null : 12.h.w,
              Icons.arrow_back, color: Theme.of(context).primaryColor),
        ),
        10.horizontalSpace,
        textBoldPoppins(
          color: Theme.of(context).textTheme.bodyLarge?.color,
          fontSize: 24,
          text: AppLocalizations.of(context).points_and_trophy,
        ),
      ],
    );
  }

  _buildDigifitTrophiesScreenUi() {
    final state = ref.watch(digifitUserTrophiesControllerProvider);
    final notifier = ref.read(digifitUserTrophiesControllerProvider.notifier);

    final digifitUserTrophiesData = ref
        .read(digifitUserTrophiesControllerProvider)
        .digifitUserTrophyDataModel;

    final latestTrophies = digifitUserTrophiesData?.latestTrophies ?? [];
    final allTrophies = digifitUserTrophiesData?.allTrophies;
    final receivedTrophies = digifitUserTrophiesData?.trophiesReceived;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            DigifitStatusWidget(
              pointsValue: digifitUserTrophiesData?.userStats?.points ?? 0,
              pointsText: AppLocalizations.of(context).points,
              trophiesValue: digifitUserTrophiesData?.userStats?.trophies ?? 0,
              trophiesText: AppLocalizations.of(context).trophies,
                onButtonTap: () async {
                  String path = digifitQRScannerScreenPath;

                  if (!ref.read(networkStatusProvider).isNetworkAvailable) {
                    path = offlineDigifitQRScannerScreenPath;
                  }

                  final barcode = await ref
                      .read(navigationProvider)
                      .navigateUsingPath(path: path, context: context);
                  if (barcode != null) {
                    ref
                        .read(digifitUserTrophiesControllerProvider.notifier)
                        .getSlug(barcode, (String slugUrl) {
                      final value =
                          ref.read(networkStatusProvider).isNetworkAvailable;

                      if (value) {
                        ref.read(navigationProvider).navigateUsingPath(
                            path: digifitExerciseDetailScreenPath,
                            context: context,
                            params: DigifitExerciseDetailsParams(
                                station:
                                    DigifitInformationStationModel(id: null),
                                slug: slugUrl));
                      } else {
                        ref.read(navigationProvider).navigateUsingPath(
                            path: offlineDigifitTrophiesScreenPath,
                            context: context,
                            params: DigifitExerciseDetailsParams(
                                station:
                                    DigifitInformationStationModel(id: null),
                                slug: slugUrl));
                      }
                    }, () {
                      showErrorToast(
                          message:
                              AppLocalizations.of(context).something_went_wrong,
                          context: context);
                    });
                  }
                }),
            20.verticalSpace,
            if (latestTrophies.isNotEmpty)
              _buildCourseDetailSection(
                sectionTitle:
                    AppLocalizations.of(context).digifit_latest_trophies,
                trophies: latestTrophies,
                showToggleButton: false,
              ),
            if (allTrophies?.trophies?.isNotEmpty == true)
              _buildCourseDetailSection(
                sectionTitle: AppLocalizations.of(context).digifit_all_trophies,
                subtitle:
                    "${allTrophies?.locked ?? 0} / ${allTrophies?.total ?? 0} ${AppLocalizations.of(context).digifit_trophies_open}",
                trophies: allTrophies!.trophies!,
                isExpanded: state.isAllTrophiesExpanded,
                onToggle: notifier.toggleAllTrophiesExpanded,
              ),
            if (receivedTrophies?.trophies?.isNotEmpty == true)
              _buildCourseDetailSection(
                sectionTitle:
                    AppLocalizations.of(context).digifit_trophies_received,
                subtitle:
                    "${receivedTrophies?.unlocked ?? 0} / ${allTrophies?.total ?? 0} ${AppLocalizations.of(context).digifit_trophies_open}",
                trophies: receivedTrophies!.trophies!,
                isExpanded: state.isReceivedTrophiesExpanded,
                onToggle: notifier.toggleReceivedTrophiesExpanded,
              ),
          ],
        ));
  }

  _buildCourseDetailSection(
      {required String sectionTitle,
      required List<DigifitUserTrophyItemModel> trophies,
      String? subtitle,
      bool showToggleButton = true,
      bool isExpanded = false,
      VoidCallback? onToggle}) {
    final sourceId = ref
            .read(digifitUserTrophiesControllerProvider)
            .digifitUserTrophyDataModel
            ?.sourceId ??
        0;
    final visibleTrophies = isExpanded ? trophies : trophies.take(5).toList();

    return Column(
      children: [
        20.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: textBoldMontserrat(
                  text: sectionTitle,
                  fontSize: 16,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            12.horizontalSpace,
            if (subtitle != null) textRegularMontserrat(text: subtitle),
          ],
        ),
        10.verticalSpace,
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: visibleTrophies.length,
            itemBuilder: (context, index) {
              var trophy = visibleTrophies[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: DigifitTextImageCard(
                    imageUrl: trophy.iconUrl ?? '',
                    heading: trophy.muscleGroups ?? '',
                    title: trophy.name ?? '',
                    isFavouriteVisible: false,
                    isFavorite: false,
                    sourceId: sourceId,
                    isCompleted: trophy.isCompleted ?? false),
              );
            }),
        10.verticalSpace,
        if (showToggleButton && onToggle != null)
          CustomButton(
              onPressed: onToggle,
              text: isExpanded
                  ? AppLocalizations.of(context).digifit_trophies_show_less
                  : AppLocalizations.of(context).digifit_trophies_load_more),
      ],
    );
  }
}
