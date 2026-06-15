import 'package:domain/model/response_model/digifit/digifit_information_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/digifit_screens/digifit_fav_screen/digifit_fav_controller.dart';
import 'package:kusel/screens/digifit_screens/digifit_start/digifit_information_controller.dart';

import '../../../app_router.dart';
import '../../../common_widgets/common_background_clipper_widget.dart';
import '../../../common_widgets/device_helper.dart';
import '../../../common_widgets/digifit/digifit_text_image_card.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../common_widgets/upstream_wave_clipper.dart';
import '../../../images_path.dart';
import '../../../l10n/app_localizations.dart';
import '../../../navigation/navigation.dart';
import '../../../providers/digifit_equipment_fav_provider.dart';
import '../digifit_exercise_detail/params/digifit_exercise_details_params.dart';

class DigifitFavScreen extends ConsumerStatefulWidget {
  const DigifitFavScreen({super.key});

  @override
  ConsumerState<DigifitFavScreen> createState() => _DigifitFavScreenState();
}

class _DigifitFavScreenState extends ConsumerState<DigifitFavScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    Future.microtask(() {
      final state = ref.watch(digifitFavControllerProvider);
      final controller = ref.read(digifitFavControllerProvider.notifier);
      controller.getDigifitFavList(state.pageNumber);
    });

    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    final controller = ref.read(digifitFavControllerProvider.notifier);
    final state = ref.watch(digifitFavControllerProvider);

    if (_scrollController.hasClients) {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !state.isNextPageLoading) {
        controller.getLoadMoreDigifitFavList((state.pageNumber + 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(digifitFavControllerProvider);
    final controller = ref.read(digifitFavControllerProvider.notifier);

    return PopScope(
      onPopInvokedWithResult: (value, _) {
        //ref.read(digifitInformationControllerProvider.notifier).fetchDigifitInformation();
      },
      child: Scaffold(
        body: (state.isLoading)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    final state = ref.watch(digifitFavControllerProvider);
    final controller = ref.read(digifitFavControllerProvider.notifier);

    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CommonBackgroundClipperWidget(
              clipperType: UpstreamWaveClipper(),
              imageUrl: imagePath['background_image'] ?? "",
              height: 120.h,
              blurredBackground: true,
              isBackArrowEnabled: false,
              isStaticImage: true,
              customWidget1: Positioned(
                left: 0.w,
                top: 20.h,
                child: Row(
                  children: [
                    16.horizontalSpace,
                    IconButton(
                        onPressed: () {
                          ref
                              .read(navigationProvider)
                              .removeTopPage(context: context);
                        },
                        icon: Icon(
                            size:
                                DeviceHelper.isMobile(context) ? null : 12.h.w,
                            color: Theme.of(context).primaryColor,
                            Icons.arrow_back)),
                    12.horizontalSpace,
                    textBoldPoppins(
                        color: Theme.of(context).textTheme.labelLarge?.color,
                        fontSize: 19,
                        text: AppLocalizations.of(context).digifit),
                  ],
                ),
              ),
            ),
            (state.equipmentList.isEmpty)
                ? Center(
                    child: textHeadingMontserrat(
                        text: AppLocalizations.of(context).no_data,
                        fontSize: 18),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.equipmentList.length,
                    itemBuilder: (context, index) {
                      final station = state.equipmentList[index];
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: 2.h, left: 12.w, right: 12.w),
                        child: DigifitTextImageCard(
                          onCardTap: () {
                            ref.read(navigationProvider).navigateUsingPath(
                                path: digifitExerciseDetailScreenPath,
                                context: context,
                                params: DigifitExerciseDetailsParams(
                                    station: DigifitInformationStationModel(
                                      id: station.equipmentId,
                                      name: station.name,
                                      isFavorite: station.isFavorite,
                                      muscleGroups: station.muscleGroup,
                                    ),
                                    locationId: station.locationId ?? 0,
                                    onFavCallBack: () {
                                      controller.getDigifitFavList(1);
                                    }));
                          },
                          imageUrl: station.machineImageUrls ?? '',
                          heading: station.muscleGroup ?? '',
                          title: station.name ?? '',
                          isFavouriteVisible: true,
                          isFavorite: station.isFavorite ?? false,
                          sourceId: 1,
                          isCompleted: station.isCompleted ?? true,
                          //station.,
                          onFavorite: () async {
                            DigifitEquipmentFavParams params =
                                DigifitEquipmentFavParams(
                                    isFavorite: !station.isFavorite!,
                                    equipmentId: station.equipmentId!,
                                    locationId: station.locationId!);

                            await controller.changeFav(params);
                          },
                        ),
                      );
                    }),
            if (state.isNextPageLoading) CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
