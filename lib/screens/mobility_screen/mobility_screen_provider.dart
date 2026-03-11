import 'package:domain/model/request_model/mobility/mobility_request_model.dart';
import 'package:domain/model/response_model/mobility/mobility_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/mobility_screen/mobility_screen_state.dart';
import 'package:domain/usecase/mobility/mobility_usecase.dart';

final mobilityScreenProvider = StateNotifierProvider.autoDispose<
        MobilityScreenProvider, MobilityScreenState>(
    (ref) => MobilityScreenProvider(
        mobilityUseCase: ref.read(mobilityUseCaseProvider),
        localeManagerController: ref.read(localeManagerProvider.notifier)));

class MobilityScreenProvider extends StateNotifier<MobilityScreenState> {
  MobilityUseCase mobilityUseCase;
  LocaleManagerController localeManagerController;

  MobilityScreenProvider(
      {required this.mobilityUseCase, required this.localeManagerController})
      : super(MobilityScreenState.empty());

  Future<void> fetchMobilityDetails() async {
    try {
      state = state.copyWith(isLoading: true);

      Locale currentLocale = localeManagerController.getSelectedLocale();
      MobilityRequestModel requestModel = MobilityRequestModel(
          translate: "${currentLocale.languageCode}-${currentLocale.countryCode}"
      );
      MobilityResponseModel responseModel = MobilityResponseModel();

      final response = await mobilityUseCase.call(requestModel, responseModel);

      response.fold((l) {
        state = state.copyWith(isLoading: false);
        debugPrint("Mobility fold exception = ${l.toString()}");
      }, (r) {
        final result = r as MobilityResponseModel;
        if (result.data != null) {
          state = state.copyWith(
            mobilityData: result.data,
            isLoading: false,
          );
        }
      });
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint("Mobility Ort exception = $e");
    }
  }
}
