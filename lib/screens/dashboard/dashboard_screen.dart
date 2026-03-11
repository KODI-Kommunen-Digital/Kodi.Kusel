import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/device_helper.dart';
import 'package:kusel/common_widgets/image_utility.dart';
import 'package:kusel/navigation/navigation.dart';

import '../../images_path.dart';
import 'dashboard_screen_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell child;

  DashboardScreen({super.key, required this.child});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> _canExit() async {
    int selectedIndex = ref.read(dashboardScreenProvider).selectedIndex;
    if (selectedIndex != 0) {
      ref.read(dashboardScreenProvider.notifier).onIndexChanged(0);
      ref
          .read(navigationProvider)
          .removeAllAndNavigate(context: context, path: homeScreenPath);
      return false; // Don't exit the app
    }
    return true; // Exit the app
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = ref.watch(dashboardScreenProvider).selectedIndex;

    return PopScope(
      canPop: ref.watch(dashboardScreenProvider).canPop,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          final res = await _canExit();

          if (res) {
            ref.read(navigationProvider).removeTopPage(context: context);
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(child: widget.child),
              Positioned(
                left: 16.w,
                right: 16.w,
                bottom: 16.h,
                child: DotNavigationBar(
                  backgroundColor: Theme.of(context).bottomAppBarTheme.color,
                  selectedItemColor: Theme.of(context).indicatorColor,
                  unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
                  currentIndex: selectedIndex,
                  enableFloatingNavBar: true,
                  enablePaddingAnimation: false,

                  paddingR: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  marginR: const EdgeInsets.all(0),
                  onTap: (index) {
                    ref
                        .read(dashboardScreenProvider.notifier)
                        .onIndexChanged(index);
          
                    widget.child.goBranch(index);
                  },
                  dotIndicatorColor: Theme.of(context).indicatorColor,
                  itemPadding: const EdgeInsets.only(
                      top: 8, bottom: 0, left: 16, right: 16),
                  items: [
                    DotNavigationBarItem(
                      icon: DeviceHelper.isMobile(context) ? Padding(
                        padding: EdgeInsets.only(top: 3.h, left: 3),
                        child: SizedBox(
                          height: 14.h,
                          width: 16.w,
                          child: Center(
                            child: ImageUtil.loadSvgImage(
                              height: 14.h,
                              width: 16.w,
                                    imageUrl: selectedIndex == 0
                                        ? imagePath['home_vector'] ?? ""
                                        : imagePath['home_hollow_icon'] ?? "",
                                    context: context,
                              color: selectedIndex == 0
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ): Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: SizedBox(
                          height: 12.h,
                          width: 12.w,
                          child: Center(
                            child: ImageUtil.loadSvgImage(
                              height: 10.h,
                              width: 10.w,
                                    imageUrl: selectedIndex == 0
                                        ? imagePath['home_vector'] ?? ""
                                        : imagePath['home_hollow_icon'] ?? "",
                                    context: context,
                              color: selectedIndex == 0
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      selectedColor: Theme.of(context).indicatorColor,
                    ),
                    DotNavigationBarItem(
                      icon: DeviceHelper.isMobile(context) ? Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: SizedBox(
                          height: 14.h,
                          width: 21.w,
                          child: Center(
                            child: ImageUtil.loadSvgImage(
                              height: selectedIndex == 1 ? 20.h : 13.h,
                              width: selectedIndex == 1 ? 20.w : 12.w,
                                    imageUrl: selectedIndex == 1
                                        ? imagePath['discover_icon'] ?? ""
                                        : imagePath['explore_hollow_icon'] ??
                                            "",
                                    context: context,
                              color: selectedIndex == 1
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ): Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: SizedBox(
                          height: 12.h,
                          width: 12.w,
                          child: Center(
                            child: ImageUtil.loadSvgImage(
                              height: selectedIndex == 1 ? 10.h : 8.h,
                              width: selectedIndex == 1 ? 10.w : 8.w,
                                    imageUrl: selectedIndex == 1
                                        ? imagePath['discover_icon'] ?? ""
                                        : imagePath['explore_hollow_icon'] ??
                                            "",
                                    context: context,
                              color: selectedIndex == 1
                                  ? Theme.of(context).indicatorColor
                                  : Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      selectedColor: Theme.of(context).indicatorColor,
                    ),
                    DotNavigationBarItem(
                      icon: const Icon(Icons.search),
                      selectedColor: Theme.of(context).indicatorColor,
                    ),
                    DotNavigationBarItem(
                      icon: DeviceHelper.isMobile(context) ? Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: SizedBox(
                          height: 14.h,
                          width: 20.w,
                          child: ImageUtil.loadSvgImage(
                            context: context,
                            height: 14.h,
                            width: 15.w,
                            fit: BoxFit.contain,
                                  imageUrl: selectedIndex == 3
                                      ? imagePath['location_icon_selected'] ??
                                          ""
                                      : imagePath['location_icon'] ?? "",
                                  color: selectedIndex == 3
                                ? Theme.of(context).indicatorColor
                                : Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ) : Padding(
                        padding: EdgeInsets.only(top: 1.h),
                        child: SizedBox(
                          height: 11.h,
                          width: 11.w,
                          child: ImageUtil.loadSvgImage(
                            context: context,
                            height: 11.h,
                            width: 12.w,
                            fit: BoxFit.contain,
                            imageUrl: selectedIndex == 3
                                ? imagePath['location_icon_selected'] ??
                                ""
                                : imagePath['location_icon'] ?? "",
                            color: selectedIndex == 3
                                ? Theme.of(context).indicatorColor
                                : Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      selectedColor: Theme.of(context).indicatorColor,
                    ),
                    DotNavigationBarItem(
                      icon: const Icon(Icons.menu),
                      selectedColor: Theme.of(context).indicatorColor,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
