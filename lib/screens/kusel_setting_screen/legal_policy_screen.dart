import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/screens/kusel_setting_screen/kusel_setting_screen_controller.dart';
import 'package:kusel/screens/kusel_setting_screen/poilcy_type.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/common_html_widget.dart';
import '../../common_widgets/device_helper.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';

class LegalPolicyScreen extends ConsumerStatefulWidget {
  LegalPolicyScreenParams legalPolicyScreenParams;

  LegalPolicyScreen({super.key, required this.legalPolicyScreenParams});

  @override
  ConsumerState<LegalPolicyScreen> createState() => _LegalPolicyScreenState();
}

class _LegalPolicyScreenState extends ConsumerState<LegalPolicyScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref
          .read(kuselSettingScreenProvider.notifier)
          .getLegalPolicyData(widget.legalPolicyScreenParams.policyType);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    ).loaderDialog(
        context, ref.watch(kuselSettingScreenProvider).isLegalPolicyLoading);
  }

  _buildBody(BuildContext context) {
    final state = ref.watch(kuselSettingScreenProvider);
    final controller = ref.read(kuselSettingScreenProvider.notifier);

    return SafeArea(
        child: SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          16.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CommonHtmlWidget(
              data: state.legalPolicyData,
            ),
          )
        ],
      ),
    ));
  }

  _buildHeader(BuildContext context) {
    return Stack(
      children: [
        CommonBackgroundClipperWidget(
            clipperType: UpstreamWaveClipper(),
            imageUrl: imagePath['background_image'] ?? "",
            height: 100.h,
            blurredBackground: true,
            isBackArrowEnabled: false,
            isStaticImage: true),
        Positioned(
          top: 30.h,
          left: 16.w,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  ref.read(navigationProvider).removeTopPage(context: context);
                },
                icon: Icon(
                    size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                    Icons.arrow_back,
                    color: Theme.of(context).primaryColor),
              ),
              8.horizontalSpace,
              textSemiBoldPoppins(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  text: widget.legalPolicyScreenParams.title,
                  fontSize: 22),
            ],
          ),
        ),
      ],
    );
  }
}

class LegalPolicyScreenParams {
  String title;

  PolicyType policyType;

  LegalPolicyScreenParams({required this.title, required this.policyType});
}
