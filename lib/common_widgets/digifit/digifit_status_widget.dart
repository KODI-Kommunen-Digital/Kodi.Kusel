import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/images_path.dart';

class DigifitStatusWidget extends ConsumerStatefulWidget {
  int? pointsValue;
  String? pointsText;
  int? trophiesValue;
  String? trophiesText;
  Function() onButtonTap;

  DigifitStatusWidget(
      {super.key,
      required this.pointsValue,
      required this.pointsText,
      required this.trophiesValue,
      required this.trophiesText,
      required this.onButtonTap});

  @override
  ConsumerState<DigifitStatusWidget> createState() =>
      _DigifitStatusWidgetState();
}

class _DigifitStatusWidgetState extends ConsumerState<DigifitStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: _statusIndicatorCard(
                          widget.pointsValue, widget.pointsText)),
                  14.horizontalSpace,
                  Expanded(
                      child: _statusIndicatorCard(
                          widget.trophiesValue, widget.trophiesText)),
                ],
              ),
              15.verticalSpace,
              CustomButton(
                  iconHeight: 15.h,
                  iconWidth: 15.w,
                  icon: imagePath['scan_icon'],
                  onPressed: widget.onButtonTap,
                  text: AppLocalizations.of(context).scan_exercise),
              8.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  _statusIndicatorCard(int? value, String? text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(13.r)),
      child: Column(
        children: [
          textSemiBoldPoppins(text: value.toString(), fontSize: 58),
          textSemiBoldMontserrat(
              text: text ?? '_',
              color: Theme.of(context).textTheme.labelMedium?.color,
              fontWeight: FontWeight.w600,
              fontSize: 16)
        ],
      ),
    );
  }
}
