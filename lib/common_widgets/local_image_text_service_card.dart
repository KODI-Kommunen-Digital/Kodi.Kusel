import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/text_styles.dart';

import '../images_path.dart';
import 'image_utility.dart';

class LocalSvgImageTextServiceCard extends StatefulWidget {
  final Function() onTap;
  final String imageUrl;
  final String text;
  final double? imageHeight;
  final double? imageWidth;
  final String? description;

  const LocalSvgImageTextServiceCard(
      {super.key,
      required this.onTap,
      required this.imageUrl,
      required this.text,
        this.imageWidth,
        this.imageHeight,
      this.description});

  @override
  State<LocalSvgImageTextServiceCard> createState() =>
      _LocalSvgImageTextServiceCardState();
}

class _LocalSvgImageTextServiceCardState
    extends State<LocalSvgImageTextServiceCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 8.w),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding:
                EdgeInsets.only(left: 2.w, right: 14.w, top: 10.h, bottom: 10.h),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(15.r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Row(
                 children: [
                   SizedBox(
                     height: 55.h,
                     width: 55.w,
                     child: ImageUtil.loadLocalSvgImage(
                       height: widget.imageHeight,
                         width: widget.imageWidth,
                         imageUrl: widget.imageUrl, context: context),
                   ),
                   10.horizontalSpace,
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       textBoldMontserrat(
                           text: widget.text,
                           color: Theme.of(context).textTheme.bodyLarge?.color),
                       if (widget.description != null)
                         textRegularMontserrat(
                             text: widget.description ?? '',
                             fontSize: 11,
                             maxLines: 5,
                             textOverflow: TextOverflow.ellipsis,
                             textAlign: TextAlign.start)
                     ],
                   ),
                 ],
               ),
                SizedBox(
                  height: 40.h,
                    width: 45.w,
                    child: ImageUtil.loadLocalAssetImage(
                        imageUrl: 'link_icon', context: context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
