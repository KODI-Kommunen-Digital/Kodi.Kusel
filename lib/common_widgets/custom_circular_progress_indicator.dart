import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCircularProgressIndicator extends ConsumerStatefulWidget {
  const CustomCircularProgressIndicator({super.key});

  @override
  ConsumerState<CustomCircularProgressIndicator> createState() => _CustomCircularProgressIndicatorState();
}

class _CustomCircularProgressIndicatorState extends ConsumerState<CustomCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      width: 140.w,
      child: CircularProgressIndicator(
        color: Color(0xFF6972A8),
      ),
    );
  }
}

