import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/images_path.dart';

import '../../app_router.dart';
import '../../navigation/navigation.dart';
import '../../offline_router.dart';
import '../../screens/full_image/full_image_screen.dart';
import '../../screens/no_network/network_status_screen_provider.dart';

class DigifitTextImageCard extends ConsumerStatefulWidget {
  final String imageUrl;
  final String heading;
  final String title;
  final String? description;
  final bool isFavorite;
  final bool isFavouriteVisible;
  final VoidCallback? onCardTap;
  final VoidCallback? onFavorite;
  final int sourceId;
  final bool? isCompleted;

  const DigifitTextImageCard({
    Key? key,
    required this.imageUrl,
    required this.heading,
    required this.title,
    this.description,
    required this.isFavouriteVisible,
    required this.isFavorite,
    required this.sourceId,
    this.onCardTap,
    this.onFavorite,
    this.isCompleted,
  }) : super(key: key);

  @override
  ConsumerState<DigifitTextImageCard> createState() => _CommonEventCardState();
}

class _CommonEventCardState extends ConsumerState<DigifitTextImageCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: widget.onCardTap,
      child: Card(
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        elevation: 2,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(5.h.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start, // Add this
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ImageUtil.loadNetworkImage(
                        height: 80.h,
                        width: 80.w,
                        imageUrl: widget.imageUrl,
                        sourceId: widget.sourceId,
                        context: context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          textRegularMontserrat(
                              text: widget.heading,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.color),
                          4.verticalSpace,
                          textSemiBoldMontserrat(
                              text: widget.title,
                              textAlign: TextAlign.start,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                              textOverflow: TextOverflow.visible),
                          4.verticalSpace,
                          Visibility(
                            visible: (widget.description != null),
                            child: textRegularMontserrat(
                                text: widget.description ?? '',
                                color: Theme.of(context)
                                    .textTheme
                                    .labelMedium
                                    ?.color),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Visibility(
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
                  ),
                  10.horizontalSpace,
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Visibility(
                  visible: widget.isCompleted ?? false,
                  child: Container(
                    height: 32.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                        color: Theme.of(context).indicatorColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.r),
                            bottomRight: Radius.circular(10.r))),
                    child: Center(
                      child: SizedBox(
                        child: ImageUtil.loadSvgImage(
                            height: 18.h,
                            width: 18.h,
                            imageUrl: imagePath['digifit_trophy_icon'] ?? '',
                            context: context),
                      ),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
