import 'package:domain/model/request_model/municipality/municipility_request_model.dart';
import 'package:domain/model/response_model/municipality/municipality_response_model.dart';
import 'package:domain/usecase/municipality/municipality_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/all_municipality/all_municipality_state.dart';

final allMunicipalityScreenProvider = StateNotifierProvider.autoDispose<
        AllMunicipalityScreenController, AllMunicipalityScreenState>(
    (ref) => AllMunicipalityScreenController(
        municipalityUseCase: ref.read(municipalityUseCaseProvider)));

class AllMunicipalityScreenController
    extends StateNotifier<AllMunicipalityScreenState> {
  MunicipalityUseCase municipalityUseCase;

  AllMunicipalityScreenController({required this.municipalityUseCase})
      : super(AllMunicipalityScreenState.empty());

  Future<void> getAllCitiesByMunicipalityId(int municipalityId) async {
    try {
      state = state.copyWith(isLoading: true);
      MunicipalityRequestModel requestModel =
          MunicipalityRequestModel(municipalityId: municipalityId);

      MunicipalityResponseModel responseModel = MunicipalityResponseModel();
      final result =
          await municipalityUseCase.call(requestModel, responseModel);

      result.fold((l) {
        state = state.copyWith(isLoading: false);
        debugPrint('get municipality fold exception : $l');
      }, (r) async {
        final response = r as MunicipalityResponseModel;
        state = state.copyWith(
          isLoading: false,
          cityList: response.data ?? [],
        );
      });
    } catch (error) {
      state = state.copyWith(isLoading: false);
      debugPrint('get municipality exception : $error');
    }
  }

  void setIsFavoriteCity(bool isFavorite, int? id) {
    for (var city in state.cityList) {
      if (city.id == id) {
        city.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(cityList: state.cityList);
  }
}

class MunicipalityScreenParams {
  int municipalityId;
  Function(bool isFav, int cityId) onFavUpdate;

  MunicipalityScreenParams(
      {required this.municipalityId, required this.onFavUpdate});
}
