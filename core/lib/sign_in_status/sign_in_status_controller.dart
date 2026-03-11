import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInStatusProvider = StateNotifierProvider.autoDispose<
        SignInStatusController, SignInStatusState>(
    (ref) => SignInStatusController(
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider)));

class SignInStatusController extends StateNotifier<SignInStatusState> {
  SharedPreferenceHelper sharedPreferenceHelper;

  SignInStatusController({required this.sharedPreferenceHelper})
      : super(SignInStatusState.empty());

  Future<bool> isUserLoggedIn() async {
    final status = sharedPreferenceHelper.getBool(isUserSignedIn);
    return (status == null) ? false : status;
  }
}
