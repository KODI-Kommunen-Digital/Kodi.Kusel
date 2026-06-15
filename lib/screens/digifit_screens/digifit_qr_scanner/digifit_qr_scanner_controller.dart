import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/matomo_api.dart';
import 'package:kusel/screens/digifit_screens/digifit_qr_scanner/digifit_qr_scanner_state.dart';

final digifitQrScannerControllerProvider = StateNotifierProvider.autoDispose<
    DigifitQrScannerController, DigifitQrScannerState>(
  (ref) => DigifitQrScannerController(
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
  ),
);

class DigifitQrScannerController extends StateNotifier<DigifitQrScannerState> {
  final SharedPreferenceHelper sharedPreferenceHelper;

  DigifitQrScannerController({required this.sharedPreferenceHelper})
      : super(DigifitQrScannerState.initial());

  void trackCodeScanned() {
    MatomoService.trackQrScanned(userId: sharedPreferenceHelper.getInt(userIdKey).toString());
  }
}
