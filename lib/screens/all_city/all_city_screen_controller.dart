import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/city_details/get_city_details_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/city_details/get_city_details_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/city_details/get_city_details_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/all_city/all_city_screen_state.dart';

final allCityScreenProvider = StateNotifierProvider.autoDispose<
        AllCityScreenController, AllCityScreenState>(
    (ref) => AllCityScreenController(
        getCityDetailsUseCase: ref.read(getCityDetailsUseCaseProvider),
      sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
      tokenStatus: ref.read(tokenStatusProvider),
      refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
      signInStatusController: ref.read(signInStatusProvider.notifier)
    ));

class AllCityScreenController extends StateNotifier<AllCityScreenState> {
  GetCityDetailsUseCase getCityDetailsUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;
  SignInStatusController signInStatusController;

  AllCityScreenController({
    required this.getCityDetailsUseCase,
    required this.sharedPreferenceHelper,
    required this.tokenStatus,
    required this.refreshTokenUseCase,
    required this.signInStatusController
  })
      : super(AllCityScreenState.empty());

  Future<void> fetchCities() async {
    try {
      state = state.copyWith(isLoading: true);
      final response = tokenStatus.isAccessTokenExpired();
      debugPrint(' = $response');
      final status = await signInStatusController.isUserLoggedIn();
      if (response&& status) {
        RefreshTokenRequestModel requestModel =
        RefreshTokenRequestModel();
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

        final refreshResponse =
        await refreshTokenUseCase.call(requestModel, responseModel);

        bool refreshSuccess = await refreshResponse.fold(
              (left) {
            debugPrint('refresh token add fav city fold exception : $left');
            return false;
          },
              (right) async {
            final res = right as RefreshTokenResponseModel;
            sharedPreferenceHelper.setString(
                tokenKey, res.data?.accessToken ?? "");
            sharedPreferenceHelper.setString(
                refreshTokenKey, res.data?.refreshToken ?? "");
            return true;
          },
        );

        if (!refreshSuccess) {
          state = state.copyWith(isLoading: false);
          return;
        }
      }

      GetCityDetailsRequestModel requestModel =
      GetCityDetailsRequestModel(hasForum: false);
      GetCityDetailsResponseModel responseModel = GetCityDetailsResponseModel();
      final result =
      await getCityDetailsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get city details fold exception : $l');
      }, (r) async {
        final response = r as GetCityDetailsResponseModel;
        state = state.copyWith(
          cityList: response.data,
          isLoading: false
        );
      });
    } catch (error) {
      debugPrint('get city details exception : $error');
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

class AllCityScreenParams {
  Function(bool? isFav, int? id) onFavSuccess;

  AllCityScreenParams({required this.onFavSuccess});

}
