import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_utility.dart';

class DigifitMapCard extends ConsumerStatefulWidget {
  String imagePath;
  Function() onImageTap;
  int sourceId;

  DigifitMapCard(
      {super.key,
      required this.imagePath,
      required this.onImageTap,
      required this.sourceId});

  @override
  ConsumerState<DigifitMapCard> createState() =>
      _DigifitStatusWidgetState();
}

class _DigifitStatusWidgetState extends ConsumerState<DigifitMapCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: widget.onImageTap,
        child: Card(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: ImageUtil.loadNetworkImage(
                imageUrl: widget.imagePath,
                sourceId: widget.sourceId,
                context: context,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
