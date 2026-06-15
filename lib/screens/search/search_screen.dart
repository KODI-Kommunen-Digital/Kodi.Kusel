import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/search_widget/search_widget.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/search/search_screen_provider.dart';
import 'package:kusel/screens/search_result/search_result_screen_parameter.dart';

import '../../common_widgets/search_widget/search_widget_provider.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../dashboard/dashboard_screen_provider.dart';
import '../event/event_detail_screen_controller.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<SearchScreen> {
  final searchTextEditingController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  void initState() {
    searchFocusNode.addListener(() => _scrollToFocused(searchFocusNode));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchScreenProvider.notifier).loadSavedListings();
    });
    MatomoService.trackSearchScreenViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height, child: buildUi()),
      ),
    );
  }

  Widget buildUi() {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        ref.read(dashboardScreenProvider.notifier).onScreenNavigation();
      },
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            CommonBackgroundClipperWidget(
                clipperType: UpstreamWaveClipper(),
                imageUrl: imagePath['home_screen_background'] ?? '',
                height: 210.h,
                customWidget1: Positioned(
                  top: 24.h,
                  left: 20.w,
                  right: 20.w,
                  child: Column(
                    children: [
                      Container(
                        height: 190.h,
                        width: 256.w,
                        decoration: BoxDecoration(),
                        child: Image.asset(
                          imagePath['dino_with_bg'] ?? "",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
                isStaticImage: true),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  8.verticalSpace,
                  textBoldPoppins(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                      text: AppLocalizations.of(context).search_heading,
                      fontSize: 18),
                  16.verticalSpace,
                  CustomButton(
                    searchScreen: true,
                    onPressed: () {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: searchResultScreenPath,
                          context: context,
                          params: SearchResultScreenParameter(
                              searchType: SearchType.nearBy));
                    },
                    text: AppLocalizations.of(context).near_me,
                    isOutLined: true,
                    icon: imagePath['explore'],
                    iconWidth: 20.w,
                    iconHeight: 20.w,
                    textColor: Theme.of(context).textTheme.labelLarge?.color,
                  ),
                  8.verticalSpace,
                  CustomButton(
                      onPressed: () {
                        ref.read(navigationProvider).navigateUsingPath(
                            path: searchResultScreenPath,
                            context: context,
                            params: SearchResultScreenParameter(
                                searchType: SearchType.recommendations));
                      },
                      text: AppLocalizations.of(context).recommendations,
                      isOutLined: true,
                      icon: imagePath['star'],
                      iconWidth: 20.w,
                      iconHeight: 20.w,
                      textColor: Theme.of(context).textTheme.labelLarge?.color),
                  16.verticalSpace,
                  Divider(thickness: 1.h),
                  16.verticalSpace,
                  SearchWidget(
                    verticalDirection: VerticalDirection.up,
                    onItemClick: (listing) {
                      ref
                          .read(dashboardScreenProvider.notifier)
                          .onScreenNavigation();
                      ref.read(navigationProvider).navigateUsingPath(
                          context: context,
                          path: eventDetailScreenPath,
                          params: EventDetailScreenParams(
                              eventId: listing.id ?? 0));
                      ref
                          .read(searchScreenProvider.notifier)
                          .loadSavedListings();
                    },
                    searchController: ref.watch(searchProvider),
                    hintText: AppLocalizations.of(context).enter_search_term,
                      suggestionCallback: (search) async {
                        List<Listing>? list;
                        if (search.isEmpty) return [];
                        try {
                          list = await ref
                              .read(searchScreenProvider.notifier)
                              .searchList(
                              searchText: search,
                              success: () {},
                              error: (err) {});
                        } catch (e) {
                          print("exception >>$e");
                          return [];
                        }
                        final sortedList = ref
                            .watch(searchScreenProvider.notifier)
                            .sortSuggestionList(search, list);
                        return sortedList;
                      },
                    isPaddingEnabled: false,
                  ),
                  16.verticalSpace,
                  Visibility(
                    visible:
                        ref.watch(searchScreenProvider).searchedList.isNotEmpty,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: textSemiBoldPoppins(
                          text: AppLocalizations.of(context).recent_search,
                          fontSize: 18),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        ref.watch(searchScreenProvider).searchedList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          ref
                              .read(dashboardScreenProvider.notifier)
                              .onScreenNavigation();
                          ref.read(navigationProvider).navigateUsingPath(
                              context: context,
                              path: eventDetailScreenPath,
                              params: EventDetailScreenParams(
                                  eventId: ref
                                          .watch(searchScreenProvider)
                                          .searchedList[index]
                                          .id ??
                                      0));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: textRegularMontserrat(
                                text: ref
                                        .watch(searchScreenProvider)
                                        .searchedList[index]
                                        .title ??
                                    "",
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      );
                    },
                  ),
                  72.verticalSpace
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _scrollToFocused(FocusNode focusNode) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final context = focusNode.context;
      if (context != null && context.mounted) {
        Scrollable.ensureVisible(context,
            duration: const Duration(milliseconds: 300));
      }
    });
  }
}
