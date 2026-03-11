import 'package:domain/model/response_model/digifit/brain_teaser_game/details_response_model.dart';
import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/digifit/brain_teaser_game/game_text_card.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/game_details/params/details_params.dart';

import '../../../../app_router.dart';
import '../../../../common_widgets/common_bottom_nav_card_.dart';
import '../../../../common_widgets/common_html_widget.dart';
import '../../../../common_widgets/device_helper.dart';
import '../../../../common_widgets/feedback_card_widget.dart';
import '../../../../common_widgets/text_styles.dart';
import '../../../../common_widgets/toast_message.dart';
import '../../../../images_path.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../navigation/navigation.dart';
import '../../../no_network/network_status_screen_provider.dart';
import '../../digifit_exercise_detail/params/digifit_exercise_details_params.dart';
import '../../digifit_start/digifit_information_controller.dart';
import '../common_navigation/game_navigation_provider.dart';
import 'details_controller.dart';

class BrainTeaserGameDetailsScreen extends ConsumerStatefulWidget {
  final BrainTeaserGameDetailsParams? brainTeaserGameDetailsParams;

  const BrainTeaserGameDetailsScreen(
      {super.key, required this.brainTeaserGameDetailsParams});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BrainTeaserGameDetailsScreenState();
  }
}

class _BrainTeaserGameDetailsScreenState
    extends ConsumerState<BrainTeaserGameDetailsScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(brainTeaserGameDetailsControllerProvider(
                  widget.brainTeaserGameDetailsParams!.gameId ?? 1)
              .notifier)
          .fetchBrainTeaserGameDetails(
              gameId: widget.brainTeaserGameDetailsParams!.gameId ?? 1);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(brainTeaserGameDetailsControllerProvider(
        widget.brainTeaserGameDetailsParams!.gameId ?? 1));
    final sourceId = state.gameDetailsDataModel?.sourceId ?? 1;
    final headingText = state.gameDetailsDataModel?.game?.name;
    final gameDetailsDataModel = state.gameDetailsDataModel;
    final isLoading = state.isLoading;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(brainTeaserGameDetailsControllerProvider(
                              widget.brainTeaserGameDetailsParams!.gameId ?? 1)
                          .notifier)
                      .fetchBrainTeaserGameDetails(
                          gameId:
                              widget.brainTeaserGameDetailsParams!.gameId ?? 1);
                },
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Stack(
                    children: [
                      CommonBackgroundClipperWidget(
                        height: 145.h,
                        clipperType: UpstreamWaveClipper(),
                        imageUrl: imagePath['home_screen_background'] ?? '',
                        isStaticImage: true,
                      ),
                      Positioned(
                        top: 50.h,
                        left: 10.r,
                        child:
                            _buildHeadingArrowSection(headingText: headingText),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBodyContent(
                              gameDetailsDataModel, headingText, sourceId),
                          20.verticalSpace,
                          if (!isLoading)
                            FeedbackCardWidget(
                              height: 270.h,
                              onTap: () {
                                ref.read(navigationProvider).navigateUsingPath(
                                    path: feedbackScreenPath, context: context);
                              },
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20.h,
              left: 16.w,
              right: 16.w,
              child: CommonBottomNavCard(
                onBackPress: () {
                  ref.read(navigationProvider).removeTopPage(context: context);
                },
                isFavVisible: false,
                isFav: false,
                isScannerVisible: true,
                onScannerTap: () async {
                  String path = digifitQRScannerScreenPath;

                  final barcode = await ref
                      .read(navigationProvider)
                      .navigateUsingPath(path: path, context: context);
                  if (barcode != null) {
                    ref
                        .read(digifitInformationControllerProvider.notifier)
                        .getSlug(barcode, (String slugUrl) {
                      final isNetwork =
                          ref.read(networkStatusProvider).isNetworkAvailable;

                      if (isNetwork) {
                        ref.read(navigationProvider).navigateUsingPath(
                            path: digifitExerciseDetailScreenPath,
                            context: context,
                            params: DigifitExerciseDetailsParams(
                                station:
                                    DigifitInformationStationModel(id: null),
                                slug: slugUrl,
                                onFavCallBack: () {
                                  ref
                                      .read(digifitInformationControllerProvider
                                          .notifier)
                                      .fetchDigifitInformation();
                                }));
                      }
                    }, () {
                      showErrorToast(
                          message:
                              AppLocalizations.of(context).something_went_wrong,
                          context: context);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ).loaderDialog(context, isLoading);
  }

  _buildHeadingArrowSection({String? headingText}) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            ref.read(navigationProvider).removeTopPage(context: context);
          },
          icon: Icon(
              size: DeviceHelper.isMobile(context) ? null : 12.h.w,
              Icons.arrow_back,
              color: Theme.of(context).primaryColor),
        ),
        2.horizontalSpace,
        textSemiBoldPoppins(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          text: headingText ?? '',
        ),
      ],
    );
  }

  Widget _buildBodyContent(GameDetailsDataModel? gameDetailsDataModel,
      String? headingText, int sourceId) {
    final gameDetailsChooseLevel = gameDetailsDataModel?.levels ?? [];
    final gameDetailsMoreGame = gameDetailsDataModel?.moreGames ?? [];
    final description = gameDetailsDataModel?.game?.description ?? '';
    final gameDetailsStamps = gameDetailsDataModel?.stamps ?? [];

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 100.h),
            child: _boldiWithMessage(gameDetailsStamps, sourceId),
          ),
          2.verticalSpace,
          Padding(
              padding: const EdgeInsets.only(left: 8),
              child: CommonHtmlWidget(fontSize: 16, data: description)),
          2.verticalSpace,
          _chooseLevel(gameDetailsChooseLevel, headingText,
              gameDetailsDataModel, sourceId, description),
          8.verticalSpace,
          _moreGames(gameDetailsMoreGame, sourceId),
        ],
      ),
    );
  }

  _boldiWithMessage(
      List<GameDetailsStampModel> gameDetailsStamps, int sourceId) {
    return SizedBox(
      height: 340.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 6.h,
            left: 6.w,
            child: SizedBox(
              height: 178.h,
              width: 144.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ImageUtil.loadAssetImage(
                    imageUrl: imagePath['cloud_message_image'] ?? '',
                    height: 178.h,
                    width: 144.w,
                    fit: BoxFit.contain,
                    context: context,
                  ),
                  Positioned(
                    top: 60.h,
                    left: 8.w,
                    right: 12.w,
                    child: SizedBox(
                      width: 120.w,
                      child: textSemiBoldMontserrat(
                          text: AppLocalizations.of(context).games_stamps_desc,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          textOverflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 10.w,
            child: ImageUtil.loadAssetImage(
              imageUrl: imagePath['boldi_game_details_image'] ?? '',
              height: 241.h,
              width: 192.w,
              fit: BoxFit.contain,
              context: context,
            ),
          ),
          Positioned(
            top: 185.h,
            left: 0,
            right: 0,
            child: _stampLayer(gameDetailsStamps, sourceId),
          ),
        ],
      ),
    );
  }

  _stampLayer(List<GameDetailsStampModel> gameDetailsStamps, int sourceId) {
    return SizedBox(
      width: 350.w,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, bottom: 8, left: 12, right: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: textRegularMontserrat(
                  text: AppLocalizations.of(context).stamps_achievements,
                  color: Theme.of(context).textTheme.labelMedium?.color,
                ),
              ),
              SizedBox(height: 12.h),
              _buildIconsGrid(gameDetailsStamps, sourceId),
            ],
          ),
        ),
      ),
    );
  }

  _buildIconsGrid(List<GameDetailsStampModel> gameDetailsStamps, int sourceId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        gameDetailsStamps.length,
        (index) => _buildStampIcon(gameDetailsStamps[index], sourceId),
      ),
    );
  }

  _buildStampIcon(GameDetailsStampModel gameDetailsStamp, int sourceId) {
    return SizedBox(
      width: 88.w,
      height: 88.w,
      child: gameDetailsStamp.isCompleted == true
          ? ImageUtil.loadNetworkImage(
              height: 75.h,
              width: 80.w,
              imageUrl: gameDetailsStamp.stampImageUrl ?? '',
              sourceId: sourceId,
              context: context,
            )
          : ImageUtil.loadAssetImage(
              imageUrl: imagePath["stamps_icon"] ?? '',
              context: context,
            ),
    );
  }

  _chooseLevel(
      List<GameDetailsLevelModel>? gameDetailsChooseLevel,
      String? headingText,
      GameDetailsDataModel? gameDetailsDataModel,
      int sourceId,
      String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        20.verticalSpace,
        textBoldPoppins(
          color: Theme.of(context).primaryColor,
          fontSize: 20,
          textAlign: TextAlign.left,
          text: AppLocalizations.of(context).choose_level,
        ),
        6.verticalSpace,
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: gameDetailsChooseLevel?.length,
            itemBuilder: (_, index) {
              var chooseLevel = gameDetailsChooseLevel![index];

              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: GameTeaserTextCard(
                  onCardTap: () {
                    ref.read(gameNavigationProvider).navigateToGame(
                        context: context,
                        gameId: gameDetailsDataModel?.game?.id ?? 1,
                        levelId: chooseLevel.id,
                        description: description,
                        title: headingText);
                  },
                  imageUrl: chooseLevel.levelImageUrl ?? '',
                  name: chooseLevel.name ?? '',
                  subDescription: headingText ?? '',
                  sourceId: sourceId,
                  playIcon: true,
                  isCompleted: chooseLevel.isCompleted ?? false,
                  chooseLevel: false,
                  isUnlocked: chooseLevel.isUnlocked ?? false,
                ),
              );
            })
      ]),
    );
  }

  _moreGames(
      List<GameDetailsMoreGameModel>? gameDetailsMoreGame, int sourceId) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        20.verticalSpace,
        textBoldPoppins(
          color: Theme.of(context).textTheme.labelLarge?.color,
          fontSize: 20,
          textAlign: TextAlign.left,
          text: AppLocalizations.of(context).more_games,
        ),
        6.verticalSpace,
        ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: gameDetailsMoreGame?.length,
            itemBuilder: (_, index) {
              var moreGame = gameDetailsMoreGame![index];
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: GameTeaserTextCard(
                  onCardTap: () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: brainTeaserGameDetailsScreenPath,
                        context: context,
                        params:
                            BrainTeaserGameDetailsParams(gameId: moreGame.id));
                  },
                  imageUrl: moreGame.gameImageUrl ?? '',
                  name: moreGame.name ?? '',
                  subDescription: moreGame.subDescription ?? '',
                  sourceId: sourceId,
                  backButton: true,
                  isCompleted: false,
                  chooseLevel: true,
                ),
              );
            })
      ]),
    );
  }
}
