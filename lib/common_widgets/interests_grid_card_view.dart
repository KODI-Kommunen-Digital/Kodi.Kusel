import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';

import '../theme_manager/colors.dart';

class InterestsGridCardView extends ConsumerStatefulWidget {
  final String title;
  final String imageUrl;
  final VoidCallback? onTap;
  final bool isSelected;

  const InterestsGridCardView(
      {Key? key,
      required this.imageUrl,
      required this.title,
      this.onTap,
      required this.isSelected})
      : super(key: key);

  @override
  ConsumerState<InterestsGridCardView> createState() => _CommonEventCardState();
}

class _CommonEventCardState extends ConsumerState<InterestsGridCardView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: widget.isSelected
              ? Theme.of(context).indicatorColor
              : Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          elevation: 1,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 6.h, left: 6.w, right: 6.w),
                height: 85.h,
                width: 160.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: ImageUtil.loadNetworkImage(
                      imageUrl : widget.imageUrl,
                      context: context
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 175.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child:
                        textRegularMontserrat(
                          text: widget.title,
                          fontSize: 12,
                          fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                          textAlign: TextAlign.start,
                          textOverflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          left: 10,
          top: 10,
          child: Visibility(
            visible: widget.isSelected,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                padding: EdgeInsets.all(4.h.w),
                decoration: BoxDecoration(
                    color: Theme.of(context).indicatorColor
                ),
                child: Icon(Icons.check_outlined, color: smallIconColor, size: 11.h.w,),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
