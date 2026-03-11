import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/common_background_clipper_widget.dart';
import 'package:kusel/common_widgets/custom_shimmer_widget.dart';
import 'package:kusel/common_widgets/downstream_wave_clipper.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/location_const.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/text_to_speech_widget/text_to_speech_controller.dart';
import 'package:kusel/common_widgets/text_to_speech_widget/text_to_speech_widget.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/event/event_detail_screen_controller.dart';
import 'package:kusel/screens/event/event_detail_screen_state.dart';
import 'package:kusel/utility/kusel_date_utils.dart';

import '../../common_widgets/common_bottom_nav_card_.dart';
import '../../common_widgets/common_event_card.dart';
import '../../common_widgets/common_html_widget.dart';
import '../../common_widgets/custom_progress_bar.dart';
import '../../common_widgets/location_card_widget.dart';
import '../../common_widgets/toast_message.dart';
import '../../images_path.dart';
import '../../l10n/app_localizations.dart';
import '../../navigation/navigation.dart';
import '../../providers/favorites_list_notifier.dart';
import '../../utility/url_launcher_utility.dart';
import '../home/home_screen_provider.dart';
import 'package:html/parser.dart' as html_parser;


class EventDetailScreen extends ConsumerStatefulWidget {
  final EventDetailScreenParams eventScreenParams;

  const EventDetailScreen({super.key, required this.eventScreenParams});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventScreenState();
}

