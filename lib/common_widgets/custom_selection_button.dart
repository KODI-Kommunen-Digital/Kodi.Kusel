import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';

import '../theme_manager/colors.dart';

class CustomSelectionButton extends ConsumerStatefulWidget {
  final String text;
  final bool isSelected;
  final Function() onTap;

  const CustomSelectionButton(
      {super.key, required this.text, required this.isSelected, required this.onTap});

  @override
  ConsumerState<CustomSelectionButton> createState() =>
      _CustomSelectionButtonState();
}

class _CustomSelectionButtonState extends ConsumerState<CustomSelectionButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal :12.w, vertical: 10.h),
        decoration: BoxDecoration(
            color: widget.isSelected
                ? Theme.of(context).indicatorColor
                : Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(50.r)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            textSemiBoldMontserrat(
                text: widget.text,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: widget.isSelected
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).textTheme.labelMedium?.color),
            10.horizontalSpace,
            widget.isSelected ? Icon(Icons.check_outlined, color: smallIconColor, size: 15.h.w,) : Container()
          ],
        ),
      ),
    );
  }
}
