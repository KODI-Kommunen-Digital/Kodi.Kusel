import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:kusel/theme_manager/colors.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerWidget extends ConsumerStatefulWidget {
  final double? width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomShimmerWidget.rectangular({
    super.key,
    this.width,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(),
  });

  const CustomShimmerWidget.circular(
      {super.key,
      required this.width,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  ConsumerState<CustomShimmerWidget> createState() =>
      _CustomShimmerWidgetState();
}

class _CustomShimmerWidgetState extends ConsumerState<CustomShimmerWidget> {
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
      baseColor: Theme.of(context).highlightColor,
      highlightColor: Theme.of(context).highlightColor.withAlpha(10),
      period: Duration(milliseconds: 500),
      child: Container(
        width: widget.width ?? double.infinity,
        height: widget.height,
        decoration: ShapeDecoration(
            shape: widget.shapeBorder, color: Theme.of(context).highlightColor),
      ));
}
