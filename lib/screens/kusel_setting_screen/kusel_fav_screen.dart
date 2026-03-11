import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/navigation/navigation.dart';

import '../../app_router.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/image_utility.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../l10n/app_localizations.dart';

class KuselFavScreen extends ConsumerStatefulWidget {
  const KuselFavScreen({super.key});

  @override
  ConsumerState<KuselFavScreen> createState() => _KuselFavScreenState();
}

class _KuselFavScreenState extends ConsumerState<KuselFavScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    return Column(
      children: [
        CommonBackgroundClipperWidget(
          clipperType: UpstreamWaveClipper(),
          imageUrl: imagePath['background_image'] ?? "",
          headingText: AppLocalizations.of(context).my_fav,
          height: 130.h,
          blurredBackground: true,
          isBackArrowEnabled: true,
          isStaticImage: true,
        ),
        16.verticalSpace,
       Padding(padding: EdgeInsets.symmetric(horizontal: 16.w),
       child: _buildTileList(context),)
      ],
    );
  }

  _buildCommonArrowTile(
      {required BuildContext context,
      required Function() onTap,
      required String title,
      required bool hasTopRadius,
      required bool hasBottomRadius,
      required double borderRadius,
      bool showBottomBorder=true}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft:
                    hasTopRadius ? Radius.circular(borderRadius) : Radius.zero,
                topRight:
                    hasTopRadius ? Radius.circular(borderRadius) : Radius.zero,
                bottomLeft: hasBottomRadius
                    ? Radius.circular(borderRadius)
                    : Radius.zero,
                bottomRight: hasBottomRadius
                    ? Radius.circular(borderRadius)
                    : Radius.zero),
            border: showBottomBorder?Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor)):null),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            textSemiBoldMontserrat(
                text: title,
                color: Theme.of(context).textTheme.displayMedium!.color,
                fontSize: 14),
            SizedBox(
              height: 20.h,
              width: 20.w,
              child: ImageUtil.loadLocalSvgImage(
                  imageUrl: 'forward_arrow', context: context),
            )
          ],
        ),
      ),
    );
  }

  _buildTileList(BuildContext context) {
    final borderRadius = 10.r;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Theme.of(context).canvasColor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommonArrowTile(
              context: context,
              onTap: (){
                ref.read(navigationProvider).navigateUsingPath(path: favoritesListScreenPath, context: context);
              },
              title: AppLocalizations.of(context).favorites,
              hasTopRadius: true,
              hasBottomRadius: false,
              borderRadius: borderRadius),

          _buildCommonArrowTile(
              context: context,
              onTap: (){
                ref.read(navigationProvider).navigateUsingPath(path: favouriteCityScreenPath, context: context);

              },
              title: AppLocalizations.of(context).favourite_places,
              hasTopRadius: false,
              hasBottomRadius: false,
              borderRadius: borderRadius),

          _buildCommonArrowTile(
              context: context,
              onTap: (){
                ref.read(navigationProvider).navigateUsingPath(
                    context: context, path: digifitFavScreenPath);
              },
              title: AppLocalizations.of(context).digifit,
              hasTopRadius: false,
              hasBottomRadius: true,
              showBottomBorder: false,
              borderRadius: borderRadius)
        ],
      ),
    );
  }
}
