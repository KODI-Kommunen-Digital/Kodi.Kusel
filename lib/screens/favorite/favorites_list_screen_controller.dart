import 'dart:ui';

import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/favorites/get_favorites_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/favorites/get_favorites_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/providers/refresh_token_provider.dart';

import '../../utility/kusel_date_utils.dart';
import '../new_filter_screen/new_filter_screen_state.dart';
import 'favorites_list_screen_state.dart';

final favoritesListScreenProvider = StateNotifierProvider.autoDispose<
        FavoritesListScreenController, FavoritesListScreenState>(
    (ref) => FavoritesListScreenController(
        getFavoritesUseCaseProvider: ref.read(getFavoritesUseCaseProvider),
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
        tokenStatus: ref.read(tokenStatusProvider),
        refreshTokenUseCase: ref.read(
          refreshTokenUseCaseProvider,
        ),
        localeManagerController: ref.read(localeManagerProvider.notifier),
        refreshTokenProvider: ref.read(refreshTokenProvider),
        signInStatusController: ref.read(signInStatusProvider.notifier)));

class FavoritesListScreenController
    extends StateNotifier<FavoritesListScreenState> {
  FavoritesListScreenController(
      {required this.getFavoritesUseCaseProvider,
      required this.sharedPreferenceHelper,
      required this.tokenStatus,
      required this.refreshTokenUseCase,
      required this.localeManagerController,
      required this.refreshTokenProvider,
      required this.signInStatusController})
      : super(FavoritesListScreenState.empty());

  RefreshTokenProvider refreshTokenProvider;
  GetFavoritesUseCase getFavoritesUseCaseProvider;
  SharedPreferenceHelper sharedPreferenceHelper;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;
  LocaleManagerController localeManagerController;
  SignInStatusController signInStatusController;

  Future<void> getFavoritesList(int pageNumber, {int? pageSize=19}) async {
    try {
      state = state.copyWith(loading: true, error: "");

      final response = tokenStatus.isAccessTokenExpired();
      final isUserLoggedIn = await signInStatusController.isUserLoggedIn();

      if (response && isUserLoggedIn) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () async {
              await _getFav(pageNumber, pageSize: pageSize);
            });
      } else {
        await _getFav(pageNumber, pageSize: pageSize);
      }
    } catch (error) {
      debugPrint('get Fav exception : $error');
      state = state.copyWith(error: error.toString());
    } finally {
      state = state.copyWith(loading: false, error: "");
    }
  }

  Future<void> _getFav(int pageNumber, {int? pageSize}) async {
    try {
      state = state.copyWith(list: (pageNumber == 1) ? [] : state.eventsList);
      Locale currentLocale = localeManagerController.getSelectedLocale();

      String categoryId = "";

      for (int item in state.selectedCategoryIdList) {
        categoryId = "$categoryId$item,";
      }

      String? startDate =
          KuselDateUtils.checkDatesAreSame(state.startDate, defaultDate)
              ? null
              : KuselDateUtils.formatDateInFormatYYYYMMDD(
                  state.startDate.toString());

      String? endDate = KuselDateUtils.checkDatesAreSame(
              state.endDate, defaultDate)
          ? null
          : KuselDateUtils.formatDateInFormatYYYYMMDD(state.endDate.toString());

      GetFavoritesRequestModel getAllListingsRequestModel =
          GetFavoritesRequestModel(
        translate: "${currentLocale.languageCode}-${currentLocale.countryCode}",
        startAfterDate: startDate,
        endBeforeDate: endDate,
        pageNo: pageNumber,
        pageSize: pageSize,
        categoryId: categoryId.isEmpty
            ? null
            : categoryId.substring(0, categoryId.length - 1),
        cityId:
            state.selectedCityId == 0 ? null : state.selectedCityId.toString(),
        sortByStartDate: true,
        radius: state.radius == 0 ? null : state.radius.toInt(),
      );
      GetAllListingsResponseModel getAllListResponseModel =
          GetAllListingsResponseModel();

      final result = await getFavoritesUseCaseProvider.call(
          getAllListingsRequestModel, getAllListResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(error: l.toString());
        },
        (r) {
          final eventsList = (r as GetAllListingsResponseModel).data;
          state = state.copyWith(list: eventsList);
          numberOfFiltersApplied();
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> getLoadMoreList(int pageNumber, {int? pageSize}) async {
    try {
      state = state.copyWith(isPaginationLoading: true, error: "");

      final response = tokenStatus.isAccessTokenExpired();

      if (response) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () async {
              await _getLoadMoreList(pageNumber, pageSize);
            });
      } else {
        await _getLoadMoreList(pageNumber, pageSize);
      }
    } catch (error) {
      debugPrint('get Fav exception : $error');
      state = state.copyWith(error: error.toString());
    } finally {
      state = state.copyWith(isPaginationLoading: false, error: "");
    }
  }

  Future<void> _getLoadMoreList(int pageNumber, int? pageSize) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      String categoryId = "";

      for (int item in state.selectedCategoryIdList) {
        categoryId = "$categoryId$item,";
      }

      String? startDate =
          KuselDateUtils.checkDatesAreSame(state.startDate, defaultDate)
              ? null
              : KuselDateUtils.formatDateInFormatYYYYMMDD(
                  state.startDate.toString());

      String? endDate = KuselDateUtils.checkDatesAreSame(
              state.endDate, defaultDate)
          ? null
          : KuselDateUtils.formatDateInFormatYYYYMMDD(state.endDate.toString());

      GetFavoritesRequestModel getAllListingsRequestModel =
          GetFavoritesRequestModel(
        translate: "${currentLocale.languageCode}-${currentLocale.countryCode}",
        startAfterDate: startDate,
        endBeforeDate: endDate,
        pageNo: pageNumber,
        pageSize: pageSize,
        categoryId: categoryId.isEmpty
            ? null
            : categoryId.substring(0, categoryId.length - 1),
        cityId:
            state.selectedCityId == 0 ? null : state.selectedCityId.toString(),
        sortByStartDate: true,
        radius: state.radius == 0 ? null : state.radius.toInt(),
      );
      GetAllListingsResponseModel getAllListResponseModel =
          GetAllListingsResponseModel();

      final result = await getFavoritesUseCaseProvider.call(
          getAllListingsRequestModel, getAllListResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(error: l.toString());
        },
        (r) {
          final eventsList = (r as GetAllListingsResponseModel).data;
          if (eventsList != null) {
            final list = state.eventsList;

            if (eventsList.isNotEmpty) {
              list.addAll(eventsList);
              state = state.copyWith(list: list, pageNumber: pageNumber);
            }
          }
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  void removeFavorite(int? id) {
    if (id == null) return;

    final updatedList =
        state.eventsList.where((listing) => listing.id != id).toList();
    state = state.copyWith(
      list: updatedList,
    );
  }

  applyNewFilterValues(
      List<String> categoryNameList,
      int cityId,
      String cityName,
      double radius,
      DateTime startDate,
      DateTime endDate,
      List<int> categoryIdList) async {
    state = state.copyWith(
        selectedCategoryNameList: categoryNameList,
        selectedCityName: cityName,
        selectedCityId: cityId,
        radius: radius,
        startDate: startDate,
        endDate: endDate,
        selectedCategoryIdList: categoryIdList);
  }

  void numberOfFiltersApplied() {
    int len = 0;

    if (state.selectedCategoryIdList.isNotEmpty) {
      len += state.selectedCategoryIdList.length;
    }

    if (state.selectedCityId != 0) {
      len += 1;
    }

    if (!KuselDateUtils.checkDatesAreSame(state.startDate, defaultDate)) {
      len += 1;
    }

    if (state.radius != 0) {
      len += 1;
    }

    state = state.copyWith(numberOfFiltersApplied: len);
  }
}
