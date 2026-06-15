import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/utility/url_launcher_utility.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonPhoneNumberCard extends ConsumerStatefulWidget {
  final String phoneNumber;
  final bool? isStrikeThrough;

  const CommonPhoneNumberCard({
    super.key,
    required this.phoneNumber,
    this.isStrikeThrough
  });

  @override
  ConsumerState<CommonPhoneNumberCard> createState() =>
      _CommonPhoneNumberCardState();
}

class _CommonPhoneNumberCardState extends ConsumerState<CommonPhoneNumberCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        onTap: () =>
            UrlLauncherUtil.launchDialer(phoneNumber: widget.phoneNumber),
        child: Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 14.w,
            top: 22.h,
            bottom: 22.h,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.call_outlined,
                size: 25.w,
                color: Theme.of(context).primaryColor,
              ),
              30.horizontalSpace,
              textBoldMontserrat(
                text: widget.phoneNumber,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                  decoration: (widget.isStrikeThrough != null &&
                          widget.isStrikeThrough!)
                      ? TextDecoration.underline
                      : null),
            ],
          ),
        ),
      ),
    );
  }
}