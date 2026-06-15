import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/text_styles.dart';

import '../app_router.dart';
import '../navigation/navigation.dart';
import '../screens/full_image/full_image_screen.dart';
import '../utility/image_loader_utility.dart';
import 'image_utility.dart';

class ImageTextCardWidget extends ConsumerStatefulWidget {
  final String? text;
  final String? imageUrl;
  final int? sourceId;
  final Function()? onTap;
  final bool? isFavourite;
  final bool? isFavouriteVisible;
  final Function()? onFavoriteTap;

  const ImageTextCardWidget(
      {super.key,
      required this.text,
      required this.imageUrl,
      this.sourceId,
      this.onTap,
      required this.isFavourite,
      required this.isFavouriteVisible,
      required this.onFavoriteTap});

  @override
  ConsumerState<ImageTextCardWidget> createState() =>
      _ImageTextCardWidgetState();
}

class _ImageTextCardWidgetState extends ConsumerState<ImageTextCardWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildImageTextCard(
        text: widget.text,
        imageUrl: widget.imageUrl,
        onTap: widget.onTap,
        isFavourite: widget.isFavourite,
        isFavouriteVisible: widget.isFavouriteVisible,
        onFavoriteTap: widget.onFavoriteTap);
  }

  _buildImageTextCard(
      {String? text,
      String? imageUrl,
      int? sourceId,
      Function()? onTap,
      bool? isFavourite,
      bool? isFavouriteVisible,
      Function()? onFavoriteTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(8.h.w),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50.h,
                  width: 50.w,
                  child: ImageUtil.loadNetworkImage(
                      // onImageTap: () {
                      //   ref.read(navigationProvider).navigateUsingPath(
                      //       path: fullImageScreenPath,
                      //       params: FullImageScreenParams(
                      //         imageUrL: imageLoaderUtility(
                      //             image: imageUrl ?? '', sourceId: 1),
                      //         sourceId: sourceId,
                      //       ),
                      //       context: context);
                      // },
                      fit: BoxFit.fill,
                      imageUrl: imageLoaderUtility(
                          image: imageUrl ?? '', sourceId: 1),
                      sourceId: sourceId,
                      context: context),
                ),
              ),
              Expanded(
                  flex: 7,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: textRegularMontserrat(
                        textAlign: TextAlign.start,
                        text: text ?? '',
                        fontWeight: FontWeight.w600,
                        textOverflow: TextOverflow.visible,
                        fontSize: 14),
                  )),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Visibility(
                    visible: isFavouriteVisible ?? false,
                    child: IconButton(
                      onPressed: onFavoriteTap,
                      icon: Icon(
                        size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                        (isFavourite ?? false)
                            ? Icons.favorite_sharp
                            : Icons.favorite_border,
                        color: !widget.isFavourite!
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).colorScheme.onTertiaryFixed,
                      ),
                    ),
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
