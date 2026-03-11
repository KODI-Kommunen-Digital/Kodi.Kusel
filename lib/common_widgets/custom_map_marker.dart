import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'category_icon.dart';
import 'image_utility.dart';

class CustomMapMarker extends StatefulWidget {
  final int? categoryId;
  const CustomMapMarker({super.key, required this.categoryId});

  @override
  State<CustomMapMarker> createState() => _CustomMapMarkerState();
}

class _CustomMapMarkerState extends State<CustomMapMarker> {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      shape: CircleBorder(
        side: BorderSide(color: Theme.of(context).colorScheme.primary)
      ),
      color: Theme.of(context)
          .textTheme.labelMedium?.color,
      child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 10.w, vertical: 10.h),
          child: ImageUtil.loadLocalSvgImage(
            imageUrl: getCategoryIconPath(widget.categoryId ?? 0),
            context: context,
            color: Theme.of(context).canvasColor
          )),
    );
  }
}
