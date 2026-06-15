import 'package:core/preference_manager/preference_constant.dart';
import 'package:core/preference_manager/shared_pref_helper.dart';
import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:core/token_status.dart';
import 'package:data/service/location_service/location_service.dart';
import 'package:domain/model/empty_request.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/listings/search_request_model.dart';
import 'package:domain/model/request_model/refresh_token/refresh_token_request_model.dart';
import 'package:domain/model/request_model/user_detail/user_detail_request_model.dart';
import 'package:domain/model/request_model/weather/weather_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/listings_model/search_listings_response_model.dart';
import 'package:domain/model/response_model/onboarding_model/onboarding_details_response_model.dart';
import 'package:domain/model/response_model/refresh_token/refresh_token_response_model.dart';
import 'package:domain/model/response_model/user_detail/user_detail_response_model.dart';
import 'package:domain/model/response_model/weather/weather_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/onboarding/onboarding_detail_usecase.dart';
import 'package:domain/usecase/refresh_token/refresh_token_usecase.dart';
import 'package:domain/usecase/search/search_usecase.dart';
import 'package:domain/usecase/user_detail/user_detail_usecase.dart';
import 'package:domain/usecase/weather/weather_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:kusel/database/digifit_cache_data/digifit_cache_data_controller.dart';
import 'package:kusel/providers/guest_user_login_provider.dart';
import 'package:kusel/providers/refresh_token_provider.dart';

import '../../common_widgets/get_current_location.dart';
import '../../common_widgets/location_const.dart';
import '../../locale/localization_manager.dart';
import 'home_screen_state.dart';

final homeScreenProvider =
StateNotifierProvider<HomeScreenProvider, HomeScreenState>((ref) =>
    HomeScreenProvider(
        listingsUseCase: ref.read(listingsUseCaseProvider),
        searchUseCase: ref.read(searchUseCaseProvider),
        sharedPreferenceHelper: ref.read(sharedPreferenceHelperProvider),
        userDetailUseCase: ref.read(userDetailUseCaseProvider),
        weatherUseCase: ref.read(weatherUseCaseProvider),
        signInStatusController: ref.read(signInStatusProvider.notifier),
        refreshTokenProvider: ref.read(refreshTokenProvider),
        tokenStatus: ref.read(tokenStatusProvider),
        localeManagerController: ref.read(localeManagerProvider.notifier),
        onboardingDetailsUseCase:
        ref.read(onboardingDetailsUseCaseProvider),
        refreshTokenUseCase: ref.read(refreshTokenUseCaseProvider),
        guestUserLogin: ref.read(guestUserLoginProvider),
        digifitCacheDataController: ref.read(digifitCacheDataProvider.notifier)
    ),
);

class HomeScreenProvider extends StateNotifier<HomeScreenState> {
  ListingsUseCase listingsUseCase;
  SearchUseCase searchUseCase;
  SharedPreferenceHelper sharedPreferenceHelper;
  UserDetailUseCase userDetailUseCase;
  WeatherUseCase weatherUseCase;
  SignInStatusController signInStatusController;
  RefreshTokenProvider refreshTokenProvider;
  TokenStatus tokenStatus;
  LocaleManagerController localeManagerController;
  RefreshTokenUseCase refreshTokenUseCase;
  OnboardingDetailsUseCase onboardingDetailsUseCase;
  GuestUserLogin guestUserLogin;
  DigifitCacheDataController digifitCacheDataController;

  HomeScreenProvider(
      {required this.listingsUseCase,
      required this.searchUseCase,
      required this.sharedPreferenceHelper,
      required this.userDetailUseCase,
      required this.weatherUseCase,
      required this.signInStatusController,
      required this.refreshTokenProvider,
      required this.tokenStatus,
      required this.localeManagerController,
      required this.onboardingDetailsUseCase,
      required this.refreshTokenUseCase,
      required this.guestUserLogin,
      required this.digifitCacheDataController
      })
      : super(HomeScreenState.empty());

