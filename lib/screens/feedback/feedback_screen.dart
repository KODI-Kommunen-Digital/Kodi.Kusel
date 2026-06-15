import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kusel/common_widgets/custom_dropdown.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/common_widgets/web_view_page.dart';
import 'package:kusel/screens/feedback/feedback_screen_provider.dart';
import 'package:kusel/screens/feedback/feedback_screen_state.dart';
import 'package:kusel/utility/url_constants/url_constants.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/device_helper.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/toast_message.dart';
import '../../images_path.dart';
import '../../matomo_api.dart';
import '../../navigation/navigation.dart';
import '../../theme_manager/colors.dart';
import '../auth/validator/empty_field_validator.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  const FeedbackScreen({super.key});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  GlobalKey<FormState> feedbackFormKey = GlobalKey();
  List<String> titleList = [];

  @override
  void initState() {
    MatomoService.trackFeedbackScreenViewed();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (titleList.isEmpty) {
      titleList = [
        AppLocalizations.of(context).infrastructure_and_public_space,
        AppLocalizations.of(context).transportation_and_mobility,
        AppLocalizations.of(context).cleanliness_and_environment,
        AppLocalizations.of(context).digital_services_and_app_functionality,
        AppLocalizations.of(context).disruptions_and_damage,
        AppLocalizations.of(context).citizen_services_and_administration,
        AppLocalizations.of(context).general_feedback,
      ];

      Future.microtask(() {
        ref.read(feedbackScreenProvider.notifier).updateTitle(titleList[0]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateRead = ref.read(feedbackScreenProvider);
    final stateWatch = ref.watch(feedbackScreenProvider);
    final stateNotifier = ref.read(feedbackScreenProvider.notifier);
    final titleEditingController = stateNotifier.titleEditingController;
    final descriptionEditingController =
        stateNotifier.descriptionEditingController;
    final emailEditingController = stateNotifier.emailEditingController;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  CommonBackgroundClipperWidget(
                      clipperType: UpstreamWaveClipper(),
                      imageUrl: imagePath['background_image'] ?? "",
                      height: 130.h,
                      blurredBackground: true,
                      isBackArrowEnabled: false,
                      isStaticImage: true),
                  Positioned(
                    top: 50.h,
                    left: 20.w,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ref
                                .read(navigationProvider)
                                .removeTopPage(context: context);
                          },
                          icon: Icon(
                              size: DeviceHelper.isMobile(context)
                                  ? null
                                  : 12.h.w,
                              color: Theme.of(context).primaryColor,
                              Icons.arrow_back),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                        14.horizontalSpace,
                        textSemiBoldPoppins(
                            fontWeight: FontWeight.w600,
                            text: AppLocalizations.of(context).contact,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 24)
                      ],
                    ),
                  ),
                ],
              ),
              _buildFeedbackUi(
                  titleEditingController,
                  descriptionEditingController,
                  emailEditingController,
                  stateWatch,
                  stateNotifier),
            ],
          ),
        ),
      ),
    ).loaderDialog(context, stateWatch.loading);
  }

  Widget _buildFeedbackUi(
      TextEditingController titleEditingController,
      TextEditingController descriptionEditingController,
      TextEditingController emailEditingController,
      FeedbackScreenState stateWatch,
      FeedbackScreenProvider stateNotifier) {
    return _buildForm(titleEditingController, descriptionEditingController,
        emailEditingController, stateWatch, stateNotifier);
  }

  Widget _buildForm(
      TextEditingController titleEditingController,
      TextEditingController descriptionEditingController,
      TextEditingController emailEditingController,
      FeedbackScreenState stateWatch,
      FeedbackScreenProvider stateNotifier) {
    return Form(
      key: feedbackFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 20.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: textRegularMontserrat(
                      text: AppLocalizations.of(context).regarding,
                      fontSize: 14,
                      color: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .color
                          ?.withOpacity(0.9),
                      fontStyle: FontStyle.italic)),
            ),
            6.verticalSpace,
            CustomDropdown(
                hintText: AppLocalizations.of(context).feedback_about_app,
                items: titleList,
                selectedItem: ref.watch(feedbackScreenProvider).title.isEmpty
                    ? ''
                    : ref.read(feedbackScreenProvider).title,
                onSelected: (value) {
                  ref
                      .read(feedbackScreenProvider.notifier)
                      .updateTitle(value ?? "");
                }),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: textRegularMontserrat(
                      color: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .color
                          ?.withOpacity(0.9),
                      text: AppLocalizations.of(context).email,
                      fontSize: 14,
                      fontStyle: FontStyle.italic)),
            ),
            6.verticalSpace,
            KuselTextField(
              textEditingController: emailEditingController,
              hintText: AppLocalizations.of(context).enter_email,
              enableBorderColor: Theme.of(context).dividerColor,
              validator: (value) {
                return validateField(value,
                    "${AppLocalizations.of(context).email} ${AppLocalizations.of(context).is_required}");
              },
            ),
            16.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: textRegularMontserrat(
                      color: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .color
                          ?.withOpacity(0.9),
                      text: AppLocalizations.of(context).feedback_message,
                      fontSize: 14,
                      fontStyle: FontStyle.italic)),
            ),
            6.verticalSpace,
            KuselTextField(
              enableBorderColor: Theme.of(context).dividerColor,
              textEditingController: descriptionEditingController,
              maxLines: 6,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 24.h, horizontal: 12.w),
              hintText: AppLocalizations.of(context).enter_description,
              inputFormatters: [
                LengthLimitingTextInputFormatter(300),
              ],
              validator: (value) {
                return validateField(value,
                    "${AppLocalizations.of(context).description} ${AppLocalizations.of(context).is_required}");
              },
            ),
            6.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: textRegularMontserrat(
                      color: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .color
                          ?.withOpacity(0.9),
                      text: AppLocalizations.of(context).maximum_characters,
                      fontSize: 12)),
            ),
            18.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 4.w, right: 4.w),
                  child: SizedBox(
                    height: 26.h,
                    width: 26.w,
                    child: Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                          value: stateWatch.isChecked,
                          activeColor: lightThemeHighlightGreenColor,
                          checkColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2),
                          ),
                          onChanged: (value) {
                            stateNotifier.updateCheckBox(value ?? false);
                          }),
                    ),
                  ),
                ),
                4.horizontalSpace,
                Expanded(
                  child: GestureDetector(
                    onTap: () => ref.read(navigationProvider).navigateUsingPath(
                        path: webViewPagePath,
                        params: WebViewParams(url: privacyPolicyUrl),
                        context: context),
                    child: textSemiBoldMontserrat(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        text: AppLocalizations.of(context).feedback_text,
                        textOverflow: TextOverflow.visible,
                        textAlign: TextAlign.start,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
            Visibility(
                visible: stateWatch.onError,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: textSemiBoldMontserrat(
                      fontSize: 12,
                      textOverflow: TextOverflow.visible,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      color: Theme.of(context).colorScheme.error,
                      text: AppLocalizations.of(context)
                          .privacy_policy_error_msg),
                )),
            24.verticalSpace,
            CustomButton(
                textSize: 16,
                onPressed: () {
                  if (feedbackFormKey.currentState!.validate() &&
                      stateWatch.isChecked) {
                    ref.read(feedbackScreenProvider.notifier).sendFeedback(
                        success: () {
                          showSuccessToast(
                            message: AppLocalizations.of(context)
                                .feedback_sent_successfully,
                            context: context,
                          );
                          titleEditingController.clear();
                          descriptionEditingController.clear();
                          ref
                              .read(navigationProvider)
                              .removeTopPage(context: context);
                        },
                        onError: (String msg) {
                          showErrorToast(
                              message: msg,
                              context: context,
                              snackBarAlignment: Alignment.topCenter);
                        },
                        title: ref.read(feedbackScreenProvider).title,
                        description: descriptionEditingController.text,
                        email: emailEditingController.text);
                  }
                },
                text: AppLocalizations.of(context).submit),
            100.verticalSpace,
          ],
        ),
      ),
    );
  }
}
