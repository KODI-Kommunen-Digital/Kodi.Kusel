import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/kusel_text_field.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../../app_router.dart';
import '../../common_widgets/custom_button_widget.dart';
import '../../common_widgets/toast_message.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import '../auth/validator/empty_field_validator.dart';

class OnBoardingNamePage extends ConsumerStatefulWidget {
  const OnBoardingNamePage({super.key});

  @override
  ConsumerState<OnBoardingNamePage> createState() =>
      _OnboardingStartPageState();
}

class _OnboardingStartPageState extends ConsumerState<OnBoardingNamePage> {
  TextEditingController nameEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final savedName = ref.read(onboardingScreenProvider).userFirstName;
    if (savedName != null) {
      nameEditingController.text = savedName;
    }
    nameEditingController.addListener(() {
      ref
          .read(onboardingScreenProvider.notifier)
          .updateFirstName(nameEditingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildDashboardUi(),
    ).loaderDialog(context, ref.watch(onboardingScreenProvider).isLoading);
  }

  Widget _buildDashboardUi() {
    final onboardingNameFormKey =
        ref.read(onboardingScreenProvider.notifier).onboardingNameFormKey;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath['onboarding_background'] ?? ''),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Form(
            key: onboardingNameFormKey,
            child: Column(
              children: [
                65.verticalSpace,
                textBoldPoppins(
                    text: AppLocalizations.of(context).what_may_i_call_you,
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
                25.verticalSpace,
                Padding(
                  padding: EdgeInsets.only(left: 12.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: textRegularPoppins(
                        fontStyle: FontStyle.italic,
                        text: AppLocalizations.of(context).your_name,
                        fontSize: 12,
                        textAlign: TextAlign.left,
                        color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                ),
                5.verticalSpace,
                KuselTextField(
                  textEditingController: nameEditingController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "${AppLocalizations.of(context).name} ${AppLocalizations.of(context).is_required}";
                    }

                    final cleanedValue =
                        value.trim().replaceAll(RegExp(r'\s{2,}'), ' ');

                    if (!RegExp(r'^[A-Za-z]+(?: [A-Za-z]+)*$')
                        .hasMatch(cleanedValue)) {
                      return AppLocalizations.of(context)
                          .name_char_validation_msg;
                    }

                    if (cleanedValue.length < 3) {
                      return AppLocalizations.of(context).name_char_allowed_msg;
                    }

                    return null;
                  },
                  onChanged: (value) {
                    final cleanedValue = value
                        .replaceAll(RegExp(r'[^A-Za-z\s]'), '')
                        .replaceAll(RegExp(r'\s{2,}'), ' ');

                    if (value != cleanedValue) {
                      nameEditingController.value = TextEditingValue(
                        text: cleanedValue,
                        selection: TextSelection.collapsed(
                            offset: cleanedValue.length),
                      );
                    }

                    if (cleanedValue.trim().isNotEmpty) {
                      ref
                          .read(onboardingScreenProvider.notifier)
                          .updateIsNameScreenButtonVisibility(true);
                    } else {
                      ref
                          .read(onboardingScreenProvider.notifier)
                          .updateIsNameScreenButtonVisibility(false);
                    }
                  },
                  maxLines: 1,
                )
              ],
            ),
          ),
          Positioned(bottom: 10, left: 0, right: 0, child: _buildBottomUi())
        ],
      ),
    );
  }

  Widget _buildBottomUi() {
    final state = ref.read(onboardingScreenProvider);
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);

    return Column(
      children: [
        CustomButton(
          onPressed:
              (!ref.watch(onboardingScreenProvider).isNameScreenButtonVisible)
                  ? null
                  : () async {
                      if (stateNotifier.onboardingNameFormKey.currentState
                              ?.validate() ??
                          false) {
                        if (state.userFirstName != null || state.isLoggedIn) {
                          stateNotifier.editUserName(onSuccess: () async {
                            await stateNotifier.getUserDetails();
                          }, onError: (msg) {
                            showErrorToast(message: msg, context: context);
                          });
                        }
                        ref.read(navigationProvider).navigateUsingPath(
                            path: onboardingTypePagePath, context: context);
                      }
                    },
          text: AppLocalizations.of(context).next,
        ),
        18.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                ref.read(navigationProvider).removeTopPage(context: context);
              },
              child: textBoldPoppins(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 11,
                text: AppLocalizations.of(context).back,
              ),
            ),
            8.horizontalSpace,
            GestureDetector(
              onTap: () {
                ref.read(navigationProvider).navigateUsingPath(
                    path: onboardingTypePagePath, context: context);
              },
              child: textBoldPoppins(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 11,
                text: AppLocalizations.of(context).skip,
              ),
            )
          ],
        ),
        18.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Icon(
                Icons.circle,
                size: 8,
                color: Theme.of(context).primaryColor.withAlpha(130),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Icon(
                Icons.circle,
                size: 11,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Icon(
                Icons.circle,
                size: 8,
                color: Theme.of(context).primaryColor.withAlpha(130),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Icon(
                Icons.circle,
                size: 8,
                color: Theme.of(context).primaryColor.withAlpha(130),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Icon(
                Icons.circle,
                size: 8,
                color: Theme.of(context).primaryColor.withAlpha(130),
              ),
            )
          ],
        ),
        12.verticalSpace,
      ],
    );
  }
}
