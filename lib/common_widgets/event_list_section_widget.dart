import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/toast_message.dart';

import '../app_router.dart';
import '../images_path.dart';
import '../navigation/navigation.dart';
import '../providers/favorites_list_notifier.dart';
import '../screens/event/event_detail_screen_controller.dart';
import 'common_event_card.dart';
import 'custom_button_widget.dart';
import 'custom_shimmer_widget.dart';
import 'image_utility.dart';

class EventsListSectionWidget extends ConsumerStatefulWidget {
  final List<Listing> eventsList;
  final String? heading;
  final int maxListLimit;
  final String? buttonText;
  final String? buttonIconPath;
  final bool isLoading;
  final bool? showEventLoading;
  final VoidCallback? onButtonTap;
  final BuildContext context;
  final VoidCallback onHeadingTap;
  final bool isFavVisible;
  void Function(bool isFav, int? id) onSuccess;
  void Function()? onFavClickCallback;
  bool? shrinkWrap; // by default it is true
  final bool isMultiplePagesList;
  void Function()? onLoadMoreTap;
  final bool isMoreListLoading;
  final int pageSize;
  ScrollController? scrollController;
  void Function(int)? onCardTap;
  final BoxFit? boxFit;
  final String? categoryId;

  EventsListSectionWidget(
      {super.key,
      required this.eventsList,
      required this.heading,
      required this.maxListLimit,
      this.buttonText,
      this.buttonIconPath,
      required this.isLoading,
      this.showEventLoading,
      this.onButtonTap,
      required this.context,
      required this.isFavVisible,
      required this.onHeadingTap,
      this.shrinkWrap,
      required this.onSuccess,
      this.onFavClickCallback,
      this.isMultiplePagesList = false,
      this.onLoadMoreTap,
      this.isMoreListLoading = false,
      this.pageSize = 9,
      this.scrollController,
      this.onCardTap,
      this.categoryId,
      this.boxFit});

  @override
  ConsumerState<EventsListSectionWidget> createState() =>
      _EventsListSectionWidgetState();
}

class _EventsListSectionWidgetState
    extends ConsumerState<EventsListSectionWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 16.w, 12.w, 0),
            child: CustomShimmerWidget.rectangular(
              height: 15.h,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: widget.scrollController,
            shrinkWrap: widget.shrinkWrap ?? true,
            itemCount: 4,
            itemBuilder: (_, index) => eventCartShimmerEffect(),
          ),
        ],
      );
    }

    return Consumer(builder: (context, ref, _) {
      return (widget.showEventLoading ?? false)
          ? SizedBox(
              height: 20.h,
              width: 20.w,
              child: CircularProgressIndicator(),
            )
          : (widget.eventsList.isEmpty)
              ? Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.heading != null)
                        textRegularPoppins(
                          text: widget.heading!,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      if (widget.heading != null) 16.verticalSpace,
                      textRegularPoppins(
                        text: AppLocalizations.of(context).no_data,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      20.verticalSpace,
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.heading != null)
                      Padding(
                        padding: EdgeInsets.fromLTRB(10.w, 10.w, 0, 10),
                        child: InkWell(
                          onTap: widget.onHeadingTap,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10.w),
                                child: textRegularPoppins(
                                  text: widget.heading!,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                              12.horizontalSpace,
                              ImageUtil.loadSvgImage(
                                imageUrl: imagePath['arrow_icon'] ?? "",
                                context: context,
                                height: 10.h,
                                width: 16.w,
                              ),
                            ],
                          ),
                        ),
                      ),
                    10.verticalSpace,
                    ListView.builder(
                      shrinkWrap: widget.shrinkWrap ?? true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.eventsList.length > widget.maxListLimit
                          ? widget.maxListLimit
                          : widget.eventsList.length,
                      itemBuilder: (_, index) {
                        final item = widget.eventsList[index];

                        return CommonEventCard(
                          boxFit: widget.boxFit,
                          isFavorite: item.isFavorite ?? false,
                          onFavorite: () {
                            ref
                                .watch(favoritesProvider.notifier)
                                .toggleFavorite(
                              item,
                              success: ({required bool isFavorite}) {
                                _updateList(isFavorite, item.id!);
                              },
                              error: ({required String message}) {
                                showErrorToast(
                                    message: message, context: context);
                              },
                            );
                          },
                          imageUrl: item.logo ?? "",
                          date: item.startDate ?? "",
                          title: item.title ?? "",
                          location: item.address ?? "",
                          onCardTap: () {
                            ref.read(navigationProvider).navigateUsingPath(
                                  context: context,
                                  path: eventDetailScreenPath,
                                  params: EventDetailScreenParams(
                                    categoryId: widget.categoryId,
                                    eventId: item.id ?? 0,
                                    onFavClick: () {
                                      widget.onFavClickCallback!();
                                    },
                                  ),
                                );
                          },
                          isFavouriteVisible: widget.isFavVisible,
                          sourceId: item.sourceId!,
                        );
                      },
                    ),
                    if (widget.isMultiplePagesList &&
                        widget.eventsList.length >= widget.pageSize)
                      widget.isMoreListLoading
                          ? Padding(
                              padding: EdgeInsets.all(15.h.w),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.all(12.h.w),
                                child: CustomButton(
                                  onPressed: widget.onLoadMoreTap ?? () {},
                                  text: AppLocalizations.of(context)
                                      .digifit_trophies_load_more,
                                  width: 150.w,
                                ),
                              ),
                            ),
                    if (widget.buttonText != null)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 8.h),
                        child: CustomButton(
                          onPressed: widget.onButtonTap,
                          text: widget.buttonText!,
                          icon: widget.buttonIconPath,
                        ),
                      ),
                    15.verticalSpace,
                  ],
                );
    });
  }

  _updateList(bool isFav, int eventId) {
    widget.onSuccess(isFav, eventId);
  }
}
