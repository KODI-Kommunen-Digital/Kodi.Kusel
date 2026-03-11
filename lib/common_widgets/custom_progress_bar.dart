import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Theme.of(context).cardColor,
        child: Center(
            child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
          ),
          height: 100.h,
          width: 100.w,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        )),
      ),
    );
  }
}
