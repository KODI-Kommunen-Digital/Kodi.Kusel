import 'package:domain/model/request_model/participate/participate_request_model.dart';
import 'package:domain/model/response_model/participate/participate_response_model.dart';
import 'package:domain/usecase/participate/participate_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/participate_screen/participate_screen_state.dart';

final participateScreenProvider = StateNotifierProvider.autoDispose<
        ParticipateScreenProvider, ParticipateScreenState>(
    (ref) => ParticipateScreenProvider(
        participateUseCase: ref.read(participateUseCaseProvider),
        localeManagerController: ref.read(localeManagerProvider.notifier)));

class ParticipateScreenProvider extends StateNotifier<ParticipateScreenState> {
  ParticipateUseCase participateUseCase;
  LocaleManagerController localeManagerController;

  ParticipateScreenProvider(
      {required this.participateUseCase, required this.localeManagerController})
      : super(ParticipateScreenState.empty());

  Future<void> fetchParticipateDetails() async {
    try {
      state = state.copyWith(isLoading: true);

      Locale currentLocale = localeManagerController.getSelectedLocale();

      ParticipateRequestModel requestModel = ParticipateRequestModel(
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      ParticipateResponseModel responseModel = ParticipateResponseModel();

      final response =
          await participateUseCase.call(requestModel, responseModel);

      response.fold((l) {
        state = state.copyWith(isLoading: false);
        debugPrint("Participate fold exception = ${l.toString()}");
      }, (r) {
        final result = r as ParticipateResponseModel;
        if (result.data != null) {
          state = state.copyWith(
            participateData: result.data,
            isLoading: false,
          );
        }
      });
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint("Participate Ort exception = $e");
    }
  }
}
