import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/toast_message.dart';
import 'package:kusel/screens/reset_password/reset_password_controller.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/device_helper.dart';
import '../../common_widgets/text_styles.dart';
import '../../common_widgets/upstream_wave_clipper.dart';
import '../../images_path.dart';
import '../../l10n/app_localizations.dart';
import '../../navigation/navigation.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    ).loaderDialog(
        context, ref.watch(resetPasswordControllerProvider).isLoading);
  }

  _buildBody(BuildContext context) {
    return SafeArea(
      child: _buildUi(context),
    );
  }

  _buildUi(BuildContext context) {
    final state = ref.watch(resetPasswordControllerProvider);
    final controller = ref.read(resetPasswordControllerProvider.notifier);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildHeader(context),
            1.verticalSpace,
            _buildHeadingText(
                context, AppLocalizations.of(context).current_password),
            8.verticalSpace,
            _buildTextFormField(
              controller: currentPassword,
              onChanged: (value) {
                controller.isFormValid(currentPassword.text, newPassword.text,
                    confirmNewPassword.text);
              },
              showPassword: state.showCurrentPassword,
              hintText: AppLocalizations.of(context).current_password,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).password_required;
                }
                return null;
              },
              showPasswordOnTap: () {
                controller.showCurrentPassword(true);
              },
              hidePasswordOnTap: () {
                controller.showCurrentPassword(false);
              },
            ),
            30.verticalSpace,
            _buildHeadingText(
                context, AppLocalizations.of(context).new_password),
            8.verticalSpace,
            _buildTextFormField(
              controller: newPassword,
              onChanged: (value) async {
                await controller.newPasswordValidation(value);

                controller.isFormValid(currentPassword.text, newPassword.text,
                    confirmNewPassword.text);
              },
              showPassword: state.showNewPassword,
              hintText: AppLocalizations.of(context).new_password,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).field_cannot_be_empty;
                }
                return null;
              },
              showPasswordOnTap: () {
                controller.showNewsPassword(true);
              },
              hidePasswordOnTap: () {
                controller.showNewsPassword(false);
              },
            ),
            8.verticalSpace,
            _buildPasswordValidationText(
                AppLocalizations.of(context).at_least_8_character,
                state.isAtLeast8CharacterComplete),
            8.verticalSpace,
            _buildPasswordValidationText(
                AppLocalizations.of(context).contains_letters_and_numbers,
                state.isHaveNumberLetterComplete),
            8.verticalSpace,
            _buildPasswordValidationText(
                AppLocalizations.of(context).contains_upper_case_and_lower_case,
                state.isLowerCaseUpperCaseComplete),
            8.verticalSpace,
            _buildPasswordValidationText(
                AppLocalizations.of(context).contains_special_character,
                state.isSpecialCharacterComplete),
            32.verticalSpace,
            _buildHeadingText(
                context, AppLocalizations.of(context).confirm_new_password),
            8.verticalSpace,
            _buildTextFormField(
              controller: confirmNewPassword,
              onChanged: (value) {
                controller.isFormValid(currentPassword.text, newPassword.text,
                    confirmNewPassword.text);
              },
              showPassword: state.showConfirmNewPassword,
              hintText: AppLocalizations.of(context).confirm_new_password,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context).field_cannot_be_empty;
                }
                if (value != newPassword.text) {
                  return AppLocalizations.of(context)
                      .password_is_not_same_as_new_password;
                }
                return null;
              },
              showPasswordOnTap: () {
                controller.showConfirmNewsPassword(true);
              },
              hidePasswordOnTap: () {
                controller.showConfirmNewsPassword(false);
              },
            ),
            100.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(
                  textSize: 16,
                  onPressed: state.showButton
                      ? () {
                          controller.resetPassword(
                              newPassword.text, currentPassword.text, () {
                            showSuccessToast(
                                message: AppLocalizations.of(context)
                                    .reset_password_success,
                                context: context,
                                onCLose: () {});

                            ref
                                .read(navigationProvider)
                                .removeTopPage(context: context);
                          }, (message) {
                            showErrorToast(message: message, context: context);
                          });
                        }
                      : null,
                  text: AppLocalizations.of(context).update_password,
                  borderColor: Colors.transparent,
                ),
              ),
            )
          ],
        ),
      ),
    );
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

  _buildHeadingText(BuildContext context, String label) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w),
        child: textRegularMontserrat(
            text: label,
            fontStyle: FontStyle.italic,
            fontSize: 15,
            color: Theme.of(context)
                .textTheme
                .displayMedium!
                .color
                ?.withOpacity(0.8)));
  }

  _buildTextFormField({
    required TextEditingController controller,
    required Function(String)? onChanged,
    required bool showPassword,
    required String hintText,
    required Function() showPasswordOnTap,
    required Function() hidePasswordOnTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: KuselTextField(
        enableBorderColor: Theme.of(context).dividerColor,
        hintText: hintText,
        textEditingController: controller,
        prefixIcon: ImageUtil.loadLocalSvgImage(
            imageUrl: 'lock', context: context, fit: BoxFit.contain),
        onChanged: onChanged,
        maxLines: 1,
        suffixIcon: showPassword
            ? GestureDetector(
                onTap: hidePasswordOnTap,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: ImageUtil.loadSvgImage(
                      height: 20.h,
                      width: 20.w,
                      imageUrl: imagePath['eye_open']!,
                      context: context,
                      color: Theme.of(context).primaryColor),
                ),
              )
            : GestureDetector(
                onTap: showPasswordOnTap,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: ImageUtil.loadSvgImage(
                      height: 20.h,
                      width: 20.w,
                      imageUrl: imagePath['eye_closed']!,
                      context: context,
                      color: Theme.of(context).primaryColor),
                ),
              ),
        obscureText: !showPassword,
        validator: validator,
      ),
    );
  }

  _buildPasswordValidationText(String label, bool isChecked) {
    return Padding(
      padding: EdgeInsets.only(left: 28.w),
      child: Row(
        children: [
          if (!isChecked)
            SizedBox(
              height: 20.h,
              width: 20.w,
              child: ImageUtil.loadLocalSvgImage(
                  imageUrl: 'circular_check_outline', context: context),
            ),
          if (isChecked)
            SizedBox(
              height: 20.h,
              width: 20.w,
              child: ImageUtil.loadLocalSvgImage(
                  imageUrl: 'circular_check_filled', context: context),
            ),
          5.horizontalSpace,
          if (isChecked)
            textSemiBoldMontserrat(
                text: label,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 15),
          if (!isChecked)
            textRegularMontserrat(
                text: label,
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 15)
        ],
      ),
    );
  }
}
