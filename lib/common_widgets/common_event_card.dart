import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_shimmer_widget.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/utility/image_loader_utility.dart';
import 'package:kusel/utility/kusel_date_utils.dart';

class CommonEventCard extends ConsumerStatefulWidget {
  final String imageUrl;
  final String date;
  final String title;
  final String location;
  final bool isFavorite;
  final bool isFavouriteVisible;
  final VoidCallback? onCardTap;
  final VoidCallback? onFavorite;
  final int sourceId;
  final BoxFit? boxFit;

  const CommonEventCard(
      {Key? key,
      required this.imageUrl,
      required this.date,
      required this.title,
      required this.location,
      required this.isFavouriteVisible,
      required this.isFavorite,
      required this.sourceId,
      this.onCardTap,
      this.onFavorite,
      this.boxFit})
      : super(key: key);

  @override
  ConsumerState<CommonEventCard> createState() => _CommonEventCardState();
}

class _CommonEventCardState extends ConsumerState<CommonEventCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: widget.onCardTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageUtil.loadNetworkImage(
                    fit: widget.boxFit ?? BoxFit.fill,
                    memCacheHeight: 400,
                    memCacheWidth: 500,
                    height: 75.h,
                    width: 83.w,
                    imageUrl: imageLoaderUtility(
                        image: widget.imageUrl, sourceId: widget.sourceId),
                    context: context),
              ),
              SizedBox(width: 11.w.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    textRegularMontserrat(
                        text: KuselDateUtils.formatDate(widget.date),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                        textAlign: TextAlign.start),
                    const SizedBox(height: 6),
                    textSemiBoldMontserrat(
                        text: widget.title,
                        textOverflow: TextOverflow.visible,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.start),
                    const SizedBox(height: 4),
                    textRegularMontserrat(
                        text: widget.location,
                        color: Theme.of(context).textTheme.labelMedium?.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        textAlign: TextAlign.start),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              SizedBox(width: 11.w.h),
              Visibility(
                visible: widget.isFavouriteVisible,
                child: IconButton(
                  onPressed: widget.onFavorite,
                  icon: Icon(
                    size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                    widget.isFavorite
                        ? Icons.favorite_sharp
                        : Icons.favorite_border,
                    color: !widget.isFavorite
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).colorScheme.onTertiaryFixed,
                  ),
                ),
              ),
              SizedBox(width: 7.w.h),
            ],
          ),
        ),
      ),
    );
  }
}

Widget eventCartShimmerEffect() {
  return ListTile(
    leading: CustomShimmerWidget.circular(height: 60.h, width: 60.w),
    title: CustomShimmerWidget.rectangular(
      height: 12.h,
    ),
    subtitle: CustomShimmerWidget.rectangular(
      height: 12.h,
    ),
  );
}
