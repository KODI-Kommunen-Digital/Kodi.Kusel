import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/no_network/network_status_screen_state.dart';
import 'package:kusel/utility/network_utils.dart';

final networkStatusProvider =
    StateNotifierProvider<NetworkStatusProvider, NetworkStatusState>(
        (ref) => NetworkStatusProvider());

class NetworkStatusProvider extends StateNotifier<NetworkStatusState> {
  NetworkStatusProvider() : super(NetworkStatusState.empty());

  Future<bool> checkNetworkStatus() async {
    bool isNetworkAvailable = await NetworkUtils.hasInternetConnection();
    state = state.copyWith(isNetworkAvailable: isNetworkAvailable);
    return isNetworkAvailable;
  }

  updateNetworkStatus(bool value) {
    state = state.copyWith(isNetworkAvailable: value);
  }
}
