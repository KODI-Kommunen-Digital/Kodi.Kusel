import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/municipal_party_detail/municipal_party_detail_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/explore_details/explore_details_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/city_details/get_city_details_usecase.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/municipal_party_detail/municipal_party_detail_use_case.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:kusel/locale/localization_manager.dart';

import 'municipal_detail_state.dart';

final municipalDetailControllerProvider = StateNotifierProvider.autoDispose<
        MunicipalDetailController, MunicipalDetailState>(
    (ref) => MunicipalDetailController(
          listingsUseCase: ref.read(listingsUseCaseProvider),
          municipalPartyDetailUseCase:
              ref.read(municipalPartyDetailUseCaseProvider),
          getCityDetailsUseCase: ref.read(getCityDetailsUseCaseProvider),
          signInStatusController: ref.read(signInStatusProvider.notifier),
          sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
          tokenStatus: ref.read(tokenStatusProvider),
          refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
          localeManagerController: ref.read(localeManagerProvider.notifier),
        ));

class MunicipalDetailController extends StateNotifier<MunicipalDetailState> {
  ListingsUseCase listingsUseCase;
  MunicipalPartyDetailUseCase municipalPartyDetailUseCase;
  GetCityDetailsUseCase getCityDetailsUseCase;
  SignInStatusController signInStatusController;
  SharedPreferenceHelper sharedPreferenceHelper;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;
  LocaleManagerController localeManagerController;

  MunicipalDetailController(
      {required this.listingsUseCase,
      required this.municipalPartyDetailUseCase,
      required this.getCityDetailsUseCase,
      required this.signInStatusController,
      required this.sharedPreferenceHelper,
      required this.tokenStatus,
      required this.refreshTokenUseCase,
      required this.localeManagerController})
      : super(MunicipalDetailState.empty());

  getEventsUsingCityId({required String municipalId}) async {
    try {
      state = state.copyWith(showEventLoading: true);

      Locale currentLocale = localeManagerController.getSelectedLocale();

      final id = municipalId;
      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel(
          cityId: id,
          categoryId: ListingCategoryId.event.eventId.toString(),
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((l) {
        state = state.copyWith(showEventLoading: false);
        debugPrint("getEventsUsingCityId fold exception = ${l.toString()}");
      }, (r) {
        final result = r as GetAllListingsResponseModel;

        state = state.copyWith(eventList: result.data, showEventLoading: false);
      });
    } catch (e) {
      state = state.copyWith(showEventLoading: false);
      debugPrint("getEventsUsingCityId exception = $e");
    }
  }

  getNewsUsingCityId({required String municipalId}) async {
    try {
      state = state.copyWith(showNewsLoading: true);
      Locale currentLocale = localeManagerController.getSelectedLocale();

      final id = municipalId;
      final categoryId = ListingCategoryId.news.eventId.toString();
      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel(
          cityId: id,
          categoryId: categoryId,
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((l) {
        state = state.copyWith(showNewsLoading: false);
        debugPrint("getNewsUsingCityId fold exception = ${l.toString()}");
      }, (r) {
        final result = r as GetAllListingsResponseModel;

        state = state.copyWith(newsList: result.data, showNewsLoading: false);
      });
    } catch (e) {
      state = state.copyWith(showNewsLoading: false);
      debugPrint("getNewsUsingCityId exception = $e");
    }
  }

  getMunicipalPartyDetailUsingId({required String id}) async {
    try {
      state = state.copyWith(isLoading: true);
      final status = await signInStatusController.isUserLoggedIn();
      Locale currentLocale = localeManagerController.getSelectedLocale();

      final response = tokenStatus.isAccessTokenExpired();
      if (response && status) {
        RefreshTokenRequestModel requestModel =
            RefreshTokenRequestModel();
        RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

        final refreshResponse =
            await refreshTokenUseCase.call(requestModel, responseModel);

        bool refreshSuccess = await refreshResponse.fold(
          (left) {
            debugPrint(
                'refresh token municipality detail fold exception : $left');
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
      MunicipalPartyDetailRequestModel requestModel =
          MunicipalPartyDetailRequestModel(
              municipalId: id,
              translate:
                  '${currentLocale.languageCode}-${currentLocale.countryCode}');
      ExploreDetailsResponseModel responseModel = ExploreDetailsResponseModel();

      final detailResponse =
          await municipalPartyDetailUseCase.call(requestModel, responseModel);

      detailResponse.fold(
        (l) {
          state = state.copyWith(isLoading: false);
          debugPrint(
              "getMunicipalPartyDetailUsingId exception = ${l.toString()}");
        },
        (r) {
          final result = r as ExploreDetailsResponseModel;
          if (result.data != null) {
            state = state.copyWith(
                isLoading: false,
                municipalPartyDetailDataModel: result.data,
                cityList: result.data?.topFiveCities ?? []);
          }
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint("getMunicipalPartyDetailUsingId exception = $e");
    }
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();

    state = state.copyWith(isUserLoggedIn: status);
  }

  updateEventIsFav(bool isFav, int? eventId) {
    final list = state.eventList;
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(eventList: list);
  }

  updateNewsIsFav(bool isFav, int? eventId) {
    final list = state.newsList;
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(newsList: list);
  }

  void setIsFavoriteCity(bool isFavorite, int? id) {
    for (var city in state.cityList) {
      if (city.id == id) {
        city.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(cityList: state.cityList);
  }

  void setIsFavoriteMunicipal(bool isFavorite) {
    final municipalPartyDetailDataModel = state.municipalPartyDetailDataModel;
    municipalPartyDetailDataModel?.isFavorite = isFavorite;
    state = state.copyWith(
        municipalPartyDetailDataModel: municipalPartyDetailDataModel);
  }

  void updateOnFav(bool status) {
    final value = state.municipalPartyDetailDataModel;
    if (value != null && value.isFavorite != null) {
      value.isFavorite = status;
      state = state.copyWith(municipalPartyDetailDataModel: value);
    }
  }
}
