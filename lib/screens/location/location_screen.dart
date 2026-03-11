import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/app_router.dart';
import 'package:kusel/common_widgets/location_const.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/navigation/navigation.dart';
import 'package:kusel/screens/event/event_detail_screen_controller.dart';
import 'package:kusel/screens/location/bottom_sheet_screens/selected_filter_screen.dart';
import 'package:kusel/screens/location/location_screen_state.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../common_widgets/custom_map_marker.dart';
import '../../common_widgets/map_widget/custom_flutter_map.dart';
import 'bottom_sheet_screens/all_filter_screen.dart';
import 'bottom_sheet_screens/selected_event_screen.dart';
import 'bottom_sheet_selected_ui_type.dart';
import 'location_screen_provider.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});

  @override
  ConsumerState<LocationScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<LocationScreen> {
  final ScrollController _innerScrollController = ScrollController();

  @override
  void initState() {
    _innerScrollController.addListener(_handleScroll);
    Future.microtask(() {
      final controller = ref.read(locationScreenProvider.notifier);

      controller.isUserLoggedIn();
      controller.getPoiCoordinates();
    });
    MatomoService.trackLocationScreenViewed();
    super.initState();
  }

  void _handleScroll() {
    if (_innerScrollController.hasClients) {
      final offset = _innerScrollController.offset;
      final isAtTop =
          offset <= _innerScrollController.position.minScrollExtent + 1;
      final currentDragStatus =
          ref
              .read(locationScreenProvider)
              .isSlidingUpPanelDragAllowed;
      if (currentDragStatus != isAtTop) {
        ref
            .read(locationScreenProvider.notifier)
            .updateSlidingUpPanelIsDragStatus(isAtTop);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBody(context),
          Positioned(
            bottom: 0,
            left: 1,
            right: 1,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  height: 80.h,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
    );
  }

  _buildBody(BuildContext context) {
    final state = ref.watch(locationScreenProvider);
    final controller = ref.read(locationScreenProvider.notifier);

    return SafeArea(
      child: SlidingUpPanel(
        isDraggable:
        ref
            .watch(locationScreenProvider)
            .isSlidingUpPanelDragAllowed,
        minHeight: 245.h,
        maxHeight: _getMaxHeight(
            ref
                .watch(locationScreenProvider)
                .bottomSheetSelectedUIType),
        defaultPanelState: PanelState.CLOSED,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
        controller: ref
            .read(locationScreenProvider)
            .panelController,
        body: Stack(
          children: [
            CustomFlutterMap(
              latitude: EventLatLong.kusel.latitude,
              longitude: EventLatLong.kusel.longitude,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              initialZoom: 12.0,
              onMapTap: () {},
              markersList: state.poiCoordinatesItemList
                  .where((value) =>
              value.latitude != null && value.longitude != null)
                  .map((value) {
                final lat = value.latitude!;
                final long = value.longitude!;
                final categoryId = value.categoryId;
                final categoryName = '';
                return Marker(
                  width: 35.w,
                  height: 35.h,
                  point: LatLng(lat, long),
                  child: InkWell(
                    onTap: () {
                      ref.read(navigationProvider).navigateUsingPath(
                          path: eventDetailScreenPath, context: context,
                      params: EventDetailScreenParams(eventId: value.id??0));
                    },
                    child: CustomMapMarker(categoryId: categoryId),
                  ),
                );
              }).toList(),
            )
          ],
        ),
        panelBuilder: (controller) {
          return ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
              child: Container(
                color: Colors.transparent,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) =>
                      FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                  child: getBottomSheetUI(
                    ref
                        .watch(locationScreenProvider)
                        .bottomSheetSelectedUIType,
                  ),
                ),
              ));
        },
      ),
    );
  }

  getBottomSheetUI(BottomSheetSelectedUIType type,) {
    late Widget widget;
    LocationScreenState locationScreenState = ref.watch(locationScreenProvider);
    switch (type) {
      case BottomSheetSelectedUIType.eventList:
        widget = SelectedFilterScreen(
          selectedFilterScreenParams: SelectedFilterScreenParams(
              categoryId: locationScreenState.selectedCategoryId ?? 0),
          scrollController: _innerScrollController,
        );
        break;
      case BottomSheetSelectedUIType.eventDetail:
        widget = SelectedEventScreen();
        break;
      default:
        widget = AllFilterScreen(
          scrollController: _innerScrollController,
        );
        break;
    }
    return widget;
  }
}

double _getMaxHeight(BottomSheetSelectedUIType type) {
  switch (type) {
    case BottomSheetSelectedUIType.allEvent:
      return 365.h;

    case BottomSheetSelectedUIType.eventDetail:
      return 600.h;

    case BottomSheetSelectedUIType.eventList:
      return 600.h;
  }
}
