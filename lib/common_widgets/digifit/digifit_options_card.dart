import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';

class DigifitOptionsCard extends ConsumerStatefulWidget {
  String? cardText;
  String svgImageUrl;
  Function() onCardTap;

  DigifitOptionsCard(
      {super.key,
      required this.cardText,
      required this.svgImageUrl,
      required this.onCardTap});

  @override
  ConsumerState<DigifitOptionsCard> createState() =>
      _DigifitStatusWidgetState();
}

class _DigifitStatusWidgetState extends ConsumerState<DigifitOptionsCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTap: widget.onCardTap,
        child: Card(
          color: Theme.of(context).canvasColor,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 25.h, horizontal: 15.w),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(6.r)),
                  child: Center(
                    child: ImageUtil.loadSvgImage(
                        imageUrl: widget.svgImageUrl,
                        context: context,
                        height: 40.h,
                        width: 40.w),
                  ),
                ),
                15.verticalSpace,
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: textRegularMontserrat(
                      text: widget.cardText ?? '_',
                      textAlign: TextAlign.start,
                      textOverflow: TextOverflow.visible,
                      color: Theme.of(context).primaryColor),
                ),
                8.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
