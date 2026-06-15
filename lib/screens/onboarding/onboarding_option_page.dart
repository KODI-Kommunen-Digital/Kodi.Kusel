import 'package:flutter/material.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/progress_indicator.dart';
import 'package:kusel/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/custom_selection_button.dart';
import 'package:kusel/screens/onboarding/onboarding_screen_provider.dart';

import '../../app_router.dart';
import '../../common_widgets/custom_button_widget.dart';
import '../../common_widgets/search_widget/search_widget.dart';
import '../../common_widgets/search_widget/search_widget_provider.dart';
import '../../common_widgets/text_styles.dart';
import '../../images_path.dart';
import '../../navigation/navigation.dart';

class OnboardingOptionPage extends ConsumerStatefulWidget {
  const OnboardingOptionPage({super.key});

  @override
  ConsumerState<OnboardingOptionPage> createState() =>
      _OnboardingStartPageState();
}

class _OnboardingStartPageState extends ConsumerState<OnboardingOptionPage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<SearchStringWidgetState> _searchWidgetKey = GlobalKey();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.microtask(() async {
      if (!mounted) return;
      final notifier = ref.read(onboardingScreenProvider.notifier);
      await notifier.fetchCities();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: _buildDashboardUi(),
      ),
    ).loaderDialog(context, ref.watch(onboardingScreenProvider).isLoading);
  }

  Widget _buildDashboardUi() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath['onboarding_background'] ?? ''),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 18.h),
        child: Stack(
          children: [
            ref.read(onboardingScreenProvider).isResident
                ? _buildResidentUi()
                : _buildTouristUi(),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: _buildBottomUi(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResidentUi() {
    final state = ref.watch(onboardingScreenProvider);
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        _searchWidgetKey.currentState?.closeSuggestions();
        ref.read(searchProvider.notifier).clearSearch();
      },
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            65.verticalSpace,
            textBoldPoppins(
                text: AppLocalizations.of(context).i_live_in_district,
                fontSize: 20,
                color: Theme.of(context).textTheme.bodyLarge?.color),
            20.verticalSpace,
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 12.w, bottom: 4.h),
                child: textSemiBoldPoppins(
                  text: AppLocalizations.of(context).your_place_of_residence,
                  fontStyle: FontStyle.italic,
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            ResidenceSearchWidget(),
            20.verticalSpace,
            Divider(
              height: 3.h,
              color: Theme.of(context).dividerColor,
            ),
            20.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).alone,
                isSelected: state.isSingle,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  _searchWidgetKey.currentState?.closeSuggestions();
                  await stateNotifier.updateOnboardingFamilyType(
                      OnBoardingFamilyType.single);
                  stateNotifier.isAllOptionFieldsCompleted();
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).for_two,
                isSelected: state.isForTwo,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  _searchWidgetKey.currentState?.closeSuggestions();
                  await stateNotifier.updateOnboardingFamilyType(
                      OnBoardingFamilyType.withTwo);
                  stateNotifier.isAllOptionFieldsCompleted();
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).with_my_family,
                isSelected: state.isWithFamily,
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  _searchWidgetKey.currentState?.closeSuggestions();
                  await stateNotifier.updateOnboardingFamilyType(
                      OnBoardingFamilyType.withMyFamily);
                  stateNotifier.isAllOptionFieldsCompleted();
                }),
            20.verticalSpace,
            Divider(
              height: 3.h,
              color: Theme.of(context).dividerColor,
            ),
            20.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).with_dog,
                isSelected: state.isWithDog,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _searchWidgetKey.currentState?.closeSuggestions();
                  stateNotifier
                      .updateCompanionType(OnBoardingCompanionType.withDog);
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).barrierearm,
                isSelected: state.isBarrierearm,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  _searchWidgetKey.currentState?.closeSuggestions();
                  stateNotifier.updateCompanionType(
                      OnBoardingCompanionType.barrierearm);
                }),
            5.verticalSpace,
            Visibility(
                visible: state.isErrorMsgVisible,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: textRegularPoppins(
                        text: AppLocalizations.of(context)
                            .please_select_the_field,
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 11),
                  ),
                )),
            10.verticalSpace,
            if (DeviceHelper.isTablet(context)) 120.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTouristUi() {
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    final state = ref.watch(onboardingScreenProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            65.verticalSpace,
            textBoldPoppins(
                text: AppLocalizations.of(context).i_am_visiting_the_district,
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyLarge?.color),
            20.verticalSpace,
            Divider(
              height: 3.h,
              color: Theme.of(context).dividerColor,
            ),
            20.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).alone,
                isSelected: state.isSingle,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  stateNotifier.updateOnboardingFamilyType(
                      OnBoardingFamilyType.single);
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).for_two,
                isSelected: state.isForTwo,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  stateNotifier.updateOnboardingFamilyType(
                      OnBoardingFamilyType.withTwo);
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).with_my_family,
                isSelected: state.isWithFamily,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  stateNotifier.updateOnboardingFamilyType(
                      OnBoardingFamilyType.withMyFamily);
                }),
            20.verticalSpace,
            Divider(
              height: 3.h,
              color: Theme.of(context).dividerColor,
            ),
            20.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).with_dog,
                isSelected: state.isWithDog,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  stateNotifier
                      .updateCompanionType(OnBoardingCompanionType.withDog);
                }),
            12.verticalSpace,
            CustomSelectionButton(
                text: AppLocalizations.of(context).barrierearm,
                isSelected: state.isBarrierearm,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  stateNotifier.updateCompanionType(
                      OnBoardingCompanionType.barrierearm);
                }),
            5.verticalSpace,
            Visibility(
                visible: state.isErrorMsgVisible,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: textRegularPoppins(
                        text: AppLocalizations.of(context)
                            .please_select_the_field,
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 11),
                  ),
                )),
            if (DeviceHelper.isTablet(context)) 100.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _dropDownResidence() {
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    final state = ref.watch(onboardingScreenProvider);

    if(state.resident!=null && state.resident!.isNotEmpty)
      {
        _searchController.text = state.resident!;
      }

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SearchStringWidget(
        key: _searchWidgetKey,
        searchController: _searchController,
        isPaddingEnabled: false,
        suggestionCallback: (pattern) async {
          final list = state.residenceList;
          if (list.isEmpty) return [];

          if (pattern.trim().isEmpty) {
            return list;
          }

          return list
              .where((e) => e.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        onItemClick: (selected) {
          _searchController.text = selected;
          stateNotifier.updateUserType(selected);
          stateNotifier.isAllOptionFieldsCompleted();
        },
      ),
    );
  }

  Widget _buildBottomUi() {
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);

    return Column(
      children: [
    CustomButton(
            onPressed: (!ref.watch(onboardingScreenProvider).isOptionPageButtonVisible)?null:() async{

              if (stateNotifier.isAllOptionFieldsCompleted()) {
                stateNotifier.updateErrorMsgStatus(true);
              } else {
                stateNotifier.updateErrorMsgStatus(false);
                stateNotifier.submitUserDemographics();
                ref.read(onboardingScreenProvider.notifier).updateSelectedCity();
                ref.read(navigationProvider).navigateUsingPath(
                    path: onboardingPreferencesPagePath, context: context);
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
                    path: onboardingPreferencesPagePath, context: context);
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
            )
          ],
        ),
        12.verticalSpace,
      ],
    );
  }
}
class ResidenceSearchWidget extends ConsumerStatefulWidget {
  const ResidenceSearchWidget({super.key});

