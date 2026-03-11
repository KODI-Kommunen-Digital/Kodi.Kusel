import 'package:domain/model/response_model/weather/weather_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/l10n/app_localizations.dart';

class WeatherWidget extends ConsumerStatefulWidget {
  final WeatherResponseModel? weatherResponseModel;

  const WeatherWidget({super.key, required this.weatherResponseModel});

  @override
  ConsumerState<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends ConsumerState<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: 270.h,
      width: width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 15.h,
            left: 0,
            child: Container(
              padding: EdgeInsets.only(left: 50.w, top: 10.h),
              width: 270.w,
              height: 220.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.r),
                      bottomRight: Radius.circular(16.r))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.weatherResponseModel?.forecast?.forecastday?[0].day?.maxtempC ?? ""}\u00B0",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      fontWeight: FontWeight.w500,
                      fontSize: 64,
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  textBoldMontserrat(
                      text: widget.weatherResponseModel?.location?.name ?? ""),
                  SizedBox(
                    height: 28.h,
                    width: (width * .5).w,
                    child: Divider(
                      thickness: 1,
                      color: Theme.of(context).textTheme.labelMedium?.color,
                    ),
                  ),
                  8.verticalSpace,
                  // 3-Day Forecast
                  SizedBox(
                    width: (width * .4).w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DayWeather(
                            day: getDayFromDate(
                                context,
                                widget.weatherResponseModel?.forecast
                                    ?.forecastday?[0].date ??
                                    DateTime.now().toString()),
                            icon: imagePath[getWeatherIcon(widget
                                .weatherResponseModel
                                ?.forecast
                                ?.forecastday?[0]
                                .day
                                ?.condition
                                ?.code ??
                                1000)] ??
                                '',
                            temp:
                            "${widget.weatherResponseModel?.forecast?.forecastday?[0].day?.maxtempC ?? ""}\u00B0"),
                        _DayWeather(
                            day: getDayFromDate(
                                context,
                                widget.weatherResponseModel?.forecast
                                    ?.forecastday?[1].date ??
                                    DateTime.now().toString()),
                            icon: imagePath[getWeatherIcon(widget
                                .weatherResponseModel
                                ?.forecast
                                ?.forecastday?[1]
                                .day
                                ?.condition
                                ?.code ??
                                1000)] ??
                                '',
                            temp:
                            "${widget.weatherResponseModel?.forecast?.forecastday?[1].day?.maxtempC ?? ""}\u00B0"),
                        _DayWeather(
                            day: getDayFromDate(
                                context,
                                widget.weatherResponseModel?.forecast
                                    ?.forecastday?[2].date ??
                                    DateTime.now().toString()),
                            icon: imagePath[getWeatherIcon(widget
                                .weatherResponseModel
                                ?.forecast
                                ?.forecastday?[2]
                                .day
                                ?.condition
                                ?.code ??
                                1000)] ??
                                '',
                            temp:
                            "${widget.weatherResponseModel?.forecast?.forecastday?[2].day?.maxtempC ?? ""}\u00B0"),
                      ],
                    ),
                  ),
                  16.verticalSpace
                ],
              ),
            ),
          ),
          Visibility(
            visible:
            widget.weatherResponseModel?.current?.condition?.code == 1000,
            child: Positioned(
                right: 42.w,
                bottom: 128.h,
                child: SizedBox(
                  width: 169.w,
                  height: 160.h,
                  child: Image.asset(
                    imagePath["sun_weather_image"] ?? "",
                    fit: BoxFit.contain,
                  ),
                )),
          ),
          Positioned(
            right: 6.w,
            bottom: 3.h,
            child: SizedBox(
              width: 143.w,
              height: 166.h,
              child: Image.asset(
                imagePath[getWeatherImageAsset(widget
                    .weatherResponseModel?.current?.condition?.code ??
                    0)] ??
                    "",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getDayFromDate(BuildContext context, String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final AppLocalizations localizations = AppLocalizations.of(context);

    switch (parsedDate.weekday) {
      case DateTime.monday:
        return localizations.monday_text;
      case DateTime.tuesday:
        return localizations.tuesday_text;
      case DateTime.wednesday:
        return localizations.wednesday_text;
      case DateTime.thursday:
        return localizations.thursday_text;
      case DateTime.friday:
        return localizations.friday_text;
      case DateTime.saturday:
        return localizations.saturday_text;
      case DateTime.sunday:
        return localizations.sunday_text;
      default:
        return localizations.monday_text;
    }
  }

  String getWeatherImageAsset(int weatherCode) {
    if (weatherCode == 1000) {
      return 'boldi_new_sunny_image';
    } else if ([1003, 1006, 1009, 1030, 1135, 1147].contains(weatherCode)) {
      return 'spring_image';
    } else if ([
      1063,
      1150,
      1153,
      1180,
      1183,
      1186,
      1189,
      1192,
      1195,
      1201,
      1240,
      1243,
      1246,
      1273,
      1276
    ].contains(weatherCode)) {
      return 'rain_image';
    } else if ([
      1066,
      1069,
      1072,
      1114,
      1117,
      1168,
      1171,
      1204,
      1207,
      1210,
      1213,
      1216,
      1219,
      1222,
      1225,
      1237,
      1249,
      1252,
      1255,
      1258,
      1261,
      1264,
      1279,
      1282
    ].contains(weatherCode)) {
      return 'cold_image';
    } else {
      return 'dino';
    }
  }
}

String getWeatherIcon(int weatherCode) {
  if (weatherCode == 1000) {
    return 'sunny_icon';
  } else if ([1003, 1006, 1009, 1030, 1135, 1147].contains(weatherCode)) {
    return 'partly_cloudy_icon';
  } else if ([
    1063,
    1150,
    1153,
    1180,
    1183,
    1186,
    1189,
    1192,
    1195,
    1201,
    1240,
    1243,
    1246,
    1273,
    1276
  ].contains(weatherCode)) {
    return 'rainy_icon';
  } else if ([
    1066,
    1069,
    1072,
    1114,
    1117,
    1168,
    1171,
    1204,
    1207,
    1210,
    1213,
    1216,
    1219,
    1222,
    1225,
    1237,
    1249,
    1252,
    1255,
    1258,
    1261,
    1264,
    1279,
    1282
  ].contains(weatherCode)) {
    return 'snow_icon';
  } else {
    return 'sunny_icon';
  }
}

class _DayWeather extends StatelessWidget {
  final String day;
  final String icon;
  final String temp;

  const _DayWeather({
    Key? key,
    required this.day,
    required this.icon,
    required this.temp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        textRegularMontserrat(
            text: day, color: Theme.of(context).textTheme.labelMedium?.color),
        6.verticalSpace,
        ImageUtil.loadSvgImage(
            imageUrl: icon, context: context, height: 28, width: 28),
        6.verticalSpace,
        textRegularMontserrat(
            text: temp, color: Theme.of(context).textTheme.labelMedium?.color),
      ],
    );
  }
}