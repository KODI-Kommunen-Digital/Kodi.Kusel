import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_text_card_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/providers/favourite_cities_notifier.dart';

import '../../app_router.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/device_helper.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../ort_detail/ort_detail_screen_params.dart';
import 'favourite_city_screen_controller.dart';

class FavouriteCityScreen extends ConsumerStatefulWidget {
  const FavouriteCityScreen({super.key});

  @override
  ConsumerState<FavouriteCityScreen> createState() =>
      _FavouriteCityScreenState();
}

class _FavouriteCityScreenState extends ConsumerState<FavouriteCityScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    Future.microtask(() {
      final state = ref.watch(favouriteCityScreenProvider);
      final controller = ref.read(favouriteCityScreenProvider.notifier);

      controller.fetchFavouriteCities(state.pageNumber);
    });
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  void _onScroll() {
    final controller = ref.read(favouriteCityScreenProvider.notifier);
    final state = ref.watch(favouriteCityScreenProvider);

    if (_scrollController.hasClients) {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !state.isNextPageLoading) {
        controller.fetchLoadMoreFavouriteCities((state.pageNumber + 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favouriteCityScreenProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: state.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final state = ref.watch(favouriteCityScreenProvider);
    final controller = ref.read(favouriteCityScreenProvider.notifier);

    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        child: Column(
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
                        text: AppLocalizations.of(context).favourite_places),
                  ],
                ),
              ),
            ),
            if (!state.isLoading)
              state.cityList.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.cityList.length,
                      itemBuilder: (context, index) {
                        final item = state.cityList[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 12.w),
                          child: ImageTextCardWidget(
                            onTap: () {
                              ref.read(navigationProvider).navigateUsingPath(
                                  path: ortDetailScreenPath,
                                  context: context,
                                  params: OrtDetailScreenParams(
                                      ortId: item.id.toString(),
                                      onFavSuccess: (isFav, id) {
                                        controller.removeFav(id);
                                      }));
                            },
                            imageUrl: item.image ??
                                'https://images.unsplash.com/photo-1584713503693-bb386ec95cf2?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            text: item.name ?? '',
                            sourceId: 1,
                            isFavourite: true,
                            isFavouriteVisible: true,
                            onFavoriteTap: () {
                              ref
                                  .watch(favouriteCitiesNotifier.notifier)
                                  .removeFavorite(
                                item.id ?? 0,
                                ({required bool isFavorite}) {
                                  ref
                                      .read(
                                          favouriteCityScreenProvider.notifier)
                                      .removeFav(item.id);
                                },
                                ({required String message}) {
                                  showErrorToast(
                                      message: message, context: context);
                                },
                              );
                            },
                          ),
                        );
                      })
                  : Center(
                      child: textHeadingMontserrat(
                          text: AppLocalizations.of(context).no_data,
                          fontSize: 18),
                    ),
            if (state.isNextPageLoading) CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