  @override
  ConsumerState<ResidenceSearchWidget> createState() => _ResidenceSearchWidgetState();
}

class _ResidenceSearchWidgetState extends ConsumerState<ResidenceSearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<SearchStringWidgetState> _searchWidgetKey = GlobalKey();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeFromState();
  }

  void _initializeFromState() {
    final state = ref.read(onboardingScreenProvider);
    if (state.resident != null && state.resident!.isNotEmpty && !_isInitialized) {
      _searchController.text = state.resident!;
      _isInitialized = true;
    }
  }

  @override
  void didUpdateWidget(ResidenceSearchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeFromState();
  }

  void _updateResidence(String selected) {
    final stateNotifier = ref.read(onboardingScreenProvider.notifier);
    _searchController.text = selected;
    stateNotifier.updateUserType(selected);
    stateNotifier.isAllOptionFieldsCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingScreenProvider);

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SearchStringWidget(
        key: _searchWidgetKey,
        searchController: _searchController,
        isPaddingEnabled: false,
        suggestionCallback: (pattern) async {
          final list = state.residenceList;
          if (list.isEmpty) return [];

          if (pattern.trim().isEmpty) {
            return list;
          }

          return list
              .where((e) => e.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        onItemClick: _updateResidence,
        onFieldSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            _updateResidence(value);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
