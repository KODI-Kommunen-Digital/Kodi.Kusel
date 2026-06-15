import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/web_view_page.dart';
import 'package:kusel/utility/kusel_date_utils.dart';
import 'package:latlong2/latlong.dart';

import '../app_router.dart';
import '../images_path.dart';
import '../navigation/navigation.dart';
import '../utility/url_launcher_utility.dart';
import 'custom_shimmer_widget.dart';
import 'image_utility.dart';
import 'map_widget/custom_flutter_map.dart';
import 'package:kusel/l10n/app_localizations.dart';

class TownHallMapWidget extends ConsumerStatefulWidget {
  final String address;
  final String websiteText;
  final String websiteUrl;
  final String phoneNumber;
  final String email;
  final String calendarText;
  final double latitude;
  final double longitude;
  final String openUntil;

  const TownHallMapWidget(
      {super.key,
        required this.address,
        required this.websiteText,
        required this.websiteUrl,
        required this.phoneNumber,
        required this.email,
        required this.latitude,
        required this.calendarText,
        required this.longitude,
        required this.openUntil
      });

  @override
  ConsumerState<TownHallMapWidget> createState() => _LocationCardWidgetState();
}

class _LocationCardWidgetState extends ConsumerState<TownHallMapWidget> {
  @override
  Widget build(BuildContext context) {
    final formattedOpenUntil = KuselDateUtils.formatTime(widget.openUntil);

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ]),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.h.w),
            child: Row(
              children: [
                ImageUtil.loadSvgImage(
                    imageUrl: imagePath['location_card_icon'] ?? '',
                    context: context),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0.w),
                    child: textRegularPoppins(
                      text: widget.address,
                      textAlign: TextAlign.start,
                      textOverflow: TextOverflow.visible,
                      maxLines: 4,
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomFlutterMap(
            latitude: widget.latitude,
            longitude: widget.longitude,
            height: 120.h,
            width: MediaQuery.of(context).size.width,
            initialZoom: 13,
            onMapTap: () => UrlLauncherUtil.launchMap(
                latitude: widget.latitude, longitude: widget.longitude),
            markersList: [
              Marker(
                width: 35.w,
                height: 35.h,
                point: LatLng(widget.latitude, widget.longitude),
                child: Icon(
                  Icons.location_pin,
                  color: Theme.of(context).colorScheme.onTertiaryFixed,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 14.h),
            child: Column(
              children: [
                Row(
                  children: [
                    ImageUtil.loadSvgImage(
                      imageUrl : imagePath['calendar_icon'] ?? '',
                      context: context,
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                    10.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.only(top:12.h),
                            child: textBoldMontserrat(
                              text: widget.calendarText,
                              textOverflow: TextOverflow.ellipsis,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        textRegularPoppins(
                          text:
                              "${AppLocalizations.of(context).closes_at} $formattedOpenUntil ${AppLocalizations.of(context).clock}",
                          textOverflow: TextOverflow.ellipsis,
                          color: Theme.of(context).textTheme.labelMedium?.color,
                        ),
                      ],
                    )
                  ],
                ),
                10.verticalSpace,
                GestureDetector(
                  onTap: () => UrlLauncherUtil.launchDialer(phoneNumber: widget.phoneNumber),
                  child: Row(
                    children: [
                      ImageUtil.loadSvgImage(
                        imageUrl : imagePath['phone_icon'] ?? '',
                        context: context,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),
                      10.horizontalSpace,
                      textRegularPoppins(
                        text: widget.phoneNumber,
                        textOverflow: TextOverflow.ellipsis,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                GestureDetector(
                  onTap: () => UrlLauncherUtil.launchEmail(emailAddress: widget.email),
                  child: Row(
                    children: [
                      ImageUtil.loadSvgImage(
                        imageUrl : imagePath['mail_icon'] ?? '',
                        context: context,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),
                      10.horizontalSpace,
                      textRegularPoppins(
                        text: widget.email,
                        textOverflow: TextOverflow.ellipsis,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),
                    ],
                  ),
                ),
                10.verticalSpace,
                GestureDetector(
                  onTap: () => ref.read(navigationProvider).navigateUsingPath(
                      path: webViewPagePath,
                      params: WebViewParams(url: widget.websiteUrl),
                      context: context),
                  child: Row(
                    children: [
                      ImageUtil.loadSvgImage(
                        imageUrl:
                        imagePath['map_link_icon'] ?? '',
                        context: context,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),
                      10.horizontalSpace,
                      textRegularPoppins(
                        text: widget.websiteText,
                        textOverflow: TextOverflow.ellipsis,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget locationCardShimmerEffect(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      12.verticalSpace,
      CustomShimmerWidget.rectangular(
        height: 20.h,
        shapeBorder:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
      15.verticalSpace,
      CustomShimmerWidget.rectangular(
        height: 106.h,
        shapeBorder:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.r)),
      ),
      12.verticalSpace,
      Align(
        alignment: Alignment.centerLeft,
        child: CustomShimmerWidget.rectangular(
          height: 15.h,
          width: 150.w,
          shapeBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      ),
      10.verticalSpace,
      Align(
        alignment: Alignment.centerLeft,
        child: CustomShimmerWidget.rectangular(
          height: 15.h,
          width: 150.w,
          shapeBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      ),
      16.verticalSpace,
      Align(
        alignment: Alignment.centerLeft,
        child: CustomShimmerWidget.rectangular(
          height: 20.h,
          width: 200.w,
          shapeBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      ),
      20.verticalSpace,
      Row(
        children: [
          CustomShimmerWidget.rectangular(
            height: 25.h,
            width: MediaQuery.of(context).size.width / 2 - 20.w,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
          ),
          5.horizontalSpace,
          CustomShimmerWidget.rectangular(
            height: 25.h,
            width: MediaQuery.of(context).size.width / 2 - 20.w,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
          ),
        ],
      ),
      10.verticalSpace,
    ],
  );
}

