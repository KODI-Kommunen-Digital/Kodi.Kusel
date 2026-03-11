import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/favourite_city/add_favourite_city_request_model.dart';
import 'package:domain/model/request_model/favourite_city/delete_favourite_city_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/explore_details/explore_details_response_model.dart';
import 'package:domain/model/response_model/favourite_city/add_favourite_city_response_model.dart';
import 'package:domain/model/response_model/favourite_city/delete_favourite_city_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/favourite_city/modify_favourite_city_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favouriteCitiesNotifier =
    StateNotifierProvider<CityFavoritesNotifier, List<City>>(
  (ref) => CityFavoritesNotifier(
    addFavouriteCityUseCase: ref.read(addFavouriteCityUseCaseProvider),
    deleteFavouriteCityUseCase: ref.read(deleteFavouriteCityUseCaseProvider),
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
    tokenStatus: ref.read(tokenStatusProvider),
    refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
  ),
);

class CityFavoritesNotifier extends StateNotifier<List<City>> {
  SharedPreferenceHelper sharedPreferenceHelper;
  AddFavouriteCityUseCase addFavouriteCityUseCase;
  DeleteFavouriteCityUseCase deleteFavouriteCityUseCase;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;

  CityFavoritesNotifier(
      {required this.addFavouriteCityUseCase,
      required this.deleteFavouriteCityUseCase,
      required this.sharedPreferenceHelper,
      required this.tokenStatus,
      required this.refreshTokenUseCase})
      : super([]);

  Future<void> addFavorite(
      int cityId, void Function({required bool isFavorite}) success) async {
    try {
      final response = tokenStatus.isAccessTokenExpired();

      if (response) {

        RefreshTokenRequestModel requestModel =
            RefreshTokenRequestModel();
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

        final response =
            await refreshTokenUseCase.call(requestModel, responseModel);

        response.fold((left) {
          debugPrint('refresh token add fav city fold exception : $left');
        }, (right) async {
          final res = right as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");

          AddFavouriteCityRequestModel requestModel =
              AddFavouriteCityRequestModel(cityId: cityId.toString());

          AddFavouriteCityResponseModel responseModel =
              AddFavouriteCityResponseModel();

          final result =
              await addFavouriteCityUseCase.call(requestModel, responseModel);
          result.fold(
            (l) {
              debugPrint('add fav city fold exception : $l');
            },
            (r) {
              success(isFavorite: true);
            },
          );
        });
      } else {
        AddFavouriteCityRequestModel requestModel =
            AddFavouriteCityRequestModel(cityId: cityId.toString());

        AddFavouriteCityResponseModel responseModel =
            AddFavouriteCityResponseModel();

        final result =
            await addFavouriteCityUseCase.call(requestModel, responseModel);
        result.fold(
          (l) {
            debugPrint('add fav city fold exception : $l');
          },
          (r) {
            success(isFavorite: true);
          },
        );
      }
    } catch (error) {
      debugPrint("add fav city exception: $error");
    }
  }

  Future<void> removeFavorite(
      int id,
      void Function({required bool isFavorite}) success,
      void Function({required String message}) error) async {
    try {
      final response = tokenStatus.isAccessTokenExpired();

      if (response) {

        RefreshTokenRequestModel requestModel =
            RefreshTokenRequestModel();
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

        final response =
            await refreshTokenUseCase.call(requestModel, responseModel);

        response.fold((l) {
          debugPrint('remove fav city refresh token fold exception : $l');
        }, (r) async {
          final res = r as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");

          DeleteFavouriteCityRequestModel requestModel =
              DeleteFavouriteCityRequestModel(cityId: id);
          DeleteFavouriteCityResponseModel responseModel =
              DeleteFavouriteCityResponseModel();
          final result = await deleteFavouriteCityUseCase.call(
              requestModel, responseModel);
          result.fold(
            (l) {
              debugPrint("delete fav city fold exception  = ${l.toString()}");
              error(message: l.toString());
            },
            (r) {
              success(isFavorite: false);
            },
          );
        });
      } else {

        DeleteFavouriteCityRequestModel requestModel =
            DeleteFavouriteCityRequestModel(cityId: id);
        DeleteFavouriteCityResponseModel responseModel =
            DeleteFavouriteCityResponseModel();
        final result =
            await deleteFavouriteCityUseCase.call(requestModel, responseModel);
        result.fold(
          (l) {
            debugPrint("delete fav city fold exception  = ${l.toString()}");
            error(message: l.toString());
          },
          (r) {
            success(isFavorite: false);
          },
        );
      }
    } catch (e) {
      debugPrint("remove fav city exception:  ${e.toString()}");
      error(message: e.toString());
    }
  }

  void toggleFavorite(
      {required bool? isFavourite,
      required int? id,
      required void Function({required bool isFavorite}) success,
      required void Function({required String message}) error}) {
    if (isFavourite ?? false) {
      removeFavorite(id ?? 0, success, error);
    } else {
      addFavorite(id ?? 0, success);
    }
  }


}
