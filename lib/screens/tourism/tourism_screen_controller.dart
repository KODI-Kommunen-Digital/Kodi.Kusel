import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/listings/recommendations_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/listings/recommendations_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/get_current_location.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:kusel/common_widgets/location_const.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/tourism/tourism_screen_state.dart';

final tourismScreenControllerProvider = StateNotifierProvider.autoDispose<
        TourismScreenController, TourismScreenState>(
    (ref) => TourismScreenController(
        listingsUseCase: ref.read(listingsUseCaseProvider),
        recommendationsUseCase: ref.read(recommendationUseCaseProvider),
        signInStatusController: ref.read(signInStatusProvider.notifier),
        localeManagerController: ref.read(localeManagerProvider.notifier)));

class TourismScreenController extends StateNotifier<TourismScreenState> {
  ListingsUseCase listingsUseCase;
  SignInStatusController signInStatusController;
  LocaleManagerController localeManagerController;
  RecommendationsUseCase recommendationsUseCase;
  TourismScreenController(
      {required this.listingsUseCase,
      required this.signInStatusController,
      required this.localeManagerController,
      required this.recommendationsUseCase})
      : super(TourismScreenState.empty());

  getAllEvents() async {
    try {
      final categoryId = ListingCategoryId.event.eventId;

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();
      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel(
          categoryId: categoryId.toString(),
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((left) {
        debugPrint(" get all events fold exception : ${left.toString()}");
      }, (right) {
        final r = right as GetAllListingsResponseModel;

        state = state.copyWith(allEventList: r.data);
      });
    } catch (error) {
      debugPrint(" get all events exception:$error");
    }
  }

  getNearByListing() async {
    try {
      // final position = await getLatLong();
      //
      // debugPrint(
      //     "user coordinates [ lat : ${position.latitude}, long: ${position.longitude} ");

      Locale currentLocale = localeManagerController.getSelectedLocale();

      final lat = EventLatLong.kusel.latitude;
      final long = EventLatLong.kusel.longitude;
      final radius = SearchRadius.radius.value;
      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();
      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel(
          categoryId: "3",
          sortByStartDate: true,
          centerLatitude: lat,
          centerLongitude: long,
          radius: radius,
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((left) {
        debugPrint(" getNearByEvents fold exception : ${left.toString()}");
      }, (right) {
        final r = right as GetAllListingsResponseModel;

        state = state.copyWith(nearByList: r.data, lat: lat, long: long);
      });
    } catch (error) {
      debugPrint(" getNearByEvents exception:$error");
    }
  }

  updateCardIndex(int index) {
    state = state.copyWith(highlightCount: index);
  }

  getRecommendationListing() async {
    try {
      state = state.copyWith(isRecommendationLoading: true);

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();
      RecommendationsRequestModel requestModel = RecommendationsRequestModel(
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      final response = await recommendationsUseCase.call(requestModel, responseModel);

      response.fold((left) {
        state = state.copyWith(isRecommendationLoading: false);
        debugPrint(
            " getRecommendationListing fold exception : ${left.toString()}");
      }, (right) {
        final r = right as GetAllListingsResponseModel;

        state = state.copyWith(
            recommendationList: r.data, isRecommendationLoading: false);
      });
    } catch (error) {
      state = state.copyWith(isRecommendationLoading: false);
      debugPrint(" getRecommendationListing exception:$error");
    }
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    state = state.copyWith(isUserLoggedIn: status);
  }

  updateNearByIsFav(bool isFav, int? eventId) {
    final list = state.nearByList;
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(nearByList: list);
  }

  updateRecommendationIsFav(bool isFav, int? eventId) {
    final list = state.recommendationList;
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(recommendationList: list);
  }

  updateEventIsFav(bool isFav, int? eventId) {
    final list = state.allEventList;
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(allEventList: list);
  }
}
