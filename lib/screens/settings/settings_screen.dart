import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/common_widgets/upstream_wave_clipper.dart';
import 'package:kusel/images_path.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/home/home_screen_provider.dart';
import 'package:kusel/screens/settings/settings_screen_provider.dart';
import 'package:kusel/utility/url_constants/url_constants.dart';

import '../../common_widgets/common_background_clipper_widget.dart';
import '../../common_widgets/toast_message.dart';
import '../../common_widgets/web_view_page.dart';
import '../dashboard/dashboard_screen_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(settingsScreenProvider.notifier).fetchCurrentLanguage();
      ref.read(settingsScreenProvider.notifier).isLoggedIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildBody(context)),
    ).loaderDialog(context, ref.watch(settingsScreenProvider).isLoading);
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        children: [
          CommonBackgroundClipperWidget(
              clipperType: UpstreamWaveClipper(),
              imageUrl: imagePath['background_image'] ?? "",
              height: 100.h,
              blurredBackground: true,
              isStaticImage: true),
          Visibility(
            visible: ref.watch(settingsScreenProvider).isLoggedIn,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                      size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                      Icons.account_circle_outlined),
                  title: textBoldPoppins(
                    text: AppLocalizations.of(context).profile,
                    textAlign: TextAlign.start,
                  ),
                  onTap: () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: profileScreenPath, context: context);
                  },
                ),
                const Divider(),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
                size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                Icons.language),
            title: textBoldPoppins(
                textAlign: TextAlign.start,
                text: AppLocalizations.of(context).change_language),
            onTap: () => _showLanguageDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
                size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                Icons.link),
            title: textBoldPoppins(
                textAlign: TextAlign.start,
                text: AppLocalizations.of(context).imprint_page),
            onTap: () => ref.read(navigationProvider).navigateUsingPath(
                path: webViewPagePath,
                params: WebViewParams(url: imprintPageUrl),
                context: context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
                size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                Icons.text_snippet_outlined),
            title: textBoldPoppins(
                textAlign: TextAlign.start,
                text: AppLocalizations.of(context).terms_of_use),
            onTap: () => ref.read(navigationProvider).navigateUsingPath(
                path: webViewPagePath,
                params: WebViewParams(url: termsOfUseUrl),
                context: context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
                size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                Icons.privacy_tip_outlined),
            title: textBoldPoppins(
                textAlign: TextAlign.start,
                text: AppLocalizations.of(context).privacy_policy),
            onTap: () => ref.read(navigationProvider).navigateUsingPath(
                path: webViewPagePath,
                params: WebViewParams(url: privacyPolicyUrl),
                context: context),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
                size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                Icons.favorite_border),
            title: textBoldPoppins(
              text: AppLocalizations.of(context).favorites,
              textAlign: TextAlign.start,
            ),
            onTap: () async {
              ref.read(navigationProvider).navigateUsingPath(
                  context: context, path: favoritesListScreenPath);
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(
                size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                Icons.place),
            title: textBoldPoppins(
              text: AppLocalizations.of(context).favourite_places,
              textAlign: TextAlign.start,
            ),
            onTap: () async {
              ref.read(navigationProvider).navigateUsingPath(
                  context: context, path: favouriteCityScreenPath);
            },
          ),
          const Divider(),
          Visibility(
            visible: ref.watch(settingsScreenProvider).isLoggedIn,
            child: ListTile(
              leading: Icon(
                  size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                  Icons.logout),
              title: textBoldPoppins(
                text: AppLocalizations.of(context).logout,
                textAlign: TextAlign.start,
              ),
              onTap: () async {
                ref.read(settingsScreenProvider.notifier).logoutUser(() async {
                  await ref.read(settingsScreenProvider.notifier).isLoggedIn();
                  await ref.read(homeScreenProvider.notifier).getLoginStatus();
                }, onSuccess: () {
                  ref.read(dashboardScreenProvider.notifier).onIndexChanged(0);
                  ref.read(navigationProvider).removeAllAndNavigate(
                      context: context, path: signInScreenPath);
                });
              },
            ),
          ),
          Visibility(
            visible: !ref.watch(settingsScreenProvider).isLoggedIn,
            child: ListTile(
              leading: Icon(
                  size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                  Icons.login),
              title: textBoldPoppins(
                text: AppLocalizations.of(context).log_in_sign_up,
                textAlign: TextAlign.start,
              ),
              onTap: () async {
                ref.read(navigationProvider).removeCurrentAndNavigate(
                    context: context, path: signInScreenPath);
              },
            ),
          ),


          Visibility(
            visible: ref.watch(settingsScreenProvider).isLoggedIn,
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: Icon(
                      size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                      Icons.lock_reset),
                  title: textBoldPoppins(
                    text: AppLocalizations.of(context).profile_setting,
                    textAlign: TextAlign.start,
                  ),
                  onTap: () {
                    ref.read(navigationProvider).navigateUsingPath(
                        path: resetPasswordScreenPath, context: context);
                  },
                ),
              ],
            ),
          ),

          Column(
            children: [
              const Divider(),
              ListTile(
                leading: Icon(
                    size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                    Icons.file_copy_outlined),
                title: textBoldPoppins(
                  text: AppLocalizations.of(context).edit_onboarding_details,
                  textAlign: TextAlign.start,
                ),
                onTap: () {
                  ref.read(navigationProvider).navigateUsingPath(
                      path: onboardingStartPagePath, context: context);
                },
              ),
            ],
          ),
          Visibility(
            visible: ref.watch(settingsScreenProvider).isLoggedIn,
            child: Column(
              children: [
                const Divider(),
                ListTile(
                  leading: Icon(
                    size: DeviceHelper.isMobile(context) ? null : 12.h.w,
                    Icons.delete,
                    color: Theme.of(context).colorScheme.onTertiaryFixed,
                  ),
                  title: textBoldPoppins(
                    text: AppLocalizations.of(context).delete_account,
                    color: Theme.of(context).colorScheme.onTertiaryFixed,
                    textAlign: TextAlign.start,
                  ),
                  onTap: () {
                    showDeleteAccountDialog(context);
                  },
                ),
              ],
            ),
          ),
          100.verticalSpace
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final selectedLanguage =
            ref.watch(settingsScreenProvider).selectedLanguage;

        final languageList = ref.read(settingsScreenProvider).languageList;

        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: textBoldPoppins(
            color: Colors.white,
            text: AppLocalizations.of(context).select_language,
          ),
          content: Container(
            color: Theme.of(context).colorScheme.secondary,
            width: double.maxFinite,
            height: 90.h,
            child: ListView(
              shrinkWrap: true,
              children: languageList.map((language) {
                return RadioTheme(
                    data: RadioThemeData(
                      fillColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.white; // selected radio button
                        }
                        return Colors.white; // unselected radio button
                      }),
                    ),
                    child: RadioListTile<String>(
                      hoverColor: Colors.white,
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: textRegularPoppins(
                            text: language, color: Colors.white),
                      ),
                      value: language,
                      selectedTileColor: Colors.white,
                      groupValue: selectedLanguage,
                      onChanged: (String? value) {
                        if (value != null) {
                          ref
                              .read(settingsScreenProvider.notifier)
                              .changeLanguage(selectedLanguage: value);
                          ref
                              .read(navigationProvider)
                              .removeDialog(context: context);
                        }
                      },
                    ));
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void showDeleteAccountDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(AppLocalizations.of(context).delete_account),
          content:
              Text(AppLocalizations.of(context).delete_account_information),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                ref.read(navigationProvider).removeTopPage(context: context);
              },
              child: Text(AppLocalizations.of(context).cancel),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                ref.read(settingsScreenProvider.notifier).deleteAccount(() {
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
                }).then((value) {
                  ref.read(navigationProvider).removeTopPage(context: context);
                });
              },
              child: Text(AppLocalizations.of(context).ok),
            ),
          ],
        );
      },
    );
  }
}
