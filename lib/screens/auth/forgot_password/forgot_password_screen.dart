import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/toast_message.dart';
import 'package:kusel/images_path.dart';


import '../../../navigation/navigation.dart';
import '../validator/empty_field_validator.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _buildBody(context),
    ).loaderDialog(context, ref.watch(forgotPasswordProvider).isLoading));
  }

  _buildBody(BuildContext context) {
    final borderRadius = Radius.circular(50.r);
    return SafeArea(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                  top: 0.h,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(),
                    child: Image.asset(
                      imagePath['background_image'] ?? "",
                      fit: BoxFit.cover,
                    ),
                  )),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 0),
                  child: Container(
                    color: Theme.of(context).colorScheme.onSecondary.withValues(alpha: 0.6),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.h,
                left: 0.w,
                right: 0.w,
                child: Container(
                    height: MediaQuery.of(context).size.height * .8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.only(
                            topRight: borderRadius, topLeft: borderRadius)),
                    child: _buildForgotPasswordCard(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildForgotPasswordCard(BuildContext context) {
    return Form(
      key: _forgotPasswordFormKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            15.verticalSpace,
            Align(
                alignment: Alignment.center,
                child: textBoldPoppins(
                    text: AppLocalizations.of(context).forgot,
                    fontSize: 20)),
            40.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: textSemiBoldPoppins(
                  text: AppLocalizations.of(context).enter_email_id,
                  fontSize: 12,
                  color: Theme.of(context).textTheme.displayMedium?.color),
            ),
            5.verticalSpace,
            KuselTextField(
              textEditingController: emailTextEditingController,
              validator: (value) {
                return validateField(value,
                    "${AppLocalizations.of(context).enter_email_id} ${AppLocalizations.of(context).is_required}");
              },
            ),
            55.verticalSpace,
            CustomButton(
                onPressed: () async {
                  if (_forgotPasswordFormKey.currentState!.validate()) {
                    String languageCode =
                        PlatformDispatcher.instance.locale.languageCode;
                    ref
                        .read(forgotPasswordProvider.notifier)
                        .sendForgotPasswordRequest(
                            userNameOrEmail: emailTextEditingController.text,
                            language: languageCode,
                            onError: (value) {
                              showErrorToast(message: value, context: context);
                            },
                            onSuccess: () {
                              showSuccessToast(
                                  message:
                                      AppLocalizations.of(context).email_send,
                                  context: context);
                            });
                  }
                },
                text: AppLocalizations.of(context).submit),
            12.verticalSpace,
            Align(
                alignment: Alignment.center,
                child: textRegularPoppins(
                    text: AppLocalizations.of(context).or, fontSize: 12)),
            12.verticalSpace,
            GestureDetector(
              onTap: () {
                ref.read(navigationProvider).removeCurrentAndNavigate(
                    context: context, path: signInScreenPath);
              },
              child: Align(
                alignment: Alignment.center,
                child: textRegularPoppins(
                    text: AppLocalizations.of(context).login,
                    decoration: TextDecoration.underline,
                    fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
