import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/event_list_section_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/favorite/favorites_list_screen_controller.dart';
import 'package:kusel/screens/location/bottom_sheet_selected_ui_type.dart';
import 'package:kusel/screens/location/location_screen_provider.dart';
import 'package:kusel/screens/location/location_screen_state.dart';

import '../../../common_widgets/search_widget/search_widget_provider.dart';
import '../../../common_widgets/search_widget/search_widget.dart';
import '../../dashboard/dashboard_screen_provider.dart';
import '../../favorite/favorites_list_screen_state.dart';

class SelectedFilterScreen extends ConsumerStatefulWidget {
  SelectedFilterScreenParams selectedFilterScreenParams;
  ScrollController scrollController;

  SelectedFilterScreen(
      {super.key,
      required this.selectedFilterScreenParams,
      required this.scrollController});

  @override
  ConsumerState<SelectedFilterScreen> createState() =>
      _SelectedFilterScreenState();
}

class _SelectedFilterScreenState extends ConsumerState<SelectedFilterScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final locationNotifier = ref.read(locationScreenProvider.notifier);
      final locationState = ref.read(locationScreenProvider);
      final favNotifier = ref.read(favoritesListScreenProvider.notifier);
      final favState = ref.read(favoritesListScreenProvider);

      final categoryId = widget.selectedFilterScreenParams.categoryId;

      if (categoryId == 100) {
        // Only fetch favorites if not already fetched
        final alreadyFetchedFav = favState.eventsList.isNotEmpty;
        if (!alreadyFetchedFav) {
          debugPrint("Fetching favorites for categoryId 100");
          favNotifier.getFavoritesList(1);
        } else {
          debugPrint("Skipping fetch, favorites already fetched");
        }
      } else {
        // For other categories, fetch only if not already fetched
        final alreadyFetched =
            locationState.categoryEventLists[categoryId]?.isNotEmpty ?? false;
        if (!alreadyFetched) {
          debugPrint("Fetching data for categoryId $categoryId");
          locationNotifier.getAllEventListUsingCategoryId(
              categoryId.toString(), 1);
          locationNotifier.markCategoryAsFetched(categoryId);
        } else {
          debugPrint("Skipping fetch, already fetched categoryId $categoryId");
          locationNotifier.getAllEventListUsingCategoryId(
              categoryId.toString(), 1);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    LocationScreenState state = ref.watch(locationScreenProvider);
    final FavoritesListScreenState favScreenState =
        ref.watch(favoritesListScreenProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        ref.read(dashboardScreenProvider.notifier).onScreenNavigation();
      },
      child: Column(
        children: [
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  ref
                      .read(locationScreenProvider.notifier)
                      .updateBottomSheetSelectedUIType(
                          BottomSheetSelectedUIType.allEvent);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref
                        .read(locationScreenProvider.notifier)
                        .updateSlidingUpPanelIsDragStatus(true);
                  });
                },
                icon: Icon(
                  size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                  Icons.arrow_back,
                  color: Theme.of(context).textTheme.labelMedium!.color,
                ),
              ),
              DeviceHelper.isMobile(context)
                  ? 80.horizontalSpace
                  : 110.horizontalSpace,
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      color: Theme.of(context).textTheme.labelMedium!.color,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          15.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: SearchWidget(
              onItemClick: (listing) {
                ref.read(locationScreenProvider.notifier).setEventItem(listing);
                ref
                    .read(locationScreenProvider.notifier)
                    .updateBottomSheetSelectedUIType(
                        BottomSheetSelectedUIType.eventDetail);
              },
              searchController: ref.watch(searchProvider),
              hintText: AppLocalizations.of(context).enter_search_term,
              suggestionCallback: (search) async {
                List<Listing>? list;
                if (search.isEmpty) return [];
                try {
                  list = await ref
                      .read(locationScreenProvider.notifier)
                      .searchList(
                          searchText: search, success: () {}, error: (err) {});
                } catch (e) {
                  return [];
                }
                final sortedList = ref
                    .watch(locationScreenProvider.notifier)
                    .sortSuggestionList(search, list);
                return sortedList;
              },
              isPaddingEnabled: true,
            ),
          ),
          18.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: textSemiBoldPoppins(
                  fontWeight: FontWeight.w600,
                  text:
                      "${widget.selectedFilterScreenParams.categoryId == 100 ? AppLocalizations.of(context).map_fav : state.selectedCategoryName}",
                  fontSize: 16),
            ),
          ),
          if (ref.watch(locationScreenProvider).isSelectedFilterScreenLoading ||
              favScreenState.loading)
            Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: SingleChildScrollView(
                  controller: widget.scrollController,
                  physics: const ClampingScrollPhysics(),
                  child: widget.selectedFilterScreenParams.categoryId == 100
                      ? EventsListSectionWidget(
                          categoryId: widget
                              .selectedFilterScreenParams.categoryId
                              .toString(),
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
                        )
                      : EventsListSectionWidget(
                          categoryId: widget
                              .selectedFilterScreenParams.categoryId
                              .toString(),
                          shrinkWrap: true,
                          scrollController: widget.scrollController,
                          eventsList: state.categoryEventLists[widget
                                  .selectedFilterScreenParams.categoryId] ??
                              [],
                          heading: null,
                          maxListLimit: state
                                  .categoryEventLists[widget
                                      .selectedFilterScreenParams.categoryId]
                                  ?.length ??
                              0,
                          buttonText: null,
                          buttonIconPath: null,
                          isLoading: false,
                          onButtonTap: () {},
                          context: context,
                          isFavVisible: true,
                          onHeadingTap: () {},
                          onSuccess: (bool isFav, int? id) {
                            ref
                                .read(locationScreenProvider.notifier)
                                .updateIsFav(isFav, id);
                          },
                          onFavClickCallback: () {},
                          isMultiplePagesList: ref
                              .watch(locationScreenProvider)
                              .isLoadMoreButtonEnabled,
                          onLoadMoreTap: () {
                            ref
                                .read(locationScreenProvider.notifier)
                                .onLoadMoreList(widget
                                    .selectedFilterScreenParams.categoryId
                                    .toString());
                          },
                          isMoreListLoading: ref
                              .watch(locationScreenProvider)
                              .isMoreListLoading,
                        )),
            ),
          60.verticalSpace,
        ],
      ),
    );
  }
}

class SelectedFilterScreenParams {
  int categoryId;

  SelectedFilterScreenParams({required this.categoryId});
}
