import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/theme_manager/colors.dart';

import '../images_path.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double? height;
  final double? width;
  final double? iconHeight;
  final double? iconWidth;
  final String? icon;
  final bool isOutLined;
  final Color? buttonColor;
  final Color? textColor;
  final double? textSize;
  final Color? borderColor;
  final bool? searchScreen;

  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.height,
      this.width,
      this.iconHeight,
      this.iconWidth,
      this.icon,
      this.isOutLined = false,
      this.buttonColor,
      this.textColor,
      this.textSize,
      this.borderColor,
      this.searchScreen});

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    return SizedBox(
        width: width ?? MediaQuery.of(context).size.width,
        height: height ?? 36.h,
        child: isOutLined
            ? OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: onPressed,
                child: FittedBox(
                  child: icon != null
                      ? Row(
                          children: [
                            Image.asset(
                              icon ?? "",
                              width: iconWidth,
                              height: iconHeight,
                            ),
                            SizedBox(width: 12),
                            searchScreen == false
                                ? textRegularPoppins(
                                    fontSize: textSize,
                                    color: textColor ??
                                        Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.color,
                                    text: text,
                                  )
                                : textBoldPoppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: textSize,
                                    color: textColor ??
                                        Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.color,
                                    text: text,
                                  )
                          ],
                        )
                      : textRegularPoppins(
                          fontSize: textSize,
                          fontWeight: FontWeight.w600,
                          color: textColor ??
                              Theme.of(context).textTheme.labelSmall?.color,
                          text: text,
                        ),
                ),
              )
            : ElevatedButton(
                onPressed: (onPressed == null)
                    ? null
                    : () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        onPressed!();
                      },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  backgroundColor:
                      WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.disabled)) {
                      return const Color(0x4D283583);
                    }
                    return buttonColor ?? Theme.of(context).primaryColor;
                  }),
                ),
                child: FittedBox(
                  child: icon != null
                      ? Row(
                          children: [
                            Image.asset(
                              icon ?? "",
                              width: iconWidth,
                              height: iconHeight,
                            ),
                            SizedBox(width: 12),
                            textBoldPoppins(
                              fontSize: textSize ?? 14,
                              fontWeight: FontWeight.w600,
                              color: isDisabled
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color
                                  : (textColor ?? Colors.white),
                              text: text,
                            ),
                          ],
                        )
                      : textHeadingMontserrat(
                          fontSize: textSize ?? 14,
                          fontWeight: FontWeight.w600,
                          color: isDisabled
                              ? Theme.of(context).textTheme.titleSmall!.color
                              : (textColor ?? Colors.white),
                          text: text,
                        ),
                ),
              ));
  }
}
