import 'package:domain/model/response_model/user_detail/user_detail_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_button_widget.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/common_widgets/text_styles.dart';
import 'package:kusel/screens/profile/profile_screen_provider.dart';
import 'package:kusel/screens/profile/profile_screen_state.dart';

import '../../common_widgets/arrow_back_widget.dart';
import '../../common_widgets/downstream_wave_clipper.dart';
import '../../common_widgets/toast_message.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';
import 'package:kusel/l10n/app_localizations.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(profileScreenProvider.notifier).getUserDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.read(profileScreenProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: _buildProfileUi(state),
    ).loaderDialog(context, ref.watch(profileScreenProvider).loading);
  }

  Widget _buildProfileUi(ProfileScreenState state) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            _buildClipperBackground(),
            10.verticalSpace,
            _buildProfileDetailsList(state.userData),
            25.verticalSpace,
            Visibility(
              visible: ref.watch(profileScreenProvider).editingEnabled,
              child: Padding(
                  padding: DeviceHelper.isMobile(context)
                      ? EdgeInsets.symmetric(horizontal: 25.w)
                      : EdgeInsets.zero,
                  child: CustomButton(
                      onPressed: () {
                        ref.read(profileScreenProvider.notifier).editUserDetails(
                            onSuccess: () {
                          showSuccessToast(
                              message: AppLocalizations.of(context).field_updated_message,
                              context: context);
                        }, onError: (String msg) {
                          showErrorToast(message: msg, context: context);
                        });
                      },
                      text: AppLocalizations.of(context).save_changes)),
            ),
            40.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildClipperBackground() {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: ClipPath(
            clipper: DownstreamCurveClipper(),
            child: Container(
              height: 160.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath['home_screen_background'] ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(top: 70.h, child: _buildProfileImageWidget()),
        Positioned(
          top: 30.h,
          left: 15.w,
          right: 15.w,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ArrowBackWidget(
                  onTap: () {
                    ref
                        .read(navigationProvider)
                        .removeTopPage(context: context);
                  },
                ),
                textBoldPoppins(
                    text: AppLocalizations.of(context).profile,
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
                Visibility(
                    visible: !ref.watch(profileScreenProvider).editingEnabled,
                    child: GestureDetector(
                      onTap: () {
                        ref
                            .read(profileScreenProvider.notifier)
                            .updateEditing(true);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 5.h),
                        child: textRegularPoppins(
                            text: AppLocalizations.of(context).edit,
                            fontSize: 14,
                            color: Theme.of(context).textTheme.labelSmall?.color),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImageWidget() {
    final state = ref.watch(profileScreenProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.onSecondary,
              radius: 50.r,
              backgroundImage: _getProfileImage(context, state),
              child: _buildProfilePlaceholder(context, state),
            ),
            DeviceHelper.isMobile(context) ?             Positioned(
              left: 65.w,
              top: 60.h,
              child: GestureDetector(
                onTap: ref.read(profileScreenProvider.notifier).pickImage,
                child: Container(
                  padding: EdgeInsets.all(6.h.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 12.h.w,
                  ),
                ),
              ),
            ):             Positioned(
              left: 55.w,
              top: 65.h,
              child: GestureDetector(
                onTap: ref.read(profileScreenProvider.notifier).pickImage,
                child: Container(
                  padding: EdgeInsets.all(2.h.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 10.h.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetailsList(UserData? userdata) {
    final state = ref.watch(profileScreenProvider);
    final stateNotifier = ref.read(profileScreenProvider.notifier);
    return Padding(
      padding: DeviceHelper.isMobile(context) ? EdgeInsets.symmetric(horizontal:  20.w) : EdgeInsets.zero,
      child: Column(
        children: [
          _customProfileDetailTile(
            detailKey: AppLocalizations.of(context).name,
            detailValue:
                "${userdata?.firstname ?? ''} ${userdata?.lastname ?? ''}",
            icon: Icons.account_box,
            textEditingController: stateNotifier.nameEditingController,
            hintText: AppLocalizations.of(context).enter_name,
            fieldEnabled: state.editingEnabled ?? false,
          ),
          Divider(
            height: 3.h,
            color: Theme.of(context).dividerColor,
          ),
          _customProfileDetailTile(
            detailKey: AppLocalizations.of(context).username,
            detailValue: userdata?.username ?? '',
            icon: Icons.legend_toggle,
            textEditingController: stateNotifier.userNameEditingController,
            hintText: AppLocalizations.of(context).enter_username,
            fieldEnabled: false,
          ),
          Divider(
            height: 3.h,
            color: Theme.of(context).dividerColor,
          ),
          _customProfileDetailTile(
            detailKey: AppLocalizations.of(context).email,
            detailValue: userdata?.email ?? '',
            icon: Icons.email,
            maxLines: 2,
            textEditingController: stateNotifier.emailEditingController,
            hintText: AppLocalizations.of(context).email,
            fieldEnabled: false,
          ),
          Divider(
            height: 3.h,
            color: Theme.of(context).dividerColor,
          ),
          _customProfileDetailTile(
            detailKey: AppLocalizations.of(context).phone_number,
            detailValue: userdata?.phoneNumber ?? '',
            icon: Icons.phone_android,
            textEditingController: stateNotifier.phoneNumberEditingController,
            hintText: AppLocalizations.of(context).enter_phone_number,
            fieldEnabled: state.editingEnabled ?? false,
          ),
          Divider(
            height: 3.h,
            color: Theme.of(context).dividerColor,
          ),
          _customProfileDetailTile(
            detailKey: AppLocalizations.of(context).description,
            detailValue: userdata?.description ?? '',
            maxLines: 4,
            icon: Icons.textsms_outlined,
            textEditingController: stateNotifier.descriptionEditingController,
            hintText: AppLocalizations.of(context).enter_description,
            fieldEnabled: state.editingEnabled ?? false,
          ),
          Divider(
            height: 3.h,
            color: Theme.of(context).dividerColor,
          ),
          _customProfileDetailTile(
            detailKey: AppLocalizations.of(context).website,
            detailValue: userdata?.website ?? '_',
            icon: Icons.computer,
            textEditingController: stateNotifier.websiteEditingController,
            hintText: AppLocalizations.of(context).enter_website,
            fieldEnabled: state.editingEnabled ?? false,
          ),
        ],
      ),
    );
  }

  Widget _customProfileDetailTile({
    required String detailKey,
    required String detailValue,
    required IconData icon,
    required TextEditingController textEditingController,
    required String hintText,
    required bool fieldEnabled,
    int? maxLines,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(icon,
              size: DeviceHelper.isMobile(context) ? 25.h.w : 15.h.w,
              color: Theme.of(context).textTheme.labelMedium?.color),
          10.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: textBoldPoppins(
                    text: detailKey,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    border: fieldEnabled
                        ? Border.all(
                            width: 1.w,
                            color: Theme.of(context).colorScheme.surface)
                        : null),
                // height: 26.h,
                width: DeviceHelper.isMobile(context) ? 250.w : 220.w,
                child: Center(
                  child: TextField(
                    controller: textEditingController,
                    style: TextStyle(
                      fontSize: 12.sp,
                        color: fieldEnabled
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).textTheme.labelMedium?.color),
                    minLines: 1,
                    maxLines: maxLines ?? 1,
                    enabled: fieldEnabled,
                    decoration: InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                        hintText: hintText,
                        hintStyle: TextStyle(
                            color: Theme.of(context).textTheme.labelMedium?.color),
                        border: InputBorder.none),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  ImageProvider<Object>? _getProfileImage(
      BuildContext context, ProfileScreenState state) {
    if (state.imageFile != null) {
      return FileImage(state.imageFile!);
    } else if (state.userData?.image != null) {
      final url = ref
          .read(profileScreenProvider.notifier)
          .getUrlForImage(state.userData!.image!);

      if (url != null && url.isNotEmpty) {
        return NetworkImage(url);
      }
    }
    return null;
  }


  Widget? _buildProfilePlaceholder(
      BuildContext context, ProfileScreenState state) {
    if (state.imageFile == null && state.userData?.image == null) {
      return Icon(
        Icons.account_circle,
        size: 80.h.w,
        color: Theme.of(context).primaryColor.withAlpha(80),
      );
    }
    return null;
  }
}
