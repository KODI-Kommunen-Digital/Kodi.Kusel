import 'package:core/environment/environment_type.dart';
import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/environment/environment_state.dart';

final environmentControllerProvider =
    StateNotifierProvider<EnvironmentController, EnvironmentState>((ref) =>
        EnvironmentController(
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class EnvironmentController extends StateNotifier<EnvironmentState> {
  SharedPreferenceHelper sharedPreferenceHelper;

  EnvironmentController({required this.sharedPreferenceHelper})
      : super(EnvironmentState.empty());

  updateEnvironment(EnvironmentType environmentType) async {
    state = state.copyWith(environmentType: environmentType);
    await sharedPreferenceHelper.setString(
        environmentKey, environmentType.name);
  }
}
