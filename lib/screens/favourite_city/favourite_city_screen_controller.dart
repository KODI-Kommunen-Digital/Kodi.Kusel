import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/model/request_model/favourite_city/favourite_city_request_model.dart';
import 'package:domain/model/response_model/favourite_city/favourite_city_response_model.dart';
import 'package:domain/usecase/favourite_city/get_favourite_cities_usecase.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/providers/refresh_token_provider.dart';
import 'package:kusel/screens/favourite_city/favourite_city_state.dart';

final favouriteCityScreenProvider = StateNotifierProvider.autoDispose<
        FavouriteCityScreenController, FavouriteCityScreenState>(
    (ref) => FavouriteCityScreenController(
          getFavouriteCitiesUseCase:
              ref.read(getFavouriteCitiesUseCaseProvider),
          sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
          tokenStatus: ref.read(tokenStatusProvider),
          refreshTokenProvider: ref.read(refreshTokenProvider),
          localeManagerController: ref.read(localeManagerProvider.notifier),
        ));

class FavouriteCityScreenController
    extends StateNotifier<FavouriteCityScreenState> {
  GetFavouriteCitiesUseCase getFavouriteCitiesUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  TokenStatus tokenStatus;
  RefreshTokenProvider refreshTokenProvider;
  LocaleManagerController localeManagerController;

  FavouriteCityScreenController(
      {required this.getFavouriteCitiesUseCase,
      required this.sharedPreferenceHelper,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.localeManagerController})
      : super(FavouriteCityScreenState.empty());

  fetchFavouriteCities(int pageNumber, {int pageSize = 19}) async {
    try {

      final status = tokenStatus.isAccessTokenExpired();

      if (status) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () async{
              await _fetchFavouriteCities(pageNumber, pageSize);
            });
      } else {
        await _fetchFavouriteCities(pageNumber, pageSize);
      }
    } catch (error) {
      debugPrint("add fav city exception: $error");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _fetchFavouriteCities(int pageNumber, int pageSize) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();
      final translate =
          "${currentLocale.languageCode}-${currentLocale.countryCode}";

      GetFavouriteCitiesRequestModel requestModel =
      GetFavouriteCitiesRequestModel(
          translate: translate, pageNo: pageNumber, pageSize: pageSize);

      GetFavouriteCitiesResponseModel responseModel =
          GetFavouriteCitiesResponseModel();

      final result =
          await getFavouriteCitiesUseCase.call(requestModel, responseModel);
      result.fold(
        (l) {
          state = state.copyWith(isLoading: false);
          debugPrint('add fav city fold exception : $l');
        },
        (r) {
          final result = r as GetFavouriteCitiesResponseModel;
          state = state.copyWith(cityList: result.data);
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  fetchLoadMoreFavouriteCities(int pageNumber, {int pageSize = 9}) async {
    try {
      state = state.copyWith(isNextPageLoading: true);

      final status = tokenStatus.isAccessTokenExpired();

      if (status) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () {
              _fetchLoadMoreFavouriteCities(pageNumber, pageSize);
            });
      } else {
        _fetchLoadMoreFavouriteCities(pageNumber, pageSize);
      }
    } catch (error) {
      debugPrint("add fav city exception: $error");
    } finally {
      state = state.copyWith(isNextPageLoading: false);
    }
  }

  Future<void> _fetchLoadMoreFavouriteCities(
      int pageNumber, int pageSize) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();
      final translate =
          "${currentLocale.languageCode}-${currentLocale.countryCode}";

      GetFavouriteCitiesRequestModel requestModel =
          GetFavouriteCitiesRequestModel(
              translate: translate, pageNo: pageNumber, pageSize: pageSize);

      GetFavouriteCitiesResponseModel responseModel =
          GetFavouriteCitiesResponseModel();

      final result =
          await getFavouriteCitiesUseCase.call(requestModel, responseModel);
      result.fold(
        (l) {
          state = state.copyWith(isLoading: false);
          debugPrint('add fav city fold exception : $l');
        },
        (r) {
          final result = r as GetFavouriteCitiesResponseModel;

          if (result.data != null && result.data!.isNotEmpty) {
            final list = state.cityList;

            list.addAll(result.data!);

            state = state.copyWith(cityList: list, pageNumber: pageNumber);
          }
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeFav(int? id) async {
    if (id == null) return;

    final updatedList =
        state.cityList.where((element) => element.id != id).toList();
    state = state.copyWith(cityList: updatedList);
  }
}
