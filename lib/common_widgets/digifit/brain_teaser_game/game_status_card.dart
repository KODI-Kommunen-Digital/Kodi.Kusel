import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../l10n/app_localizations.dart';
import '../../../theme_manager/colors.dart';
import '../../text_styles.dart';

class GameStatusCardWidget extends ConsumerWidget {
  bool isStatus;
  String description;

  GameStatusCardWidget(
      {super.key, required this.isStatus, required this.description});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w, left: 18.w),
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isStatus
                ? lightThemeHighlightGreenColor
                : Theme.of(context).textTheme.labelMedium?.color,
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
          ),
          child: isStatus
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check,
                      color: Theme.of(context).disabledColor,
                      size: 22.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textSemiBoldMontserrat(
                            text: AppLocalizations.of(context)
                                .successful_game_title,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          SizedBox(height: 8.h),
                          textRegularMontserrat(
                            text: description,
                            textAlign: TextAlign.start,
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            textOverflow: TextOverflow.visible,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textSemiBoldMontserrat(
                            text: AppLocalizations.of(context).error_game_title,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          SizedBox(height: 8.h),
                          textRegularMontserrat(
                            text: AppLocalizations.of(context).error_game_des,
                            textAlign: TextAlign.start,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            textOverflow: TextOverflow.visible,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
    );
  }
}
