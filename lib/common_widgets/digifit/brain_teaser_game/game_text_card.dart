import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app_router.dart';
import '../../../images_path.dart';
import '../../../navigation/navigation.dart';
import '../../../screens/full_image/full_image_screen.dart';
import '../../device_helper.dart';
import '../../image_utility.dart';
import '../../text_styles.dart';

class GameTeaserTextCard extends ConsumerStatefulWidget {
  final String imageUrl;
  final String name;
  final String subDescription;
  final int sourceId;
  final bool? backButton;
  final VoidCallback? onCardTap;
  final bool isCompleted;
  final bool? playIcon;
  final bool chooseLevel;
  final bool? isUnlocked;

  const GameTeaserTextCard(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.subDescription,
      required this.sourceId,
      this.backButton,
      this.onCardTap,
      this.playIcon,
      required this.isCompleted,
      required this.chooseLevel,
      this.isUnlocked});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommonEventCardState();
}

class _CommonEventCardState extends ConsumerState<GameTeaserTextCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: (widget.isUnlocked ?? true) ? widget.onCardTap : null,
      child: Transform.translate(
        offset: Offset(0, -2.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(children: [
            Padding(
              padding: EdgeInsets.all(8.h.w),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: (widget.isUnlocked ?? true)
                        ? ImageUtil.loadNetworkImage(
                            height: 75.h,
                            width: 80.w,
                            imageUrl: widget.imageUrl,
                            sourceId: widget.sourceId,
                            context: context,
                          )
                        : ImageUtil.loadAssetImage(
                            height: 75.h,
                            width: 80.w,
                            imageUrl: imagePath["unlock_stamp_image"] ?? '',
                            context: context,
                          ),
                  ),
                  8.horizontalSpace,
                  Visibility(
                    visible: true,
                    child: widget.chooseLevel
                        ? _chooseLevelContent()
                        : _chooseOtherContent(),
                  ),
                  Visibility(
                    visible: widget.backButton ?? false,
                    child: Icon(
                      size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                      Icons.arrow_forward,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Visibility(
                    visible: widget.playIcon ?? false,
                    child: Icon(
                      size: DeviceHelper.isMobile(context) ? 20.h.w : 12.h.w,
                      Icons.play_circle_outline,
                      color: (widget.isUnlocked == true)
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.titleSmall?.color,
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
                  visible: widget.isCompleted,
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
          ]),
        ),
      ),
    );
  }

  _chooseLevelContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textSemiBoldMontserrat(
            text: widget.name,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          4.verticalSpace,
          textSemiBoldMontserrat(
            text: widget.subDescription,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.start,
            fontSize: 14,
            color: Theme.of(context).textTheme.labelMedium?.color,
            textOverflow: TextOverflow.visible,
          ),
          4.verticalSpace,
        ],
      ),
    );
  }

  _chooseOtherContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textSemiBoldMontserrat(
            fontWeight: FontWeight.w500,
            text: widget.subDescription,
            textAlign: TextAlign.start,
            color: (widget.isUnlocked == true)
                ? Theme.of(context).textTheme.labelMedium?.color
                : Theme.of(context).textTheme.titleSmall?.color,
            fontSize: 14,
            textOverflow: TextOverflow.visible,
          ),
          4.verticalSpace,
          textSemiBoldMontserrat(
            text: widget.name,
            fontWeight: FontWeight.w600,
            color: (widget.isUnlocked == true)
                ? Theme.of(context).textTheme.bodyLarge?.color
                : Theme.of(context).textTheme.titleSmall?.color,
            fontSize: 16,
          ),
          4.verticalSpace,
        ],
      ),
    );
  }
}
