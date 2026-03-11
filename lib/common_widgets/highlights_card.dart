import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/common_html_widget.dart';
import 'package:kusel/common_widgets/custom_shimmer_widget.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/utility/kusel_date_utils.dart';

class HighlightsCard extends ConsumerStatefulWidget {
  final String imageUrl;
  final String? date;
  final String heading;
  final String description;
  final bool isFavourite;
  final VoidCallback onPress;
  final VoidCallback onFavouriteIconClick;
  final bool isFavouriteVisible;
  final String? errorImagePath;
  final int sourceId;
  final double? imageWidth;
  final double? imageHeight;
  final BoxFit? imageFit;
  final double? cardWidth;
  final double? cardHeight;

  const HighlightsCard(
      {super.key,
      required this.sourceId,
      required this.imageUrl,
      this.date,
      required this.heading,
      required this.description,
      required this.isFavourite,
      required this.onPress,
      required this.onFavouriteIconClick,
      required this.isFavouriteVisible,
      this.errorImagePath,
      this.imageFit,
      this.imageHeight,
      this.imageWidth,
      this.cardWidth,
      this.cardHeight});

  @override
  ConsumerState<HighlightsCard> createState() => _HighlightsCardState();
}

class _HighlightsCardState extends ConsumerState<HighlightsCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      borderRadius: BorderRadius.circular(25.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.w),
        child: Container(
          width: widget.cardWidth,
          height: widget.cardHeight,
          padding: EdgeInsets.only(
            top: 10.h,
            bottom: 10.h,
            left: 8.w,
            right: 8.w,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.r),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.14),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: widget.imageHeight ?? 200.h,
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18.r),
                      child: SizedBox(
                        height: widget.imageHeight ?? 200.h,
                        width: widget.imageWidth ?? double.infinity,
                        child: ImageUtil.loadNetworkImage(
                            memCacheHeight: 400,
                            memCacheWidth: 650,
                            imageUrl: widget.imageUrl,
                            fit: widget.imageFit ?? BoxFit.cover,
                            sourceId: widget.sourceId,
                            svgErrorImagePath: widget.errorImagePath,
                            context: context),
                      ),
                    ),
                    if (widget.isFavouriteVisible)
                      Positioned(
                        top: 6.h,
                        right: 8.w,
                        child: InkWell(
                          onTap: widget.onFavouriteIconClick,
                          borderRadius: BorderRadius.circular(50.r),
                          child: Container(
                            padding: EdgeInsets.all(8.r),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              size: 22.h.w,
                              widget.isFavourite
                                  ? Icons.favorite_sharp
                                  : Icons.favorite_border_sharp,
                              color: widget.isFavourite
                                  ? Colors.red
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              10.verticalSpace,
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.h.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      (widget.date != null)
                          ? textSemiBoldMontserrat(
                              color:
                                  Theme.of(context).textTheme.labelMedium?.color,
                              fontWeight: FontWeight.w600,
                              text: KuselDateUtils.formatDate(widget.date ?? ""),
                              fontSize: 12)
                          : SizedBox.shrink(),
                      (widget.date != null) ? 5.verticalSpace : SizedBox.shrink(),
                      textSemiBoldMontserrat(
                          text: widget.heading,
                          textAlign: TextAlign.start,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                          textOverflow: TextOverflow.visible,
                          color: Theme.of(context).textTheme.bodyLarge?.color),
                      3.verticalSpace,
                      textSemiBoldMontserrat(
                          text: stripHtmlTags(widget.description),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.start,
                          color: Theme.of(context).textTheme.labelMedium?.color,
                          maxLines: 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget highlightCardShimmerEffect() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 14.w),
    child: Column(
      children: [
        CustomShimmerWidget.circular(
          height: 350.h,
          width: double.infinity,
          shapeBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        ),
        10.verticalSpace,
        CustomShimmerWidget.rectangular(
            height: 15.h,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r))),
        10.verticalSpace,
        CustomShimmerWidget.rectangular(
            height: 15.h,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r))),
        10.verticalSpace,
        CustomShimmerWidget.rectangular(
            height: 15.h,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r))),
        10.verticalSpace,
        CustomShimmerWidget.rectangular(
            height: 15.h,
            shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r))),
      ],
    ),
  );
}
