import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/common_widgets/event_card_map.dart';
import 'package:kusel/screens/location/location_screen_provider.dart';
import 'package:kusel/screens/location/location_screen_state.dart';

import '../bottom_sheet_selected_ui_type.dart';

class SelectedEventScreen extends ConsumerStatefulWidget {
  SelectedEventScreen({super.key});

  @override
  ConsumerState<SelectedEventScreen> createState() =>
      _SelectedEventScreenState();
}

class _SelectedEventScreenState extends ConsumerState<SelectedEventScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {
    LocationScreenState state = ref.watch(locationScreenProvider);

    return Column(
      children: [
        16.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                ref
                    .read(locationScreenProvider.notifier)
                    .updateBottomSheetSelectedUIType(
                        BottomSheetSelectedUIType.eventList);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).textTheme.labelMedium!.color,
              ),
            ),
            80.horizontalSpace,
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 5.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: Theme.of(context).textTheme.labelMedium!.color,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        EventCardMap(
          address: state.selectedEvent?.address ?? "",
          websiteText: state.selectedEvent?.website ?? "",
          title: state.selectedEvent?.title ?? "",
          startDate: state.selectedEvent?.startDate ?? "",
          logo: state.selectedEvent?.logo ?? "",
          id: state.selectedEvent?.id ?? 0,
          sourceId: state.selectedEvent?.sourceId ?? 3,
          event: state.selectedEvent!
        )
      ],
    );
  }
}