  initialCall() async {
    final res = sharedPreferenceHelper.getString(tokenKey);
    if (res == null) {
      await guestUserLogin.getGuestUserToken(
        onSuccess: ()async{
          await fetchHomeScreenInitMethod();
        }
      );
    }else{
      await fetchHomeScreenInitMethod();
    }
  }

  Future<void> getHighlights() async {
    try {
      state = state.copyWith(loading: true, error: "");

      Locale currentLocale = localeManagerController.getSelectedLocale();
      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
              sortByStartDate: true,
              categoryId: ListingCategoryId.highlights.eventId.toString(),
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

      GetAllListingsResponseModel getAllListingsResponseModel =
          GetAllListingsResponseModel();
      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListingsResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(loading: false, error: l.toString());
        },
        (r) {
          var listings = (r as GetAllListingsResponseModel).data;
          state = state.copyWith(highlightsList: listings, loading: false);
        },
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> getEvents() async {
    try {
      state = state.copyWith(loading: true, error: "");

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
            categoryId: '3',
              sortByStartDate: true,
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");

      GetAllListingsResponseModel getAllListingsResponseModel =
          GetAllListingsResponseModel();
      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListingsResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(loading: false, error: l.toString());
        },
        (r) {
          var listings = (r as GetAllListingsResponseModel).data;
          state = state.copyWith(eventsList: listings, loading: false);
        },
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> getNearbyEvents() async {
    try {
      // final position = await getLatLong();
      //
      // debugPrint(
      //     "user coordinates [ lat : ${position.latitude}, long: ${position.longitude} ");

      final lat =  EventLatLong.kusel.latitude;
      final long = EventLatLong.kusel.longitude;
      final radius = 20;
      state = state.copyWith(error: "");

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
              categoryId: "3",
              sortByStartDate: true,
              radius: radius,
              centerLongitude: long,
              centerLatitude: lat,
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");
      GetAllListingsResponseModel getAllListingsResponseModel =
          GetAllListingsResponseModel();
      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListingsResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(error: l.toString());
        },
        (r) {
          var listings = (r as GetAllListingsResponseModel).data;
          state = state.copyWith(nearbyEventsList: listings);
        },
      );
    } catch (error) {
      state = state.copyWith(error: error.toString());
    }
  }

  Future<void> getNews() async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();
      final categoryId = ListingCategoryId.news.eventId.toString();

      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel(
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

  updateNewsIsFav(bool isFav, int? eventId) {
    final list = state.newsList ?? [];
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(newsList: list);
  }

  Future<List<Listing>> searchList({
    required String searchText,
    required void Function() success,
    required void Function(String message) error,
  }) async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();
      SearchRequestModel searchRequestModel = SearchRequestModel(
          searchQuery: searchText,
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");
      SearchListingsResponseModel searchListingsResponseModel =
          SearchListingsResponseModel();

      final result = await searchUseCase.call(
          searchRequestModel, searchListingsResponseModel);
      return result.fold(
        (l) {
          debugPrint('fold Exception = $l');
          error(l.toString());
          return <Listing>[];
        },
        (r) {
          final listings = (r as SearchListingsResponseModel).data;
          success();
          return listings ?? <Listing>[];
        },
      );
    } catch (e) {
      state = state.copyWith(loading: false);
      debugPrint(' Exception = $e');
      error(e.toString());
      return <Listing>[];
    }
  }

  updateCardIndex(int index) {
    state = state.copyWith(highlightCount: index);
  }

  Future<void> getUserDetails() async {
    try {
      final status = await signInStatusController.isUserLoggedIn();
      if (status) {
        final userId = sharedPreferenceHelper.getInt(userIdKey);

        if (userId != null) {
          final status = tokenStatus.isAccessTokenExpired();

          if (status) {
            await refreshTokenProvider.getNewToken(
                onError: () {},
                onSuccess: () async {
                  await _getDetails(userId);
                });
          } else {
            _getDetails(userId);
          }
        }
      }
    }catch (error) {
      debugPrint('get user details exception : $error');
    }
  }

