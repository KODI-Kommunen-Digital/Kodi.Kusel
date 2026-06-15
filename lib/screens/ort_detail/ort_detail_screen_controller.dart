import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/ort_detail/ort_detail_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/ort_detail/ort_detail_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/ort_detail/ort_detail_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/ort_detail/ort_detail_screen_state.dart';

import '../../common_widgets/listing_id_enum.dart';
import '../../common_widgets/location_const.dart';

final ortDetailScreenControllerProvider = StateNotifierProvider.autoDispose<
        OrtDetailScreenController, OrtDetailScreenState>(
    (ref) => OrtDetailScreenController(
          ortDetailUseCase: ref.read(ortDetailUseCaseProvider),
          signInStatusController: ref.watch(signInStatusProvider.notifier),
          sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
          tokenStatus: ref.read(tokenStatusProvider),
          refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
          listingsUseCase: ref.read(listingsUseCaseProvider),
          localeManagerController: ref.read(localeManagerProvider.notifier),
        ));

class OrtDetailScreenController extends StateNotifier<OrtDetailScreenState> {
  OrtDetailUseCase ortDetailUseCase;
  SignInStatusController signInStatusController;
  SharedPreferenceHelper sharedPreferenceHelper;
  TokenStatus tokenStatus;
  RefreshTokenUseCase refreshTokenUseCase;
  ListingsUseCase listingsUseCase;
  LocaleManagerController localeManagerController;

  OrtDetailScreenController(
      {required this.ortDetailUseCase,
      required this.signInStatusController,
      required this.sharedPreferenceHelper,
      required this.tokenStatus,
      required this.refreshTokenUseCase,
      required this.listingsUseCase,
      required this.localeManagerController})
      : super(OrtDetailScreenState.copyWith());

  Future<void> getOrtDetail({required String ortId}) async {
    try {
      state = state.copyWith(isLoading: true);

      state = state.copyWith(isLoading: true);

      final response = tokenStatus.isAccessTokenExpired();
      final status = await signInStatusController.isUserLoggedIn();

      Locale currentLocale = localeManagerController.getSelectedLocale();

      if (response && status) {
        RefreshTokenRequestModel requestModel = RefreshTokenRequestModel();
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

      OrtDetailRequestModel requestModel = OrtDetailRequestModel(
          ortId: ortId,
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");
      OrtDetailResponseModel responseModel = OrtDetailResponseModel();

      final detailResponse =
          await ortDetailUseCase.call(requestModel, responseModel);

      detailResponse.fold((l) {
        debugPrint('get ort detail fold exception = ${l.toString()}');
        state = state.copyWith(isLoading: false);
      }, (r) {
        final res = r as OrtDetailResponseModel;

        state = state.copyWith(
            ortDetailDataModel: res.data,
            isLoading: false,
            latitude: double.parse(
                res.data?.latitude ?? EventLatLong.kusel.latitude.toString()),
            longitude: double.parse(res.data?.longitude ??
                EventLatLong.kusel.longitude.toString()));
      });
    } catch (e) {
      debugPrint("get ort detail exception = $e");
      state = state.copyWith(isLoading: false);
    }
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    state = state.copyWith(isUserLoggedIn: status);
  }

  void setIsFavoriteCity(bool isFavorite) {
    final ortDetailDataModel = state.ortDetailDataModel;
    if (ortDetailDataModel != null && ortDetailDataModel.isFavorite != null) {
      ortDetailDataModel.isFavorite = isFavorite;
      state = state.copyWith(ortDetailDataModel: ortDetailDataModel);
    }
  }

  updateNewsIsFav(bool isFav, int? eventId) {
    final list = state.newsList ?? [];
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(newsList: list);
  }

  updateCardIndex(int index) {
    state = state.copyWith(highlightCount: index);
  }

  Future<void> getHighlights() async {
    try {
      state = state.copyWith(isLoading: true, error: "");

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
              categoryId: ListingCategoryId.highlights.eventId.toString(),
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

      GetAllListingsResponseModel getAllListingsResponseModel =
          GetAllListingsResponseModel();
      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListingsResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(isLoading: false, error: l.toString());
        },
        (r) {
          var listings = (r as GetAllListingsResponseModel).data;
          state = state.copyWith(highlightsList: listings, isLoading: false);
        },
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  Future<void> getNews(String cityId) async {
    try {
      final categoryId = ListingCategoryId.news.eventId.toString();

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel(
          cityId: cityId,
          pageSize: 5,
          sortByStartDate: true,
          categoryId: categoryId,
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((l) {
        debugPrint("getEventsUsingCityId fold exception = ${l.toString()}");
      }, (r) {
        final result = r as GetAllListingsResponseModel;

        state = state.copyWith(newsList: result.data);
      });
    } catch (e) {
      debugPrint("getEventsUsingCityId exception = $e");
    }
  }

  Future<void> getEvents(String? cityId) async {
    try {
      state = state.copyWith(isLoading: true, error: "");

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
              cityId: cityId,
              categoryId: ListingCategoryId.event.eventId.toString(),
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

      GetAllListingsResponseModel getAllListingsResponseModel =
          GetAllListingsResponseModel();
      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListingsResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(isLoading: false, error: l.toString());
        },
        (r) {
          var listings = (r as GetAllListingsResponseModel).data;
          state = state.copyWith(eventsList: listings, isLoading: false);
        },
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  void setIsFavoriteEvent(bool isFavorite, int? id) {
    for (var listing in state.eventsList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(eventsList: state.eventsList);
  }

  void setIsFavoriteHighlight(bool isFavorite, int? id) {
    for (var listing in state.highlightsList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(highlightsList: state.highlightsList);
  }
}
