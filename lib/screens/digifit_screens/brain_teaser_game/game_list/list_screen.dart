import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/digifit_screens/brain_teaser_game/game_details/params/details_params.dart';

import '../../../../app_router.dart';
import '../../../../common_widgets/device_helper.dart';
import '../../../../common_widgets/digifit/brain_teaser_game/game_text_card.dart';
import '../../../../common_widgets/text_styles.dart';
import '../../../../images_path.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../navigation/navigation.dart';
import 'list_controller.dart';

class BrainTeaserGameListScreen extends ConsumerStatefulWidget {
  const BrainTeaserGameListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BrainTeaserGameListScreenState();
  }
}

class _BrainTeaserGameListScreenState
    extends ConsumerState<BrainTeaserGameListScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(brainTeaserGameListControllerProvider.notifier)
          .fetchBrainTeaserGameList();
    });
    MatomoService.trackBrainTeaserViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(brainTeaserGameListControllerProvider);
    final sourceId = state.brainTeaserGameListDataModel?.sourceId ?? 1;
    final brainTeaserGameList = state.brainTeaserGameListDataModel?.games ?? [];
    final isLoading = state.isLoading;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Stack(
                children: [
                  CommonBackgroundClipperWidget(
                      height: 220.h,
                      clipperType: UpstreamWaveClipper(),
                      imageUrl: imagePath['home_screen_background'] ?? '',
                      isStaticImage: true),
                  Positioned(
                      top: 40.h,
                      left: 4.r,
                      child: _buildHeadingArrowSection()),
                  Padding(
                    padding: EdgeInsets.only(top: 125.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBrainTeaserGameListUi(
                            sourceId, brainTeaserGameList),
                        30.verticalSpace,
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
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ).loaderDialog(context, isLoading);
  }

  _buildHeadingArrowSection() {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
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
          text: AppLocalizations.of(context).brain_teasers_list_title,
        ),
      ],
    );
  }

  _buildBrainTeaserGameListUi(int sourceId, List brainTeaserGameList) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: brainTeaserGameList.length,
          itemBuilder: (context, index) {
            var games = brainTeaserGameList[index];
            return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: GameTeaserTextCard(
                  onCardTap: () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: brainTeaserGameDetailsScreenPath,
                        context: context,
                        params: BrainTeaserGameDetailsParams(gameId: games.id));
                  },
                  imageUrl: games.gameImageUrl ?? '',
                  name: games.name ?? '',
                  subDescription: games.subDescription ?? '',
                  backButton: true,
                  isCompleted: false,
                  sourceId: sourceId,
                  chooseLevel: true,
                ));
          }),
    );
  }
}
