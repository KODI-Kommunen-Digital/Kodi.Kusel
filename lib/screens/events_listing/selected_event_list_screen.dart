import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_controller.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/device_helper.dart';
import '../../common_widgets/event_list_section_widget.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import 'selected_event_list_screen_state.dart';

class SelectedEventListScreen extends ConsumerStatefulWidget {
  final SelectedEventListScreenParameter eventListScreenParameter;

  const SelectedEventListScreen(
      {super.key, required this.eventListScreenParameter});

  @override
  ConsumerState<SelectedEventListScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<SelectedEventListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentPageNumber =
          ref.read(selectedEventListScreenProvider).currentPageNo;
      ref
          .read(selectedEventListScreenProvider.notifier)
          .getEventsList(widget.eventListScreenParameter, currentPageNumber);

      ref.read(selectedEventListScreenProvider.notifier).isUserLoggedIn();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPageNumber =
        ref.watch(selectedEventListScreenProvider).currentPageNo;
    final SelectedEventListScreenState categoryScreenState =
        ref.watch(selectedEventListScreenProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: categoryScreenState.loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RefreshIndicator(
                  onRefresh: () async {
                    final currentPageNumber =
                        ref.read(selectedEventListScreenProvider).currentPageNo;
                    ref
                        .read(selectedEventListScreenProvider.notifier)
                        .getEventsList(
                            widget.eventListScreenParameter, currentPageNumber);

                    ref
                        .read(selectedEventListScreenProvider.notifier)
                        .isUserLoggedIn();
                  },
                  child: _buildBody(
                      categoryScreenState, context, currentPageNumber))),
    );
  }

  Widget _buildBody(SelectedEventListScreenState categoryScreenState,
      BuildContext context, int currentPageNumber) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          CommonBackgroundClipperWidget(
            clipperType: UpstreamWaveClipper(),
            height: 110.h,
            imageUrl: imagePath['home_screen_background'] ?? '',
            isStaticImage: true,
            isBackArrowEnabled: false,
            customWidget1: Positioned(
              top: 28.h,
              left: 15.w,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        ref
                            .read(navigationProvider)
                            .removeTopPage(context: context);
                      },
                      icon: Icon(
                          size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                          color: Theme.of(context).primaryColor,
                          Icons.arrow_back)),
                  12.horizontalSpace,
                  textBoldPoppins(
                      color: Theme.of(context).textTheme.labelLarge?.color,
                      fontSize: 19,
                      text: categoryScreenState.heading ?? '')
                ],
              ),
            ),
          ),
          if (!ref.watch(selectedEventListScreenProvider).loading)
            ref.watch(selectedEventListScreenProvider).eventsList.isEmpty
                ? Center(
                    child: textHeadingMontserrat(
                        text: AppLocalizations.of(context).no_data),
                  )
                : EventsListSectionWidget(
                  categoryId: widget.eventListScreenParameter.categoryId.toString(),
                    boxFit: BoxFit.cover,
                    eventsList:
                        ref.watch(selectedEventListScreenProvider).eventsList,
                    heading: null,
                    maxListLimit: ref
                        .watch(selectedEventListScreenProvider)
                        .eventsList
                        .length,
                    buttonText: null,
                    buttonIconPath: null,
                    isLoading: false,
                    onButtonTap: () {},
                    context: context,
                    isFavVisible: true,
                    onHeadingTap: () {},
                    onFavClickCallback: () {
                      ref
                          .read(selectedEventListScreenProvider.notifier)
                          .getEventsList(widget.eventListScreenParameter,
                              currentPageNumber);
                    },
                    onSuccess: (bool isFav, int? id) {
                      ref
                          .read(selectedEventListScreenProvider.notifier)
                          .updateIsFav(isFav, id);

                      widget.eventListScreenParameter.onFavChange();
                    },
                    isMultiplePagesList: ref
                        .watch(selectedEventListScreenProvider)
                        .isLoadMoreButtonEnabled,
                    onLoadMoreTap: () {
                      ref
                          .read(selectedEventListScreenProvider.notifier)
                          .onLoadMoreList(widget.eventListScreenParameter);
                    },
                    isMoreListLoading: ref
                        .watch(selectedEventListScreenProvider)
                        .isMoreListLoading,
                  )
        ],
      ),
    );
  }
}
