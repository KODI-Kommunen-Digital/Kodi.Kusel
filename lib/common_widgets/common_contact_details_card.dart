import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/utility/url_launcher_utility.dart';

class CommonContactDetailsCard extends ConsumerStatefulWidget {
  final String heading;
  final String phoneNumber;
  final String email;
  final VoidCallback onTap;

  const CommonContactDetailsCard({
    super.key,
    required this.heading,
    required this.phoneNumber,
    required this.email,
    required this.onTap,
  });

  @override
  ConsumerState<CommonContactDetailsCard> createState() =>
      _CommonContactDetailsCardState();
}

class _CommonContactDetailsCardState
    extends ConsumerState<CommonContactDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: EdgeInsets.only(
              left: 20.w, right: 14.w, top: 22.h, bottom: 22.h),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textBoldMontserrat(
                text: widget.heading,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              15.verticalSpace,
              GestureDetector(
                onTap: () =>
                    UrlLauncherUtil.launchDialer(phoneNumber: widget.phoneNumber),                child: Row(
                  children: [
                    Icon(
                      Icons.call_outlined,
                      size: 14.h.w,
                      color: Theme.of(context).primaryColor,
                    ),
                    20.horizontalSpace,
                    textBoldMontserrat(
                      text: widget.phoneNumber,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ],
                ),
              ),
              14.verticalSpace,
              GestureDetector(
                onTap: () =>
                    UrlLauncherUtil.launchEmail(emailAddress: widget.email),                child: Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 16.h.w,
                      color: Theme.of(context).primaryColor,
                    ),
                    20.horizontalSpace,
                    textBoldMontserrat(
                      text: widget.email,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
