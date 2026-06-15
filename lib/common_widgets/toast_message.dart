import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import "package:motion_toast/motion_toast.dart";

showSuccessToast(
    {required String message,
    required BuildContext context,
    Alignment? snackBarAlignment,
    void Function()? onCLose}) {
  MotionToast(
    onClose: onCLose,
    primaryColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: .3),
    description: textRegularPoppins(
        text: message,
        color: Theme.of(context).textTheme.labelSmall?.color,
        textAlign: TextAlign.start,
        maxLines: 2),
    toastAlignment: snackBarAlignment ?? Alignment.bottomCenter,
    displayBorder: true,
    displaySideBar: false,
    icon: Icons.done,
    secondaryColor: Colors.white,
    width: 350.w,
    height: 100.h,
    margin: EdgeInsets.only(
      bottom: 50.h,
    ),
  ).show(context);
}

showErrorToast(
    {required String message,
    required BuildContext context,
    Alignment? snackBarAlignment}) {
  MotionToast(
    primaryColor: Theme.of(context).colorScheme.onError.withValues(alpha: .3),
    description: textRegularPoppins(
        text: message,
        color: Theme.of(context).textTheme.labelSmall?.color,
        maxLines: 4,
        textOverflow: TextOverflow.visible,
        textAlign: TextAlign.start),
    toastAlignment: snackBarAlignment ?? Alignment.bottomCenter,
    displayBorder: true,
    displaySideBar: false,
    icon: Icons.error,
    secondaryColor: Colors.white,
    width: 350.w,
    height: 100.h,
    margin: EdgeInsets.only(
      top: 30.h,
    ),
  ).show(context);
}
