import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:domain/model/request_model/event_details/event_details_request_model.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/listings/recommendations_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/response_model/event_details/event_details_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/usecase/event_details/event_details_usecase.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/listings/recommendations_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/providers/refresh_token_provider.dart';
import 'package:kusel/screens/event/event_detail_screen_state.dart';

import '../../common_widgets/location_const.dart';

final eventDetailScreenProvider = StateNotifierProvider.family
    .autoDispose<EventDetailScreenController, EventDetailScreenState, int>(
        (ref, eventId) => EventDetailScreenController(
            eventDetailsUseCase: ref.read(eventDetailsUseCaseProvider),
            listingsUseCase: ref.read(listingsUseCaseProvider),
            localeManagerController: ref.read(localeManagerProvider.notifier),
            sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
            signInStatusController: ref.read(signInStatusProvider.notifier),
            tokenStatus: ref.read(tokenStatusProvider),
            recommendationsUseCase: ref.read(recommendationUseCaseProvider),
            refreshTokenProvider: ref.read(refreshTokenProvider),
            eventId: eventId));

class EventDetailScreenController
    extends StateNotifier<EventDetailScreenState> {
  final int eventId;

  EventDetailScreenController(
      {required this.eventDetailsUseCase,
      required this.listingsUseCase,
      required this.localeManagerController,
      required this.sharedPreferenceHelper,
      required this.signInStatusController,
      required this.tokenStatus,
      required this.refreshTokenProvider,
      required this.eventId,
      required this.recommendationsUseCase})
      : super(EventDetailScreenState.empty());

  EventDetailsUseCase eventDetailsUseCase;
  ListingsUseCase listingsUseCase;
  LocaleManagerController localeManagerController;
  SharedPreferenceHelper sharedPreferenceHelper;
  SignInStatusController signInStatusController;
  TokenStatus tokenStatus;
  RefreshTokenProvider refreshTokenProvider;
  RecommendationsUseCase recommendationsUseCase;

  Future<void> getEventDetails(int? eventId) async {
    try {
      state = state.copyWith(loading: true);

      final response = tokenStatus.isAccessTokenExpired();
      if (response) {
        await refreshTokenProvider.getNewToken(
            onError: () {},
            onSuccess: () async {
              await _getEventDetails();
            });
      } else {
        await _getEventDetails();
      }
    } catch (error) {
      debugPrint('exception while getting event details :$error');
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  _getEventDetails() async {
    try {
      state = state.copyWith(loading: true, error: "");

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetEventDetailsRequestModel getEventDetailsRequestModel =
          GetEventDetailsRequestModel(
              id: eventId,
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

      GetEventDetailsResponseModel getEventDetailsResponseModel =
          GetEventDetailsResponseModel();
      final result = await eventDetailsUseCase.call(
          getEventDetailsRequestModel, getEventDetailsResponseModel);
      result.fold(
        (l) {
          debugPrint("Event details fold exception $l");
          state = state.copyWith(error: l.toString());
        },
        (r) {
          var eventData = (r as GetEventDetailsResponseModel).data;
          state = state.copyWith(
              eventDetails: eventData,
              isFavourite: eventData?.isFavorite ?? false);
        },
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks.first;
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      return "Error: $e";
    }

    return "No Address Found";
  }

  Future<void> getRecommendedList(String? categoryId) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      String id = categoryId ?? "3";
      RecommendationsRequestModel recommendationsRequestModel =
          RecommendationsRequestModel(
              categoryId: id,
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");
      GetAllListingsResponseModel getAllListingsResponseModel =
          GetAllListingsResponseModel();

      final result = await recommendationsUseCase.call(
          recommendationsRequestModel, getAllListingsResponseModel);
      result.fold(
        (l) {
          debugPrint('fold exception while getting recommendation : $l');

          state = state.copyWith(error: l.toString());
        },
        (r) {
          final res = r as GetAllListingsResponseModel;

          if (res.data != null) {
            state = state.copyWith(recommendList: res.data);
          }
        },
      );
    } catch (error) {
      debugPrint('exception while getting recommendation : $error');

      if (mounted) {
        state = state.copyWith(error: error.toString());
      }
    }
  }

  assignIsFav(bool isFav) {
    state = state.copyWith(isFavourite: isFav);
  }

  List<Listing> getSortedTop10Listings(List<Listing> listings) {
    final now = DateTime.now();

    final filteredListings = listings.where((listing) {
      final startDate = listing.startDate != null
          ? DateTime.tryParse(listing.startDate!)
          : null;
      return startDate != null && !startDate.isBefore(now);
    }).toList();

    filteredListings.sort((a, b) {
      final aDate = DateTime.parse(a.startDate!);
      final bDate = DateTime.parse(b.startDate!);
      return aDate.compareTo(bDate);
    });

    return filteredListings.take(10).toList();
  }

  List<Listing> subList(List<Listing> list) {
    return list.length > 3 ? list.sublist(0, 3) : list;
  }

  void toggleFav() {
    bool isFav = state.isFavourite;
    state = state.copyWith(isFavourite: isFav ? false : true);
  }
}

class EventDetailScreenParams {
  int eventId;
  String? categoryId;
  Function()? onFavClick;

  EventDetailScreenParams({required this.eventId, this.onFavClick, this.categoryId});
}
