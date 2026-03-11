import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common_widgets/search_widget/search_widget_provider.dart';
import 'dashboard_screen_state.dart';

final dashboardScreenProvider = StateNotifierProvider.autoDispose<
        DashBoardScreenProvider, DashboardScreenState>(
    (ref) => DashBoardScreenProvider(
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
        ref: ref));

class DashBoardScreenProvider extends StateNotifier<DashboardScreenState> {
  SharedPreferenceHelper sharedPreferenceHelper;
  final Ref ref;

  DashBoardScreenProvider(
      {required this.sharedPreferenceHelper, required this.ref})
      : super(DashboardScreenState.empty());

  void onIndexChanged(int index) {
    if (state.selectedIndex != index) {
      ref.read(searchProvider.notifier).clearSearch();
    }

    bool canPop = false;
    if (index == 0) {
      canPop = true;
    }
    state = state.copyWith(selectedIndex: index, canPop: canPop);
  }
  // Handle navigation from any screen that uses SearchWidget
  void onScreenNavigation() {
    ref.read(searchProvider.notifier).clearSearch();
  }
}
