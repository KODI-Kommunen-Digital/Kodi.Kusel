import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArrowBackWidget extends ConsumerStatefulWidget {
  final double? circularRadius;
  final double? size;
  final void Function() onTap;

  const ArrowBackWidget(
      {super.key, this.circularRadius, this.size, required this.onTap});

  @override
  ConsumerState<ArrowBackWidget> createState() => _ArrowBackWidgetState();
}

class _ArrowBackWidgetState extends ConsumerState<ArrowBackWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:widget.onTap,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(widget.circularRadius ?? 50.r),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: widget.size?.w ?? 15.w,
          ),
        ),
      ),
    );
  }
}
