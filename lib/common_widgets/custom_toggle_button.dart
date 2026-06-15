import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomToggleButton extends ConsumerStatefulWidget {
  final bool selected;
  final Function(bool) onValueChange;

  const CustomToggleButton(
      {super.key, required this.selected, required this.onValueChange});

  @override
  ConsumerState<CustomToggleButton> createState() => _customToggleButtonState();
}

class _customToggleButtonState extends ConsumerState<CustomToggleButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onValueChange(!widget.selected);
      },
      child: Container(
        width: 46.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
          border: widget.selected ? Border.all(width: 2, color: Theme.of(context).indicatorColor) : Border.all(width: 2, color: Theme.of(context).primaryColor),
          color: widget.selected
              ? Theme.of(context).indicatorColor
              : Theme.of(context).colorScheme.onPrimary,
        ),
        child: Stack(
          alignment: widget.selected
              ? Alignment.topRight
              : AlignmentDirectional.topStart,
          children: [customCircle(widget.selected)],
        ),
      ),
    );
  }

  Widget customCircle(bool isSelected) {
    return Padding(
      padding: EdgeInsets.all(2.h.w),
      child: Container(
        width: 20.w,
        height: 20.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
