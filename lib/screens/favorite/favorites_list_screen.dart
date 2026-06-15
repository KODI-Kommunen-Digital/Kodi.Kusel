import 'package:flutter/material.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_params.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/device_helper.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../common_widgets/image_utility.dart';
import '../../images_path.dart';
import 'favorites_list_screen_controller.dart';
import 'favorites_list_screen_state.dart';

class FavoritesListScreen extends ConsumerStatefulWidget {
  const FavoritesListScreen({super.key});

  @override
  ConsumerState<FavoritesListScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<FavoritesListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoritesListScreenProvider.notifier).getFavoritesList(1);
    });

    MatomoService.trackFavouriteEventsScreenViewed();

    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final FavoritesListScreenState favScreenState =
        ref.watch(favoritesListScreenProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: favScreenState.loading
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(favScreenState, context),
    );
  }

  void _onScroll() {
    final controller = ref.read(favoritesListScreenProvider.notifier);
    final state = ref.watch(favoritesListScreenProvider);

    if (_scrollController.hasClients) {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !state.isPaginationLoading) {
        controller.getLoadMoreList((state.pageNumber + 1));
      }
    }
  }

  Widget _buildBody(
      FavoritesListScreenState favScreenState, BuildContext context) {
    final state = ref.watch(favoritesListScreenProvider);
    final controller = ref.read(favoritesListScreenProvider.notifier);

    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            CommonBackgroundClipperWidget(
              clipperType: UpstreamWaveClipper(),
              height: 130.h,
              imageUrl: imagePath['home_screen_background'] ?? '',
              isStaticImage: true,
              isBackArrowEnabled: false,
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
                        text: AppLocalizations.of(context).favorites),
                  ],
                ),
              ),
              filterWidget: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    ref
                        .read(navigationProvider)
                        .navigateUsingPath(
                            path: newFilterScreenPath,
                            context: context,
                            params: NewFilterScreenParams(
                                selectedCityId: state.selectedCityId,
                                selectedCityName: state.selectedCityName,
                                radius: state.radius,
                                startDate: state.startDate,
                                endDate: state.endDate,
                                selectedCategoryName:
                                    List.from(state.selectedCategoryNameList),
                                selectedCategoryId:
                                    List.from(state.selectedCategoryIdList)))
                        .then((value) async {
                      if (value != null) {
                        final res = value as NewFilterScreenParams;

                        await controller.applyNewFilterValues(
                            res.selectedCategoryName,
                            res.selectedCityId,
                            res.selectedCityName,
                            res.radius,
                            res.startDate,
                            res.endDate,
                            res.selectedCategoryId);

                        await controller.getFavoritesList(1);
                      }
                    });
                  },
                  child: Badge(
                    backgroundColor: Colors.transparent,
                    alignment: Alignment.topCenter,
                    isLabelVisible: state.numberOfFiltersApplied != 0,
                    label: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).indicatorColor,
                          border: Border.all(
                              color: Theme.of(context).colorScheme.secondary)),
                      child: Center(
                        child: textBoldMontserrat(
                            text: state.numberOfFiltersApplied.toString(),
                            fontSize: 14),
                      ),
                    ),
                    child: ImageUtil.loadLocalSvgImage(
                        imageUrl: 'filter_button',
                        context: context,
                        height: 35.h,
                        width: 35.w),
                  ),
                ),
              ),
            ),
            if (!favScreenState.loading)
              favScreenState.eventsList.isEmpty
                  ? Center(
                      child: textHeadingMontserrat(
                          text: AppLocalizations.of(context).no_data,
                          fontSize: 18),
                    )
                  : EventsListSectionWidget(
                      eventsList: favScreenState.eventsList,
                      heading: null,
                      maxListLimit: favScreenState.eventsList.length,
                      buttonText: null,
                      buttonIconPath: null,
                      isLoading: false,
                      onButtonTap: () {},
                      context: context,
                      isFavVisible: true,
                      onHeadingTap: () {},
                      onSuccess: (bool isFav, int? id) {
                        ref
                            .read(favoritesListScreenProvider.notifier)
                            .removeFavorite(id);
                      },
                      onFavClickCallback: () {
                        ref
                            .read(favoritesListScreenProvider.notifier)
                            .getFavoritesList(1);
                      },
                    ),
            if (state.isPaginationLoading) CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
