import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kusel/utility/image_loader_utility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../navigation/navigation.dart';

class FullImageScreen extends ConsumerStatefulWidget {
  FullImageScreenParams fullImageScreenParams;

  FullImageScreen({super.key, required this.fullImageScreenParams});

  @override
  ConsumerState<FullImageScreen> createState() => _FullImageScreenState();
}

class _FullImageScreenState extends ConsumerState<FullImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).shadowColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(15.h.w),
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 1,
                maxScale: 5,
                child: CachedNetworkImage(
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  imageUrl: imageLoaderUtility(
                    image: widget.fullImageScreenParams.imageUrL,
                    sourceId: widget.fullImageScreenParams.sourceId ?? 3,
                  ),
                  progressIndicatorBuilder: (context, value, _) {
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorWidget: (context, value, _) {
                    return (widget.fullImageScreenParams.svgErrorImagePath !=
                            null)
                        ? SvgPicture.asset(
                            widget.fullImageScreenParams.svgErrorImagePath!)
                        : const Icon(Icons.broken_image);
                  },
                ),
              ),
            ),
            Positioned(
                top: 15.h,
                left: 15.w,
                child: ArrowBackWidget(
                  onTap: () {
                    ref
                        .read(navigationProvider)
                        .removeTopPage(context: context);
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class FullImageScreenParams {
  final String imageUrL;
  final int? sourceId;
  final String? svgErrorImagePath;

  FullImageScreenParams(
      {required this.imageUrL, this.sourceId, this.svgErrorImagePath});
}
