import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/utility/image_loader_utility.dart';
import 'package:kusel/utility/kusel_date_utils.dart';

import '../app_router.dart';
import '../images_path.dart';
import '../navigation/navigation.dart';
import '../screens/event/event_detail_screen_controller.dart';
import '../screens/full_image/full_image_screen.dart';
import 'image_utility.dart';

class EventCardMap extends ConsumerStatefulWidget {
  final String address;
  final String websiteText;
  final String title;
  final String startDate;
  final String logo;
  final int id;
  final int sourceId;
  final Listing event;

  const EventCardMap(
      {super.key,
      required this.address,
      required this.websiteText,
      required this.title,
      required this.startDate,
      required this.logo,
      required this.id,
      required this.sourceId,
      required this.event});

  @override
  ConsumerState<EventCardMap> createState() => _LocationCardWidgetState();
}

class _LocationCardWidgetState extends ConsumerState<EventCardMap> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: GestureDetector(
        onTap: () {
          ref.read(navigationProvider).navigateUsingPath(
              context: context,
              path: eventDetailScreenPath,
              params: EventDetailScreenParams(eventId: widget.event.id??0));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                child: SizedBox(
                  height: 150.h,
                  width: double.infinity,
                  child: ImageUtil.loadNetworkImage(
                      onImageTap: () {
                        ref.read(navigationProvider).navigateUsingPath(
                            path: fullImageScreenPath,
                            params: FullImageScreenParams(
                                imageUrL: widget.logo,
                                sourceId: widget.sourceId),
                            context: context);
                      },
                      height: 75.h,
                      width: 80.w,
                      imageUrl: imageLoaderUtility(
                          image: widget.logo, sourceId: widget.sourceId),
                      context: context),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textSemiBoldMontserrat(
                        fontWeight: FontWeight.w600, text: widget.title),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        ImageUtil.loadSvgImage(
                            imageUrl: imagePath['location_card_icon'] ?? '',
                            context: context),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: textRegularMontserrat(
                              text: widget.address,
                              maxLines: 2,
                              softWrap: true,
                              textAlign: TextAlign.start),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        ImageUtil.loadSvgImage(
                            imageUrl: imagePath['calendar_icon'] ?? '',
                            context: context),
                        SizedBox(width: 8.w),
                        textRegularMontserrat(
                            text: (widget.startDate.isNotEmpty)
                                ? KuselDateUtils.formatDate(widget.startDate)
                                : widget.startDate),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Divider(),
                    Row(
                      children: [
                        iconTextWidget(imagePath['man_icon'] ?? '',
                            AppLocalizations.of(context).barrier_free, context),
                        8.horizontalSpace,
                        iconTextWidget(imagePath['paw_icon'] ?? '',
                            AppLocalizations.of(context).dogs_allow, context),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget iconTextWidget(String imageUrl, String text, BuildContext context) {
  return Container(
    height: 26.h,
    width: 140.w,
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.onSecondary),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageUtil.loadSvgImage(
          imageUrl: imageUrl,
          context: context,
          height: 18.h,
          width: 18.w,
        ),
        6.horizontalSpace,
        Flexible(
            child: textRegularPoppins(text: text, maxLines: 1, softWrap: false))
      ],
    ),
  );
}
