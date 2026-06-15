import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:kusel/common_widgets/location_const.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';
import 'package:kusel/screens/search_result/search_result_screen_parameter.dart';
import 'package:kusel/screens/search_result/search_result_screen_provider.dart';
import 'package:kusel/screens/search_result/search_result_screen_state.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/device_helper.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';

class SearchResultScreen extends ConsumerStatefulWidget {
  final SearchResultScreenParameter searchResultScreenParameter;

  const SearchResultScreen(
      {super.key, required this.searchResultScreenParameter});

  @override
  ConsumerState<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends ConsumerState<SearchResultScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(searchResultScreenProvider.notifier)
          .getEventsList(widget.searchResultScreenParameter.searchType);

      ref.read(searchResultScreenProvider.notifier).isUserLoggedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SearchResultScreenState searchResultScreenState =
        ref.watch(searchResultScreenProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: searchResultScreenState.loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(child: _buildBody(searchResultScreenState, context)),
    );
  }

  Widget _buildBody(
      SearchResultScreenState searchResultScreenState, BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          CommonBackgroundClipperWidget(
            clipperType: UpstreamWaveClipper(),
            height: 105.h,
            imageUrl: imagePath['home_screen_background'] ?? '',
            isStaticImage: true,
            isBackArrowEnabled: false,
            customWidget1: Positioned(
              left: 0.w,
              top: 30.h,
              child: Row(
                children: [
                  16.horizontalSpace,
                  IconButton(
                      onPressed: () {
                        ref.read(navigationProvider).removeTopPage(context: context);
                      },
                      icon: Icon(
                          size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                          color: Theme.of(context).primaryColor,
                          Icons.arrow_back)
                  ),
                  8.horizontalSpace,
                  textBoldPoppins(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      text: (widget.searchResultScreenParameter.searchType == SearchType.nearBy)
                          ? AppLocalizations.of(context).search_result
                          : AppLocalizations.of(context).recommendations,),
                ],
              ),
            ),
          ),

          if(!searchResultScreenState.loading)
          searchResultScreenState.groupedEvents.isEmpty
              ? Center(
                  child: textHeadingMontserrat(
                      text: AppLocalizations.of(context).no_data),
                )
              : Column(
                  children: _buildList(searchResultScreenState, context),
                )
        ],
      ),
    );
  }

  List<Widget> _buildList(
      SearchResultScreenState searchResultScreenState, BuildContext context) {
    return searchResultScreenState.groupedEvents.entries.expand((entry) {
      final categoryId = entry.key;
      final items =
          ref.read(searchResultScreenProvider.notifier).subList(entry.value);

      return [
        EventsListSectionWidget(
          boxFit: BoxFit.cover,
          eventsList: items,
          heading: items.first.categoryName,
          maxListLimit: 3,
          buttonText: null,
          buttonIconPath: null,
          isLoading: false,
          onButtonTap: () {},
          context: context,
          isFavVisible: true,
          onHeadingTap: () {
            if (widget.searchResultScreenParameter.searchType ==
                SearchType.nearBy) {
              ref.read(navigationProvider).navigateUsingPath(
                    path: selectedEventListScreenPath,
                    context: context,
                    params: SelectedEventListScreenParameter(
                      listHeading: items.first.categoryName,
                      categoryId: categoryId,
                      radius: SearchRadius.radius.value,
                      centerLatitude: EventLatLong.kusel.latitude,
                      centerLongitude: EventLatLong.kusel.longitude,
                      onFavChange: () {
                        ref
                            .read(searchResultScreenProvider.notifier)
                            .getEventsList(
                                widget.searchResultScreenParameter.searchType);
                      },
                    ),
                  );
            } else {
              ref.read(navigationProvider).navigateUsingPath(
                    path: selectedEventListScreenPath,
                    context: context,
                    params: SelectedEventListScreenParameter(
                      listHeading: items.first.categoryName,
                      categoryId: categoryId,
                      onFavChange: () {
                        ref
                            .read(searchResultScreenProvider.notifier)
                            .getEventsList(
                                widget.searchResultScreenParameter.searchType);
                      },
                    ),
                  );
            }
          },
          onFavClickCallback: () {
            ref
                .read(searchResultScreenProvider.notifier)
                .getEventsList(widget.searchResultScreenParameter.searchType);
          },
          onSuccess: (bool isFav, int? id) {
            ref
                .read(searchResultScreenProvider.notifier)
                .updateIsFav(isFav, id);
          },
        )
      ];
    }).toList();
  }
}
