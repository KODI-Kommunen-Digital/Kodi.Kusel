import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/toast_message.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/screens/auth/signup/signup_controller.dart';
import 'package:kusel/screens/auth/validator/email_validator.dart';
import 'package:kusel/screens/auth/validator/empty_field_validator.dart';
import 'package:kusel/screens/auth/validator/password_validator.dart';

import '../../../navigation/navigation.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final userNameTextEditingController = TextEditingController();
  final firstNameTextEditingController = TextEditingController();
  final lastNameTextEditingController = TextEditingController();

  final scrollController = ScrollController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();

  final signupFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    passwordFocusNode.addListener(() => _scrollToFocused(passwordFocusNode));

    emailFocusNode.addListener(() => _scrollToFocused(emailFocusNode));

    userNameFocusNode.addListener(() => _scrollToFocused(userNameFocusNode));

    firstNameFocusNode.addListener(() => _scrollToFocused(firstNameFocusNode));

    lastNameFocusNode.addListener(() => _scrollToFocused(lastNameFocusNode));
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    userNameTextEditingController.dispose();
    firstNameTextEditingController.dispose();
    lastNameTextEditingController.dispose();

    scrollController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    userNameFocusNode.dispose();
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(child: _buildBody(context)),
    ).loaderDialog(context, ref.watch(signUpScreenProvider).isLoading);
  }

  Widget _buildBody(BuildContext context) {
    final borderRadius = Radius.circular(30.r);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0.h,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .3,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                imagePath['background_image'] ?? "",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
              child: Container(
                color: Theme.of(context).colorScheme.onSecondary.withAlpha(150),
              ),
            ),
          ),
          Positioned(
            top: 100.h,
            bottom: 0.h,
            left: 0.w,
            right: 0.w,
            child: Container(
              padding: EdgeInsets.only(top: 20.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.only(
                  topRight: borderRadius,
                  topLeft: borderRadius,
                ),
              ),
              child: _buildSignUpCard(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpCard(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Form(
          key: signupFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              15.verticalSpace,
              Align(
                alignment: Alignment.center,
                child: textBoldPoppins(
                  text: AppLocalizations.of(context).signup,
                  fontSize: 20,
                ),
              ),
              32.verticalSpace,
              _buildLabel(context, AppLocalizations.of(context).email),
              KuselTextField(
                textEditingController: emailTextEditingController,
                focusNode: emailFocusNode,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')), // Prevent spaces
                ],
                validator: (value){
                  final trimmedValue = value?.trim();
                  return validateEmail(trimmedValue, context);
                },
              ),
              22.verticalSpace,
              _buildLabel(context, AppLocalizations.of(context).password),
              KuselTextField(
                textEditingController: passwordTextEditingController,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')), // Prevent spaces
                ],
                focusNode: passwordFocusNode,
                validator: (value){
                  final trimmedValue = value?.trim();
                  return validatePassword(trimmedValue, context); // or validateEmail for email field
                },
                obscureText: !ref.watch(signUpScreenProvider).showPassword,
                suffixIcon: ref.read(signUpScreenProvider).showPassword
                    ? GestureDetector(
                        onTap: () {
                          ref
                              .read(signUpScreenProvider.notifier)
                              .updateShowPasswordStatus(false);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: ImageUtil.loadSvgImage(
                              imageUrl: imagePath['eye_open']!,
                              context: context),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          ref
                              .read(signUpScreenProvider.notifier)
                              .updateShowPasswordStatus(true);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: ImageUtil.loadSvgImage(
                              imageUrl: imagePath['eye_closed']!,
                              context: context),
                        ),
                      ),
              ),
              22.verticalSpace,
              _buildLabel(context, AppLocalizations.of(context).username),
              KuselTextField(
                textEditingController: userNameTextEditingController,
                focusNode: userNameFocusNode,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')), // Prevent spaces
                ],
                validator: (value) => validateField(value,
                    "${AppLocalizations.of(context).username} ${AppLocalizations.of(context).is_required}"),
              ),
              22.verticalSpace,
              _buildLabel(context, AppLocalizations.of(context).firstName),
              KuselTextField(
                  textEditingController: firstNameTextEditingController,
                  focusNode: firstNameFocusNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')), // Prevent spaces
                  ],
                validator: (value) {
                  final trimmedValue = value?.trim();
                  return validateField(trimmedValue,
                      "${AppLocalizations.of(context).firstName} ${AppLocalizations.of(context).is_required}");
                }
              ),
              22.verticalSpace,
              _buildLabel(context, AppLocalizations.of(context).lastName),
              KuselTextField(
                textEditingController: lastNameTextEditingController,
                focusNode: lastNameFocusNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'^\s')), // Prevent leading spaces
                  ],
                  validator: (value) {
                    final trimmedValue = value?.trim();
                    return validateField(trimmedValue,
                        "${AppLocalizations.of(context).lastName} ${AppLocalizations.of(context).is_required}");
                  }
              ),
              32.verticalSpace,
              CustomButton(
                onPressed: () async {
                  if (signupFormKey.currentState?.validate() ?? false) {
                    await ref.read(signUpScreenProvider.notifier).registerUser(
                        userName: userNameTextEditingController.text
                            .trim()
                            .toLowerCase(),
                        password: passwordTextEditingController.text.trim(),
                        firstName: firstNameTextEditingController.text.trim(),
                        lastName: lastNameTextEditingController.text.trim(),
                        email: emailTextEditingController.text.trim(),
                        onError: (value) {
                          showErrorToast(message: value, context: context);
                        },
                        onSuccess: () {
                          showSuccessToast(
                              message:
                                  AppLocalizations.of(context).check_your_email,
                              context: context);
                          ref.read(navigationProvider).removeAllAndNavigate(
                              context: context, path: signInScreenPath);
                        });
                  }
                },
                text: AppLocalizations.of(context).signup,
              ),
              12.verticalSpace,
              Align(
                alignment: Alignment.center,
                child: textRegularPoppins(
                  text: AppLocalizations.of(context).or,
                  fontSize: 12,
                ),
              ),
              12.verticalSpace,
              GestureDetector(
                onTap: () {
                  ref.read(navigationProvider).removeCurrentAndNavigate(
                        context: context,
                        path: signInScreenPath,
                      );
                },
                child: Align(
                  alignment: Alignment.center,
                  child: textRegularPoppins(
                    text: AppLocalizations.of(context).login,
                    decoration: TextDecoration.underline,
                    fontSize: 12,
                  ),
                ),
              ),
              22.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: textSemiBoldPoppins(
        text: text,
        fontSize: 12,
        color: Theme.of(context).textTheme.displayMedium?.color,
      ),
    );
  }

  void _scrollToFocused(FocusNode focusNode) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final context = focusNode.context;
      if (context != null && context.mounted) {
        Scrollable.ensureVisible(context,
            duration: const Duration(milliseconds: 300));
      }
    });
  }
}
