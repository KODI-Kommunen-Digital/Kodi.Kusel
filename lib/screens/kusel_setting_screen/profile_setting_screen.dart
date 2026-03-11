import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/custom_dropdown.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/toast_message.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/providers/notifications_provider.dart';
import 'package:kusel/screens/kusel_setting_screen/kusel_setting_screen_controller.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/device_helper.dart';
import '../../common_widgets/kusel_text_field.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';

class ProfileSettingScreen extends ConsumerStatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  ConsumerState<ProfileSettingScreen> createState() =>
      _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends ConsumerState<ProfileSettingScreen>
    with WidgetsBindingObserver {
  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneNumberTextEditingController =
      TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();

  late ProviderSubscription removeListener;

  @override
  void initState() {
    super.initState();

    removeListener = ref.listenManual(
      kuselSettingScreenProvider,
      (previous, next) {
        userNameTextEditingController.text = next.name;
        emailTextEditingController.text = next.email;
        addressTextEditingController.text = next.address;
        phoneNumberTextEditingController.text = next.mobileNumber;
      },
    );

    Future.microtask(() {
      final controller = ref.read(kuselSettingScreenProvider.notifier);

      controller.getUserDetail();
      controller.getLocationPermissionStatus();
      ref.read(notificationsProvider.notifier).initializeNotificationStatus();
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    removeListener.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref
          .read(kuselSettingScreenProvider.notifier)
          .getLocationPermissionStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (ref.watch(kuselSettingScreenProvider).isProfilePageLoading)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildBody(context),
    );
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
          _buildTextFieldHeadingText(
              AppLocalizations.of(context).change_language),
          6.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: CustomDropdown(
                hintText: AppLocalizations.of(context).change_language,
                items: state.languageList,
                selectedItem: state.selectedLanguage,
                onSelected: (value) {
                  if (value != null) {
                    controller.changeLanguage(selectedLanguage: value);
                  }
                }),
          ),
          _buildUserForm(context),
          32.verticalSpace,
          _buildLocationToggle(context),
          32.verticalSpace,
          _buildNotificationToggle(context),
          32.verticalSpace,
          _buildArrowContainer(
              context, AppLocalizations.of(context).ort, () async {},
              subChild: state.selectedOrt.isEmpty
                  ? null
                  : textSemiBoldMontserrat(
                      text: state.selectedOrt,
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.8))),
          6.verticalSpace,
          _buildArrowContainer(context,
              AppLocalizations.of(context).edit_interest_profile, () {},
              subChild: state.listOfUserInterest.isEmpty
                  ? null
                  : Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: [
                        // Take first 3 chips
                        ...state.listOfUserInterest
                            .take(3)
                            .map((item) => _buildChip(item.name!)),

                        // If more than 3, show +N chip
                        if (state.listOfUserInterest.length > 3)
                          _buildChip('+${state.listOfUserInterest.length - 3}',
                              isExtra: true),
                      ],
                    )),
          32.verticalSpace,
          Visibility(
            visible: state.isUserLoggedIn,
            child: _buildArrowContainer(
                context, AppLocalizations.of(context).change_password, () {
              ref.read(navigationProvider).navigateUsingPath(
                  path: resetPasswordScreenPath, context: context);
            }),
          ),
          12.verticalSpace,
          Visibility(
            visible: state.isUserLoggedIn,
            child: _buildArrowContainer(
                context, AppLocalizations.of(context).delete_account, () async {
              await ref.read(kuselSettingScreenProvider.notifier).deleteAccount(
                  () async {
                showSuccessToast(
                    message: AppLocalizations.of(context)
                        .success_delete_account_message,
                    context: context,
                    snackBarAlignment: Alignment.topCenter);
              }, (message) {
                showErrorToast(
                    message: message,
                    context: context,
                    snackBarAlignment: Alignment.topCenter);
              });
            }, labelColor: Theme.of(context).colorScheme.error),
          ),
          34.verticalSpace,
          Visibility(
            visible: state.isUserLoggedIn && state.hasChanges,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                    textSize: 16,
                    onPressed: () async {
                      await controller.updateUserDetails(onSuccess: () {
                        showSuccessToast(
                            message: AppLocalizations.of(context).save_changes,
                            context: context,
                            snackBarAlignment: Alignment.topCenter);
                      }, onError: (message) {
                        showErrorToast(
                            message: message,
                            context: context,
                            snackBarAlignment: Alignment.topCenter);
                      });
                    },
                    text: AppLocalizations.of(context).save_changes),
              ),
            ),
          ),
          100.verticalSpace
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
            height: 110.h,
            blurredBackground: true,
            isBackArrowEnabled: false,
            isStaticImage: true),
        Positioned(
          top: 30.h,
          left: 12.w,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  ref.read(navigationProvider).removeTopPage(context: context);
                },
                icon: Icon(
                  size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                  Icons.arrow_back,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              8.horizontalSpace,
              textSemiBoldPoppins(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  text: AppLocalizations.of(context).profile_setting,
                  fontSize: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserForm(BuildContext context) {
    final state = ref.watch(kuselSettingScreenProvider);
    final controller = ref.read(kuselSettingScreenProvider.notifier);

    return Visibility(
        visible: state.isUserLoggedIn,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,
            //USERNAME
            _buildTextFieldHeadingText(AppLocalizations.of(context).username),
            6.verticalSpace,
            _buildTextFormField(
                controller: userNameTextEditingController,
                hintText:
                    AppLocalizations.of(context).enter_username.toLowerCase(),
                enable: false),

            16.verticalSpace,
            //EMAIL
            _buildTextFieldHeadingText(AppLocalizations.of(context).email),
            6.verticalSpace,
            _buildTextFormField(
                controller: emailTextEditingController,
                enable: false,
                onChanged: (value) {
                  controller.updateEmail(value);
                },
                hintText:
                    AppLocalizations.of(context).enter_email.toLowerCase(),
                textInputType: TextInputType.emailAddress),

            16.verticalSpace,
            //MOBILE
            _buildTextFieldHeadingText(
                "${AppLocalizations.of(context).mobile} (${AppLocalizations.of(context).optional})"),
            6.verticalSpace,
            _buildTextFormField(
                textInputType: TextInputType.number,
                controller: phoneNumberTextEditingController,
                onChanged: (value) {
                  controller.updatePhoneNumber(value);
                },
                hintText: AppLocalizations.of(context)
                    .enter_phone_number
                    .toLowerCase()),

            16.verticalSpace,
            _buildTextFieldHeadingText(
                "${AppLocalizations.of(context).address} (${AppLocalizations.of(context).optional})"),
            6.verticalSpace,
            _buildTextFormField(
                controller: addressTextEditingController,
                onChanged: (value) {
                  controller.updateAddress(value);
                },
                hintText: AppLocalizations.of(context).address.toLowerCase()),
          ],
        ));
  }

  _buildTextFieldHeadingText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: textRegularMontserrat(
          text: text,
          color: Theme.of(context)
              .textTheme
              .displayMedium!
              .color
              ?.withOpacity(0.9),
          fontSize: 14,
          fontStyle: FontStyle.italic),
    );
  }

  _buildTextFormField(
      {required TextEditingController controller,
      Function(String)? onChanged,
      required String hintText,
      String? Function(String?)? validator,
      TextInputType? textInputType,
      bool enable = true}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: KuselTextField(
        enable: enable,
        keyboardType: textInputType,
        hintText: hintText,
        textEditingController: controller,
        onChanged: onChanged,
        enableBorderColor: Theme.of(context).dividerColor,
        maxLines: 1,
        validator: validator,
      ),
    );
  }

  _buildArrowContainer(BuildContext context, String label, Function() onTap,
      {Widget? subChild, Color? labelColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(15.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textBoldMontserrat(
                          text: label,
                          fontSize: 16,
                          color: labelColor ??
                              Theme.of(context).textTheme.bodyLarge!.color),
                      5.verticalSpace,
                      if (subChild != null) subChild,
                    ],
                  ),
                ),
                ImageUtil.loadLocalSvgImage(
                    imageUrl: 'forward_arrow',
                    context: context,
                    color: labelColor),
              ])
            ],
          )),
    );
  }

  Widget _buildChip(String label, {bool isExtra = false}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isExtra ? 16.w : 16.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: isExtra ? Colors.transparent : const Color(0xFFAADB40),
        borderRadius: BorderRadius.circular(20.r),
        border: isExtra
            ? Border.all(
                color: const Color(0xFFAADB40),
                width: 1.5,
              )
            : null,
      ),
      child: textRegularMontserrat(
          text: label,
          fontSize: 15,
          color: Theme.of(context).textTheme.displayMedium!.color),
    );
  }

  _buildLocationToggle(BuildContext context) {
    final state = ref.watch(kuselSettingScreenProvider);
    final controller = ref.read(kuselSettingScreenProvider.notifier);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textBoldMontserrat(
                        text: AppLocalizations.of(context).location_sharing,
                        fontSize: 16,
                        color:
                            Theme.of(context).textTheme.displayMedium!.color),
                    5.verticalSpace,
                    textSemiBoldMontserrat(
                        text: AppLocalizations.of(context).an,
                        fontSize: 14,
                        color:
                            Theme.of(context).textTheme.displayMedium!.color),
                  ],
                ),
              ),
              Switch(
                  value: state.isLocationPermissionGranted,
                  activeColor: Theme.of(context).indicatorColor,
                  onChanged: (value) async {
                    final res = await controller
                        .requestOrHandleLocationPermission(value);

                    if (!res) {
                      Future.microtask(() {
                        openAppSettings();
                      });
                    }
                  }),
            ])
          ],
        ));
  }

  _buildNotificationToggle(BuildContext context) {
    final isNotificationEnabled = ref.watch(notificationsProvider);
    final controller = ref.read(notificationsProvider.notifier);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textBoldMontserrat(
                      text: AppLocalizations.of(context).notification,
                        fontSize: 16,
                        color:
                        Theme.of(context).textTheme.displayMedium!.color),
                  ],
                ),
              ),
              Switch(
                  value: isNotificationEnabled,
                  activeColor: Theme.of(context).indicatorColor,
                  onChanged: (value) async {
                    final res = await controller
                        .requestOrHandleNotificationPermission(value);
                    if (!res) {
                      Future.microtask(() {
                        openAppSettings();
                      });
                    }
                  }),
            ])
          ],
        ));
  }

}