class _EventScreenState extends ConsumerState<EventDetailScreen> {
  @override
  void initState() {
    Future.microtask(() {
      final controller = ref.read(
          eventDetailScreenProvider(widget.eventScreenParams.eventId).notifier);

      controller.getEventDetails(widget.eventScreenParams.eventId);
      controller.getRecommendedList(widget.eventScreenParams.categoryId);
    });

    MatomoService.trackEventDetailsScreenViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(eventDetailScreenProvider(widget.eventScreenParams.eventId));
    final isLoading = ref.watch(
        eventDetailScreenProvider(widget.eventScreenParams.eventId)
            .select((state) => state.loading));
    return WillPopScope(
      onWillPop: () async {
        ref.read(textToSpeechControllerProvider.notifier).stop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              final controller = ref.read(
                  eventDetailScreenProvider(widget.eventScreenParams.eventId)
                      .notifier);

              controller.getEventDetails(widget.eventScreenParams.eventId);
              controller.getRecommendedList(widget.eventScreenParams.categoryId);
            },
            child: Stack(
              children: [
                _buildBody(context, state),
                if (isLoading) CustomProgressBar(),
                Positioned(
                    bottom: 16.h,
                    left: 16.w,
                    right: 16.w,
                    child: CommonBottomNavCard(
                      onBackPress: () {
                        ref.read(textToSpeechControllerProvider.notifier).stop();
                        ref
                            .read(navigationProvider)
                            .removeTopPage(context: context);
                      },
                      isFavVisible: true,
                      isFav: state.isFavourite,
                      onFavChange: () {
                        ref
                            .watch(favoritesProvider.notifier)
                            .toggleFavorite(state.eventDetails,
                                success: ({required bool isFavorite}) {
                          state.eventDetails.isFavorite = isFavorite;
                          ref
                              .read(eventDetailScreenProvider(
                                      state.eventDetails.id ?? 0)
                                  .notifier)
                              .toggleFav();
                          ref
                              .read(homeScreenProvider.notifier)
                              .setIsFavoriteHighlight(
                                  isFavorite, state.eventDetails.id);
                          if (widget.eventScreenParams.onFavClick != null) {
                            widget.eventScreenParams.onFavClick!();
                          }
                        }, error: ({required String message}) {
                          showErrorToast(message: message, context: context);
                        });
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, EventDetailScreenState state) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          CommonBackgroundClipperWidget(
              clipperType: DownstreamCurveClipper(),
              imageUrl: state.eventDetails.logo ??
                  'https://t4.ftcdn.net/jpg/03/45/71/65/240_F_345716541_NyJiWZIDd8rLehawiKiHiGWF5UeSvu59.jpg',
              sourceId: state.eventDetails.sourceId,
              isBackArrowEnabled: true,
              onBackPress: (){
                ref.read(textToSpeechControllerProvider.notifier).stop();
                ref
                    .read(navigationProvider)
                    .removeTopPage(context: context);
              },
              imageFit: BoxFit.fill,
              isStaticImage: false),
          _buildEventsUi(state),
          if (state.recommendList.isNotEmpty) _buildRecommendation(context),
          FeedbackCardWidget(
            height: 270.h,
            onTap: () {
              ref.read(navigationProvider).navigateUsingPath(
                  path: feedbackScreenPath, context: context);
            },
            enableTts: true,
          ),
        ],
      ),
    );
  }

  Widget _buildEventsUi(EventDetailScreenState state) {
    final date = formatDateRange(
        state.eventDetails.startDate, state.eventDetails.endDate);

    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // state.loading
          //     ? CustomShimmerWidget.rectangular(
          //         height: 25.h,
          //         shapeBorder: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(20.r)),
          //       )
          //     :
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: textBoldPoppins(
                text: state.eventDetails.title ?? "",
                color: Theme.of(context).textTheme.bodyLarge?.color,
                textOverflow: TextOverflow.visible,
                textAlign: TextAlign.start,
                fontSize: 16),
          ),
          15.verticalSpace,

          LocationCardWidget(
            address: state.eventDetails.address ?? '-',
            websiteText: AppLocalizations.of(context).visit_website,
            websiteUrl: state.eventDetails.website ?? "",
            latitude:
                state.eventDetails.latitude ?? EventLatLong.kusel.latitude,
            longitude:
                state.eventDetails.longitude ?? EventLatLong.kusel.longitude,
            date: date,
          ),
          12.verticalSpace,
          // state.loading
          //     ? _publicTransportShimmerEffect()
          //     :
          _publicTransportCard(
            heading: AppLocalizations.of(context).public_transport_offer,
            description: AppLocalizations.of(context).find_out_how_to,
            onTap: () => UrlLauncherUtil.launchMap(
                latitude: EventLatLong.kusel.latitude,
                longitude: EventLatLong.kusel.longitude),
          ),
          16.verticalSpace,
          // state.loading
          //     ? _eventInfoShimmerEffect()
          //     :
          _eventInfoWidget(
              heading: AppLocalizations.of(context).description,
              subHeading: '',
              description: state.eventDetails.description ?? "",
              state: state)
        ],
      ),
    );
  }

  static String formatDateRange(String? startDate, String? endDate) {
    final hasStart = startDate != null && startDate.isNotEmpty;
    final hasEnd = endDate != null && endDate.isNotEmpty;

    if (!hasStart && !hasEnd) return '-';
    if (hasStart && !hasEnd) return KuselDateUtils.formatDateTime(startDate);
    if (!hasStart && hasEnd) return KuselDateUtils.formatDateTime(endDate);

    // Both exist - check if they are exactly the same
    if (startDate == endDate) {
      return KuselDateUtils.formatDateTime(startDate!);
    }

    // Both exist
    return '${KuselDateUtils.formatDateTime(startDate!)} - ${KuselDateUtils.formatDateTime(endDate!)}';
  }

  Widget _eventInfoWidget(
      {required String heading,
      required String subHeading,
      required String description,
      required EventDetailScreenState state}) {
    final ttsWidgetState = ref.watch(textToSpeechControllerProvider);
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 10.w, top: 10.h, bottom: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              textBoldPoppins(
                  text: heading,
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyLarge?.color),
              SizedBox(width: 20,),
              if(!ttsWidgetState.isPlaying || ttsWidgetState.ttsWidgetId == "event_description_2")
                TextToSpeechButton(
                texts: [heading, convertHtmlToPlainText(description), getExpandedTileSpeechText(state, context)],
                size: TtsButtonSize.medium,
                ttsWidgetId: "event_description_2",
              )
            ],
          ),
          8.verticalSpace,
          // textSemiBoldPoppins(
          //     text: subHeading,
          //     textAlign: TextAlign.start,
          //     fontSize: 12,
          //     textOverflow: TextOverflow.visible,
          //     color: Theme.of(context).textTheme.bodyLarge?.color,
          //     fontWeight: FontWeight.w600),
          //     12.verticalSpace,
          CommonHtmlWidget(
            data: description,
          ),
          Visibility(
              visible: ref
                          .read(eventDetailScreenProvider(
                              state.eventDetails.id ?? 0))
                          .eventDetails
                          .startDate !=
                      null &&
                  ref
                          .read(eventDetailScreenProvider(
                              state.eventDetails.id ?? 0))
                          .eventDetails
                          .endDate !=
                      null,
              child: Align(child: _buildExpandedTile(state)))
        ],
      ),
    );
  }

  Widget _eventInfoShimmerEffect() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        20.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: CustomShimmerWidget.rectangular(
            height: 20.h,
            width: 150.w,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
          ),
        ),
        20.verticalSpace,
        CustomShimmerWidget.rectangular(
          height: 15.h,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        8.verticalSpace,
        CustomShimmerWidget.rectangular(
          height: 15.h,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        20.verticalSpace,
        CustomShimmerWidget.rectangular(
          height: 15.h,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        8.verticalSpace,
        CustomShimmerWidget.rectangular(
          height: 15.h,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        8.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: CustomShimmerWidget.rectangular(
            height: 15.h,
            width: 150.w,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r)),
          ),
        )
      ],
    );
  }

  Widget _publicTransportCard(
      {required String heading,
      required String description,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12.h.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: Row(
            children: [
              ImageUtil.loadSvgImage(
                  imageUrl: imagePath['transport_icon'] ?? '',
                  height: 25.h,
                  width: 25.w,
                  context: context),
              20.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        textBoldPoppins(
                            text: heading,
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodyLarge?.color),
                      ],
                    ),
                    SizedBox(height: 5,),
                    textRegularPoppins(
                        textAlign: TextAlign.left,
                        text: description,
                        fontSize: 11,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                        textOverflow: TextOverflow.visible)
                  ],
                ),
              ),
              ImageUtil.loadSvgImage(
                  imageUrl: imagePath['map_link_icon'] ?? '', context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _publicTransportShimmerEffect() {
    return Row(
      children: [
        CustomShimmerWidget.circular(
            width: 50.w,
            height: 40.h,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r))),
        10.horizontalSpace,
        Column(
          children: [
            CustomShimmerWidget.rectangular(
              height: 15.h,
              width: MediaQuery.of(context).size.width - 110.w,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            ),
            5.verticalSpace,
            CustomShimmerWidget.rectangular(
              height: 15.h,
              width: MediaQuery.of(context).size.width - 110.w,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            ),
            5.verticalSpace,
            CustomShimmerWidget.rectangular(
              height: 15.h,
              width: MediaQuery.of(context).size.width - 110.w,
              shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            )
          ],
        )
      ],
    );
  }

  String getExpandedTileSpeechText(EventDetailScreenState state, BuildContext context) {
    final start = DateTime.tryParse(state.eventDetails.startDate ?? "");
    final end = DateTime.tryParse(state.eventDetails.endDate ?? "");

    if (start == null || end == null) return "";

    List<DateTime> allDates = [];
    DateTime curr = start;

    while (!curr.isAfter(end)) {
      allDates.add(curr);
      curr = curr.add(const Duration(days: 1));
    }

    DateTime now = DateTime.now();

    List<DateTime> upcoming = allDates.where((d) {
      int idx = allDates.indexOf(d);
      if (idx == 0) return false;
      return !d.isBefore(DateTime(now.year, now.month, now.day));
    }).toList();

    if (upcoming.isEmpty) return "";

    final fromText = AppLocalizations.of(context).from;
    final clockText = AppLocalizations.of(context).clock;

    List<String> speechParts = [];

    speechParts.add(AppLocalizations.of(context).next_dates);

    for (var d in upcoming) {
      final dayName = DateFormat('EEEE').format(d);
      final dateText = DateFormat('dd.MM.yyyy').format(d);

      speechParts.add(
          "$dayName $dateText $fromText ${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)} $clockText");
    }

    return speechParts.join(". ");
  }

  Widget _buildExpandedTile(EventDetailScreenState state) {
    final start = DateTime.tryParse(state.eventDetails.startDate ?? "");
    final end = DateTime.tryParse(state.eventDetails.endDate ?? "");

    if (start == null || end == null) {
      return SizedBox.shrink();
    }

    // TODO: Remove this temporary logic for translating weekdays on the frontend.
    // This is only a quick fix for now, which is why it is handled in the FE.

    List<DateTime> allDates = [];
    DateTime curr = start;
    while (!curr.isAfter(end)) {
      allDates.add(curr);
      curr = curr.add(const Duration(days: 1));
    }

    DateTime now = DateTime.now();
    List<DateTime> upcoming = allDates.where((d) {
      int idx = allDates.indexOf(d);
      if (idx == 0) return false;
      return !d.isBefore(DateTime(now.year, now.month, now.day));
    }).toList();

    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return SizedBox.shrink();
    }

    if (upcoming.isEmpty) {
      return SizedBox.shrink();
    }

    final lang = Localizations.localeOf(context).languageCode;

    String localizedWeekDay(DateTime date) {
      String englishDay = DateFormat('EEEE', 'en').format(date);

      const germanMap = {
        'Monday': 'Montag',
        'Tuesday': 'Dienstag',
        'Wednesday': 'Mittwoch',
        'Thursday': 'Donnerstag',
        'Friday': 'Freitag',
        'Saturday': 'Samstag',
        'Sunday': 'Sonntag',
      };

      if (lang == "de") {
        return germanMap[englishDay] ?? englishDay;
      }

      return englishDay;
    }

    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      iconColor: Theme.of(context).primaryColor,
      visualDensity: VisualDensity.compact,
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: EdgeInsets.zero,
      title: Align(
        alignment: Alignment.centerLeft,
        child: textRegularPoppins(
          text: AppLocalizations.of(context).read_more,
          color: Theme.of(context).textTheme.bodyLarge?.color,
          decoration: TextDecoration.underline,
        ),
      ),
      children: [
        textBoldPoppins(
          text: AppLocalizations.of(context).next_dates,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        10.verticalSpace,
        ...upcoming.map((d) {
          final dayName = localizedWeekDay(d);
          final dateText = DateFormat('dd.MM.yyyy').format(d);
          final fromText = AppLocalizations.of(context).from;
          final clockText = AppLocalizations.of(context).clock;

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              children: [
                ImageUtil.loadSvgImage(
                  imageUrl: imagePath['calendar_icon'] ?? '',
                  context: context,
                ),
                8.horizontalSpace,
                textRegularMontserrat(
                  text:
                      "$dayName, $dateText\n$fromText ${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)} $clockText",
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildClipperBackground(EventDetailScreenState state) {
    return CommonBackgroundClipperWidget(
        clipperType: DownstreamCurveClipper(),
        imageUrl: state.eventDetails.logo ??
            'https://t4.ftcdn.net/jpg/03/45/71/65/240_F_345716541_NyJiWZIDd8rLehawiKiHiGWF5UeSvu59.jpg',
        sourceId: state.eventDetails.sourceId,
        isBackArrowEnabled: true,
        isStaticImage: false);
  }

  Widget _buildClipperBackgroundShimmer() {
    return Stack(
      children: [
        ClipPath(
          clipper: DownstreamCurveClipper(),
          child: CustomShimmerWidget.rectangular(height: 270.h),
        ),
      ],
    );
  }

  _buildRecommendation(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final eventDetailController = ref.read(
          eventDetailScreenProvider(widget.eventScreenParams.eventId).notifier);

      final state = ref
          .watch(eventDetailScreenProvider(widget.eventScreenParams.eventId));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: textBoldPoppins(
                text: AppLocalizations.of(context).our_recommendations,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          4.verticalSpace,
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: state.recommendList.map((item) {
              // TODO: Will remove this conditions in future to handle this in more appropriate way.
              final boxFit = (item.categoryId == 1 || item.categoryId == 41)
                  ? BoxFit.cover
                  : BoxFit.fill;
              return CommonEventCard(
                boxFit: boxFit,
                isFavorite: item.isFavorite ?? false,
                imageUrl: item.logo ?? "",
                date: item.startDate ?? "",
                title: item.title ?? "",
                location: item.address ?? "",
                onCardTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                        context: context,
                        path: eventDetailScreenPath,
                        params: EventDetailScreenParams(
                            eventId: item.id ?? 0,
                            categoryId: widget.eventScreenParams.categoryId),
                      );
                },
                isFavouriteVisible: true,
                sourceId: item.sourceId!,
              );
            }).toList(),
          ),
          16.verticalSpace
        ],
      );
    });
  }


  String convertHtmlToPlainText(String htmlText) {
    final document = html_parser.parse(htmlText);
    final parsedString = document.body?.text ?? "";
    return parsedString.trim();
  }


}
