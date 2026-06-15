import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';

class ExploreGridCardView extends ConsumerStatefulWidget {
  final String title;
  final String imageName;
  final VoidCallback? onTap;

  const ExploreGridCardView({
    Key? key,
    required this.imageName,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  ConsumerState<ExploreGridCardView> createState() => _CommonEventCardState();
}

class _CommonEventCardState extends ConsumerState<ExploreGridCardView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        elevation: 0,
        child: InkWell(
          onTap: widget.onTap,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 6.h, left: 6.w, right: 6.w),
                height: (DeviceHelper.isMobile(context))?85.h:120.h,
                width: 180.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.asset(
                      imagePath[widget.imageName]!,
                    fit: BoxFit.cover,
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
                        child: textRegularMontserrat(
                            text: widget.title, fontSize: 12, textOverflow: TextOverflow.visible),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
