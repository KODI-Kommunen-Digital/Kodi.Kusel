import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common_widgets/text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../theme_manager/colors.dart';

class SuccessCardWidget extends ConsumerWidget {
  const SuccessCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: lightThemeHighlightGreenColor,
        border: Border(
          left: BorderSide(color: const Color(0xFF88AF33), width: 1),
          right: BorderSide(color: const Color(0xFF88AF33), width: 1),
          bottom: BorderSide(color: const Color(0xFF88AF33), width: 1),
          top: BorderSide(color: const Color(0xFF88AF33), width: 1),
        ),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check,
            color: Theme.of(context).disabledColor,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textSemiBoldMontserrat(
                  text: AppLocalizations.of(context).digifit_success_card_title,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
                SizedBox(height: 8.h),
                textRegularMontserrat(
                  text: AppLocalizations.of(context).digifit_success_card_desp,
                  textAlign: TextAlign.start,
                  textOverflow: TextOverflow.visible,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
