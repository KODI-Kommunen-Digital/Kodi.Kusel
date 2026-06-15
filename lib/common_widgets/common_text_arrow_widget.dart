import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';

import 'image_utility.dart';

class CommonTextArrowWidget extends StatelessWidget {
  String text;
  void Function()? onTap;
  final double? fontSize;

  CommonTextArrowWidget({super.key, required this.text, this.onTap, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return _buildTextArrowWidget(context: context, text: text, onTap: onTap);
  }

  _buildTextArrowWidget(
      {required BuildContext context,
      void Function()? onTap,
      required String text}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          textRegularPoppins(
              text: text,
              fontSize: fontSize ?? 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color),
          12.horizontalSpace,
          GestureDetector(
            onTap: onTap,
            child: ImageUtil.loadLocalSvgImage(
              imageUrl: 'arrow_icon',
              height: 10.h,
              width: 16.w,
              context: context,
            ),
          )
        ],
      ),
    );
  }
}
