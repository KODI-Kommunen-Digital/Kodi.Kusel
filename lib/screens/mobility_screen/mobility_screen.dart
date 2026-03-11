import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/feedback_card_widget.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/mobility_screen/mobility_screen_provider.dart';
import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/common_contact_details_card.dart';
import '../../common_widgets/common_more_info_card.dart';
import '../../common_widgets/downstream_wave_clipper.dart';
import '../../common_widgets/network_image_text_service_card.dart';
import '../../common_widgets/web_view_page.dart';
import '../../matomo_api.dart';
import '../../navigation/navigation.dart';

class MobilityScreen extends ConsumerStatefulWidget {
  const MobilityScreen({super.key});

  @override
  ConsumerState<MobilityScreen> createState() => _MobilityScreenState();
}

class _MobilityScreenState extends ConsumerState<MobilityScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(mobilityScreenProvider.notifier).fetchMobilityDetails();
    });
    MatomoService.trackMobilityScreenViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    ).loaderDialog(context, ref.watch(mobilityScreenProvider).isLoading);
  }

  _buildBody() {
    final state = ref.watch(mobilityScreenProvider);
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                CommonBackgroundClipperWidget(
                    clipperType: DownstreamCurveClipper(),
                    imageUrl: state.mobilityData?.imageUrl ??
                        'https://t4.ftcdn.net/jpg/03/45/71/65/240_F_345716541_NyJiWZIDd8rLehawiKiHiGWF5UeSvu59.jpg',
                    isBackArrowEnabled: true,
                    isStaticImage: false),
                _buildMobilityDescription(),
                // _buildReadMoreSection(),
                _buildOffersList(),
                // _buildContactListUi(),
                // _buildContactDetailsList(),
                FeedbackCardWidget(
                    height: 270.h,
                    onTap: () {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: feedbackScreenPath, context: context);
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildMobilityDescription() {
    final state = ref.watch(mobilityScreenProvider);
    return Padding(
      padding: EdgeInsets.all(16.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textBoldPoppins(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              text: state.mobilityData?.title ?? "_",
              fontSize: 20),
          10.verticalSpace,
          textRegularMontserrat(
              textAlign: TextAlign.start,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              text: state.mobilityData?.description ?? "_",
              textOverflow: TextOverflow.visible)
        ],
      ),
    );
  }

  _buildReadMoreSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: Row(
        children: [
          textRegularMontserrat(
              text: AppLocalizations.of(context).read_more, fontSize: 12),
          4.horizontalSpace,
          Icon(Icons.keyboard_arrow_down_sharp)
        ],
      ),
    );
  }

  _buildOffersList() {
    final state = ref.watch(mobilityScreenProvider);
    return Padding(
      padding: EdgeInsets.all(12.h.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: textBoldPoppins(
                text: AppLocalizations.of(context).our_offers,
                textAlign: TextAlign.start,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16),
          ),
          14.verticalSpace,
          if (state.mobilityData != null &&
              state.mobilityData!.servicesOffered!.isNotEmpty)
            ListView.builder(
                itemCount: state.mobilityData?.servicesOffered?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = state.mobilityData?.servicesOffered?[index];
                  return NetworkImageTextServiceCard(
                    onTap: () => ref.read(navigationProvider).navigateUsingPath(
                        path: webViewPagePath,
                        params: WebViewParams(
                            url: item?.linkUrl ??
                                'https://www.landkreis-kusel.de'),
                        context: context),
                    imageUrl: item?.iconUrl ?? '',
                    text: item?.title ?? '_',
                    description: item?.description,
                  );
                })
        ],
      ),
    );
  }

  _buildContactListUi() {
    final state = ref.watch(mobilityScreenProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          5.verticalSpace,
          if (state.mobilityData?.moreInformations?.isNotEmpty == true)
            ListView.builder(
                itemCount: state.mobilityData?.moreInformations?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = state.mobilityData?.moreInformations?[index];
                  return item?.title != AppLocalizations.of(context).mobility_centre
                      ? CommonMoreInfoCard(
                          title: item?.title ?? '_',
                          phoneNumber: item?.phone ?? '_',
                          isStrikeThrough: true,
                          description: item?.description)
                      : null;
                })
        ],
      ),
    );
  }

  _buildContactDetailsList() {
    final state = ref.watch(mobilityScreenProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: textBoldPoppins(
              textAlign: TextAlign.start,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              text: AppLocalizations.of(context).your_contact_persons,
              fontSize: 14,
            ),
          ),
          15.verticalSpace,
          if (state.mobilityData != null &&
              state.mobilityData!.contactDetails!.isNotEmpty)
            ListView.builder(
                itemCount: state.mobilityData?.contactDetails?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = state.mobilityData?.contactDetails?[index];
                  return CommonContactDetailsCard(
                      onTap: () {},
                      heading: item?.title ?? "_",
                      phoneNumber: item?.phone ?? '_',
                      email: item?.email ?? "_");
                }),
          25.verticalSpace
        ],
      ),
    );
  }
}