  _getDetails(int? userId) async {
    try {
      UserDetailRequestModel requestModel = UserDetailRequestModel();
      UserDetailResponseModel responseModel = UserDetailResponseModel();
      final result = await userDetailUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get details fold exception : $l');
      }, (r) async {
        final response = r as UserDetailResponseModel;
        await sharedPreferenceHelper.setString(
            userNameKey, response.data?.username ?? "");
        await sharedPreferenceHelper.setString(
            userFirstNameKey, response.data?.firstname ?? "");
        debugPrint('first time get this id 33 is ${state.userName}');
        state = state.copyWith(userName: response.data?.firstname ?? "");
      });
    } catch (e) {
      debugPrint('get details exception : $e');
    }
  }

  Future<void> getLoginStatus() async {
    final status = await signInStatusController.isUserLoggedIn();

    state = state.copyWith(isSignInButtonVisible: !status);
  }

  Future<void> getLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (mounted && position != null) {
      state = state.copyWith(
          latitude: position.latitude, longitude: position.longitude);
    }
  }

  void setIsFavoriteNearBy(bool isFavorite, int? id) {
    for (var listing in state.nearbyEventsList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(nearbyEventsList: state.nearbyEventsList);
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

  Future<void> getWeather() async {
    try {
      WeatherRequestModel requestModel =
          WeatherRequestModel(days: 3, placeName: "kusel");
      WeatherResponseModel responseModel = WeatherResponseModel();

      final response = await weatherUseCase.call(requestModel, responseModel);

      response.fold((l) {
        debugPrint('get weather fold exception = $l');
      }, (r) {
        final result = r as WeatherResponseModel;

        state = state.copyWith(weatherResponseModel: result);
      });
    } catch (error) {
      debugPrint('get weather exception = $error');
    }
  }

  Future<void> fetchHomeScreenInitMethod() async {
    await Future.wait([
      getOnboardingDetails(),
      getLocation(),
      getUserDetails(),
      getHighlights(),
      getEvents(),
      getNearbyEvents(),
      getNews(),
      getLoginStatus(),
      getWeather(),
      digifitCacheDataController.fetchAllDigifitDataFromNetwork(),
      digifitCacheDataController.postDigifitExerciseDataToNetwork()
    ]);
  }

  Future<void> refresh() async {
    fetchHomeScreenInitMethod();
  }

  List<Listing> sortSuggestionList(String search, List<Listing> list) {
    search = search.toLowerCase();
    list.sort((a, b) {
      final aTitle = a.title?.toLowerCase() ?? '';
      final bTitle = b.title?.toLowerCase() ?? '';

      final aScore =
          aTitle.startsWith(search) ? 0 : (aTitle.contains(search) ? 1 : 2);
      final bScore =
          bTitle.startsWith(search) ? 0 : (bTitle.contains(search) ? 1 : 2);

      if (aScore != bScore) return aScore.compareTo(bScore);
      return aTitle.compareTo(bTitle);
    });

    return list;
  }

  Future<void> getOnboardingDetails() async {
    try {
      final status = await signInStatusController.isUserLoggedIn();
      if (status) {
        final response = tokenStatus.isAccessTokenExpired();

        if (response) {
          RefreshTokenRequestModel requestModel =
              RefreshTokenRequestModel();
          RefreshTokenResponseModel responseModel = RefreshTokenResponseModel();

          final refreshResponse =
              await refreshTokenUseCase.call(requestModel, responseModel);

          bool refreshSuccess = await refreshResponse.fold(
            (left) {
              debugPrint(
                  'refresh token onboarding details fold exception : $left');
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
            return;
          }
        }

        EmptyRequest requestModel = EmptyRequest();
        OnboardingDetailsResponseModel responseModel =
            OnboardingDetailsResponseModel();
        final result =
            await onboardingDetailsUseCase.call(requestModel, responseModel);

        result.fold((l) {
          debugPrint('get onboarding details fold exception : $l');
        }, (r) async {
          final response = r as OnboardingDetailsResponseModel;
          if (response.data != null && response.data?.cityId != null) {
            sharedPreferenceHelper.setInt(
                selectedCityIdKey, response.data!.cityId!);
          }
        });
      }
    } catch (error) {
      debugPrint('get onboarding details exception : $error');
    }
  }
}
