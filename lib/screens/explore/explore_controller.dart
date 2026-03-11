import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/explore/explore_state.dart';

final exploreControllerProvider =
    StateNotifierProvider.autoDispose<ExploreController, ExploreState>((ref) =>
        ExploreController(
            signInStatusController: ref.read(signInStatusProvider.notifier)));

class ExploreController extends StateNotifier<ExploreState> {
  SignInStatusController signInStatusController;

  ExploreController({required this.signInStatusController})
      : super(ExploreState.empty());

  Future<bool> isLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    return status;
  }
}
