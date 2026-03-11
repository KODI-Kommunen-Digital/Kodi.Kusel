import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/location_const.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_router.dart';
import '../../../common_widgets/map_widget/custom_flutter_map.dart';
import '../../../common_widgets/text_styles.dart';
import '../../../common_widgets/web_view_page.dart';
import '../../../images_path.dart';
import '../../../navigation/navigation.dart';
import '../../../utility/kusel_date_utils.dart';
import '../../../utility/url_launcher_utility.dart';

class CityDetailLocationWidget extends ConsumerStatefulWidget {
  String webUrl;
  String phoneNumber;
  String address;
  double? lat;
  double? long;
  String websiteText;
  String calendarText;

  CityDetailLocationWidget(
      {super.key,
      required this.phoneNumber,
      required this.webUrl,
      required this.address,
      this.long,
      this.lat,
      required this.websiteText,
      required this.calendarText});

  @override
  ConsumerState<CityDetailLocationWidget> createState() =>
      _CityDetailLocationWidgetState();
}

class _CityDetailLocationWidgetState
    extends ConsumerState<CityDetailLocationWidget> {
  @override
  Widget build(BuildContext context) {
    final formattedCalendarText = KuselDateUtils.formatTime(widget.calendarText);

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r)),
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
          CityDetailMapContainer(
            lat: widget.lat ?? EventLatLong.kusel.latitude,
            long: widget.long ?? EventLatLong.kusel.longitude,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Row(
              children: [
                ImageUtil.loadSvgImage(
                    imageUrl: imagePath['calendar_icon'] ?? '',
                    context: context),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.only(top: 12.h),
                        child: textBoldMontserrat(
                          text: AppLocalizations.of(context).open,
                          textOverflow: TextOverflow.ellipsis,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    textRegularPoppins(
                      text:
                          "${AppLocalizations.of(context).closes_at} $formattedCalendarText ${AppLocalizations.of(context).clock}",
                      textAlign: TextAlign.start,
                      maxLines: 3,
                      textOverflow: TextOverflow.ellipsis,
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 4.0, bottom: 8.0, left: 16, right: 16),
            child: GestureDetector(
              onTap: () {
                UrlLauncherUtil.launchDialer(phoneNumber: widget.phoneNumber);
              },
              child: Row(
                children: [
                  Image.asset(
                    imagePath['phone'] ?? '',
                    width: 18.w,
                    height: 18.h,
                  ),
                  8.horizontalSpace,
                  textRegularPoppins(
                    text: widget.phoneNumber,
                    textOverflow: TextOverflow.ellipsis,
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 8.0, bottom: 12.0, left: 16, right: 16),
            child: GestureDetector(
              onTap: () => ref.read(navigationProvider).navigateUsingPath(
                  path: webViewPagePath,
                  params: WebViewParams(url: widget.webUrl),
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
                    decoration: TextDecoration.underline,
                    textOverflow: TextOverflow.ellipsis,
                    color: Theme.of(context).textTheme.labelMedium?.color,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CityDetailMapContainer extends StatelessWidget {
  final double lat;
  final double long;

  const CityDetailMapContainer(
      {required this.lat, required this.long, super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFlutterMap(
      latitude: lat,
      longitude: long,
      height: 150.h,
      width: MediaQuery.of(context).size.width,
      initialZoom: 13,
      markersList: [
        Marker(
          width: 35.w,
          height: 35.h,
          point: LatLng(lat, long),
          child: Icon(
            Icons.location_pin,
            color: Theme.of(context).colorScheme.onTertiaryFixed,
          ),
        ),
      ],
      onMapTap: () => UrlLauncherUtil.launchMap(latitude: lat, longitude: long),
    );
  }
}
