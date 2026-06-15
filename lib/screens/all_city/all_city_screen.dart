import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_text_card_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/providers/favourite_cities_notifier.dart';
import 'package:kusel/screens/all_city/all_city_screen_controller.dart';

import '../../app_router.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/toast_message.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../ort_detail/ort_detail_screen_params.dart';

class AllCityScreen extends ConsumerStatefulWidget {
  final AllCityScreenParams allCityScreenParams;

  const AllCityScreen({super.key, required this.allCityScreenParams});

  @override
  ConsumerState<AllCityScreen> createState() => _AllCityScreenState();
}

class _AllCityScreenState extends ConsumerState<AllCityScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(allCityScreenProvider.notifier).fetchCities();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: _buildBody(context)),
    ).loaderDialog(context, ref.watch(allCityScreenProvider).isLoading);
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          CommonBackgroundClipperWidget(
              clipperType: UpstreamWaveClipper(),
              imageUrl: imagePath['background_image'] ?? "",
              headingText: AppLocalizations.of(context).cities,
              height: 120.h,
              blurredBackground: true,
              isBackArrowEnabled: true,
              isStaticImage: true),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ref.read(allCityScreenProvider).cityList.length,
              itemBuilder: (context, index) {
                final item = ref.read(allCityScreenProvider).cityList[index];
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
                  child: ImageTextCardWidget(
                    onTap: () {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: ortDetailScreenPath,
                          context: context,
                          params: OrtDetailScreenParams(
                              ortId: item.id.toString(),
                              onFavSuccess: (isFav, id) {
                                _updateList(isFav ?? false, id ?? 0);
                              }));
                    },
                    imageUrl: item.image ??
                        'https://images.unsplash.com/photo-1584713503693-bb386ec95cf2?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                    text: item.name ?? '',
                    sourceId: 1,
                    isFavouriteVisible: true,
                    isFavourite: item.isFavorite,
                    onFavoriteTap: () {
                      ref
                          .watch(favouriteCitiesNotifier.notifier)
                          .toggleFavorite(
                            isFavourite: item.isFavorite,
                            id: item.id,
                            success: ({required bool isFavorite}) {
                              _updateList(isFavorite, item.id!);
                              widget.allCityScreenParams
                                  .onFavSuccess(isFavorite, item.id!);
                            },
                            error: ({required String message}) {
                              showErrorToast(
                                  message: message, context: context);
                            },
                          );
                    },
                  ),
                );
              })
        ],
      ),
    );
  }

  _updateList(bool isFav, int cityId) {
    ref.read(allCityScreenProvider.notifier).setIsFavoriteCity(isFav, cityId);
  }
}
