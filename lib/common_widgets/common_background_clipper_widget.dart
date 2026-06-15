import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/full_image/full_image_screen.dart';
import '../images_path.dart';
import '../navigation/navigation.dart';
import 'arrow_back_widget.dart';

class CommonBackgroundClipperWidget extends ConsumerStatefulWidget {
  final bool? isLoading;
  final CustomClipper<Path>? clipperType;
  final String imageUrl;
  final bool isStaticImage;
  final bool? isBackArrowEnabled;
  final double? height;
  final int? sourceId;
  final bool? blurredBackground;
  final String? headingText;
  final Widget? customWidget1;
  final Widget? customWidget2;
  final Widget? customWidget3;
  final Widget? filterWidget;
  final BoxFit? imageFit;
  final double? headingTextLeftMargin;
  final Function()? onBackPress;

  const CommonBackgroundClipperWidget(
      {super.key,
      required this.clipperType,
      required this.imageUrl,
      required this.isStaticImage,
      this.isBackArrowEnabled,
      this.sourceId,
      this.blurredBackground,
      this.customWidget1,
      this.customWidget2,
      this.customWidget3,
      this.headingText,
      this.height,
      this.isLoading,
      this.filterWidget,
      this.imageFit,
      this.headingTextLeftMargin,
      this.onBackPress
      });

  @override
  ConsumerState<CommonBackgroundClipperWidget> createState() =>
      _CommonBackgroundClipperWidgetState();
}

class _CommonBackgroundClipperWidgetState
    extends ConsumerState<CommonBackgroundClipperWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (widget.isLoading ?? false)
            ? Container(
                height: widget.height ?? 270.h,
              )
            : Stack(
                children: [
                  ClipPath(
                    clipper: widget.clipperType,
                    child: SizedBox(
                      height: widget.height ?? 270.h,
                      width: double.infinity,
                      child: widget.isStaticImage
                          ? Image.asset(
                              widget.imageUrl,
                              fit: widget.imageFit ?? BoxFit.cover,
                            )
                          : ImageUtil.loadNetworkImage(
                              fit: widget.imageFit ?? BoxFit.cover,
                              imageUrl: widget.imageUrl,
                              context: context,
                              sourceId: widget.sourceId,
                              // onImageTap: (){
                              //   ref.read(navigationProvider).navigateUsingPath(
                              //       path: fullImageScreenPath,
                              //       params: FullImageScreenParams(
                              //           imageUrL: widget.imageUrl,
                              //         sourceId: widget.sourceId
                              //       ),
                              //       context: context);
                              // },
                              svgErrorImagePath:
                                  imagePath['home_screen_background'] ?? '',
                            ),
                    ),
                  ),
                  if (widget.blurredBackground ?? false)
                    Positioned.fill(
                      child: ClipPath(
                        clipper: widget.clipperType,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                          child: Container(
                            color: Theme.of(context)
                                .cardColor
                                .withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
        Positioned(
          top: 30.h,
          left: widget.headingTextLeftMargin?.w,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  if (widget.isBackArrowEnabled ?? false)
                    Expanded(
                      flex: (widget.headingText != null &&
                              widget.filterWidget != null)
                          ? 1
                          : 0,
                      child: ArrowBackWidget(
                        size: 15.h.w,
                        onTap: (widget.onBackPress!=null) ? widget.onBackPress! : () {
                          ref
                              .read(navigationProvider)
                              .removeTopPage(context: context);
                        },
                      ),
                    ),
                  if (widget.headingText != null)
                    Expanded(
                      flex: (widget.isBackArrowEnabled != null &&
                              widget.filterWidget != null)
                          ? 6
                          : (widget.isBackArrowEnabled != null)
                              ? 9
                              : 0,
                      child: textBoldPoppins(
                          color: Theme.of(context).textTheme.labelLarge?.color,
                          fontSize: 20,
                          text: widget.headingText ?? ''),
                    ),
                  if (widget.filterWidget != null)
                    Expanded(
                      flex: 3,
                      child: widget.filterWidget!,
                    )
                ],
              ),
            ),
          ),
        ),
        if (widget.customWidget1 != null) widget.customWidget1!,
        if (widget.customWidget2 != null) widget.customWidget2!,
        if (widget.customWidget3 != null) widget.customWidget3!,
      ],
    );
  }
}
