import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/favorites/add_favorites_request_model.dart';
import 'package:domain/model/request_model/favorites/delete_favorites_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/favorites/get_favorites_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/favorites/add_favorite_usecase.dart';
import 'package:domain/usecase/favorites/delete_favorite_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/matomo_api.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesListNotifier, List<Listing>>(
  (ref) => FavoritesListNotifier(
    addFavoriteUseCase: ref.read(addFavoritesUseCaseProvider),
    deleteFavoriteUsecase: ref.read(deleteFavoritesUseCaseProvider),
    sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
    tokenStatus: ref.read(tokenStatusProvider),
    refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
      localeManagerController: ref.read(localeManagerProvider.notifier)
  ),
);

class FavoritesListNotifier extends StateNotifier<List<Listing>> {
  SharedPreferenceHelper sharedPreferenceHelper;
  AddFavoriteUseCase addFavoriteUseCase;
  DeleteFavoriteUsecase deleteFavoriteUsecase;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;
  LocaleManagerController localeManagerController;

  FavoritesListNotifier(
      {required this.addFavoriteUseCase,
      required this.deleteFavoriteUsecase,
      required this.sharedPreferenceHelper,
      required this.tokenStatus,
      required this.refreshTokenUseCase,
      required this.localeManagerController
      })
      : super([]);

  Future<void> addFavorite(
      Listing item, void Function({required bool isFavorite}) success) async {
    try {
      final response = tokenStatus.isAccessTokenExpired();

      if (response) {

        RefreshTokenRequestModel requestModel =
            RefreshTokenRequestModel();
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

        final response =
            await refreshTokenUseCase.call(requestModel, responseModel);

        response.fold((left) {
          debugPrint('refresh token add fav fold exception : $left');
        }, (right) async {
          final res = right as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");

          Locale currentLocale = localeManagerController.getSelectedLocale();

          AddFavoritesRequestModel getFavoritesRequestModel =
              AddFavoritesRequestModel(
                  cityId: item.cityId.toString(),
                  listingId: item.id.toString(),
                  translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}"
              );

          GetFavoritesResponseModel getFavoritesResponseModel =
              GetFavoritesResponseModel();

          final result = await addFavoriteUseCase.call(
              getFavoritesRequestModel, getFavoritesResponseModel);
          result.fold(
            (l) {
              debugPrint('add fav fold exception : $l');
            },
            (r) {
              MatomoService.trackFavouriteAdded(
                  userId: sharedPreferenceHelper.getInt(userIdKey).toString());
              success(isFavorite: true);
            },
          );
        });
      } else {
        AddFavoritesRequestModel getFavoritesRequestModel =
            AddFavoritesRequestModel(
                cityId: item.cityId.toString(),
                listingId: item.id.toString());

        GetFavoritesResponseModel getFavoritesResponseModel =
            GetFavoritesResponseModel();

        final result = await addFavoriteUseCase.call(
            getFavoritesRequestModel, getFavoritesResponseModel);
        result.fold(
          (l) {
            debugPrint('add fav fold exception : $l');
          },
          (r) {
            MatomoService.trackFavouriteAdded(
                userId: sharedPreferenceHelper.getInt(userIdKey).toString());
            success(isFavorite: true);
          },
        );
      }
    } catch (error) {
      debugPrint("add fav exception: $error");
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
          debugPrint('remove fav refresh token fold exception : $l');
        }, (r) async {
          final res = r as RefreshTokenResponseModel;
          sharedPreferenceHelper.setString(
              tokenKey, res.data?.accessToken ?? "");
          sharedPreferenceHelper.setString(
              refreshTokenKey, res.data?.refreshToken ?? "");

          DeleteFavoritesRequestModel getFavoritesRequestModel =
              DeleteFavoritesRequestModel(
                  id: id);
          GetFavoritesResponseModel getFavoritesResponseModel =
              GetFavoritesResponseModel();
          final result = await deleteFavoriteUsecase.call(
              getFavoritesRequestModel, getFavoritesResponseModel);
          result.fold(
            (l) {
              debugPrint("delete fav fold exception  = ${l.toString()}");
              error(message: l.toString());
            },
            (r) {
              MatomoService.trackFavouriteRemoved(
                  userId: sharedPreferenceHelper.getInt(userIdKey).toString());
              success(isFavorite: false);
            },
          );
        });
      } else {
        DeleteFavoritesRequestModel getFavoritesRequestModel =
            DeleteFavoritesRequestModel(
                id: id);
        GetFavoritesResponseModel getFavoritesResponseModel =
            GetFavoritesResponseModel();
        final result = await deleteFavoriteUsecase.call(
            getFavoritesRequestModel, getFavoritesResponseModel);
        result.fold(
          (l) {
            debugPrint("delete fav fold exception  = ${l.toString()}");
            error(message: l.toString());
          },
          (r) {
            MatomoService.trackFavouriteRemoved(
                userId: sharedPreferenceHelper.getInt(userIdKey).toString());
            success(isFavorite: false);
          },
        );
      }
    } catch (e) {
      debugPrint("remove fav exception:  ${e.toString()}");
      error(message: e.toString());
    }
  }

  void toggleFavorite(Listing item,
      {required void Function({required bool isFavorite}) success,
      required void Function({required String message}) error}) {
    if (item.isFavorite ?? false) {
      removeFavorite(item.id ?? 0, success, error);
    } else {
      addFavorite(item, success);
    }
  }

  bool showFavoriteIcon() {
    final token = sharedPreferenceHelper.getString(tokenKey);
    return token != null;
  }
}
