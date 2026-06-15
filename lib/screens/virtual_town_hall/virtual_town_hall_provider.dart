import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/virtual_town_hall/virtual_town_hall_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/virtual_town_hall/virtual_town_hall_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/virtual_town_hall/virtual_town_hall_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/virtual_town_hall/virtual_town_hall_state.dart';

import '../../common_widgets/location_const.dart';

final virtualTownHallProvider =
    StateNotifierProvider<VirtualTownHallProvider, VirtualTownHallState>(
        (ref) => VirtualTownHallProvider(
            listingsUseCase: ref.read(listingsUseCaseProvider),
            virtualTownHallUseCase: ref.read(virtualTownHallUseCaseProvider),
            signInStatusController: ref.read(signInStatusProvider.notifier),
            localeManagerController: ref.read(localeManagerProvider.notifier)));

class VirtualTownHallProvider extends StateNotifier<VirtualTownHallState> {
  ListingsUseCase listingsUseCase;
  VirtualTownHallUseCase virtualTownHallUseCase;
  SignInStatusController signInStatusController;
  LocaleManagerController localeManagerController;

  VirtualTownHallProvider(
      {required this.listingsUseCase,
      required this.virtualTownHallUseCase,
      required this.signInStatusController,
      required this.localeManagerController})
      : super(VirtualTownHallState.empty());

  updateCardIndex(int index) {
    state = state.copyWith(highlightCount: index);
  }

  Future<void> getEventsUsingCityId({required String cityId}) async {
    try {

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel(
          categoryId: ListingCategoryId.event.eventId.toString(),
          cityId: cityId,
          translate: "${currentLocale.languageCode}-${currentLocale.countryCode}");

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      final response = await listingsUseCase.call(requestModel, responseModel);

      response.fold((l) {
        debugPrint("getEventsUsingCityId fold exception = ${l.toString()}");
      }, (r) {
        final result = r as GetAllListingsResponseModel;

        state = state.copyWith(eventList: result.data);
      });
    } catch (e) {
      debugPrint("getEventsUsingCityId exception = $e");
    }
  }

  Future<void> getNewsUsingCityId({required String cityId}) async {
    try {
      final id = cityId;
      final categoryId = ListingCategoryId.news.eventId.toString();

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel requestModel =
          GetAllListingsRequestModel(cityId: id, categoryId: categoryId,
              translate: "${currentLocale.languageCode}-${currentLocale.countryCode}");

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

  Future<void> getVirtualTownHallDetails() async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();
      state = state.copyWith(loading: true);

      VirtualTownHallRequestModel requestModel = VirtualTownHallRequestModel(
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      VirtualTownHallResponseModel responseModel =
          VirtualTownHallResponseModel();

      final response =
          await virtualTownHallUseCase.call(requestModel, responseModel);

      response.fold((l) {
        debugPrint("getEventsUsingCityId fold exception = ${l.toString()}");
      }, (r) {
        final result = r as VirtualTownHallResponseModel;
        if (result.data != null) {
          state = state.copyWith(
            cityName: result.data?.name,
            cityId: result.data?.id.toString(),
            imageUrl: result.data?.image,
            description: result.data?.description,
            address: result.data?.address,
            latitude: double.parse(result.data?.latitude ??
                EventLatLong.kusel.latitude.toString()),
            longitude: double.parse(result.data?.longitude ??
                EventLatLong.kusel.longitude.toString()),
            phoneNumber: result.data?.phone,
            email: result.data?.email,
            openUntil: result.data?.openUntil,
            websiteUrl: result.data?.websiteUrl,
            onlineServiceList: result.data?.onlineServices,
            municipalitiesList: result.data?.municipalities,
            loading: false,
          );
          getEventsUsingCityId(cityId: state.cityId ?? '1');
          getNewsUsingCityId(cityId: state.cityId ?? '1');
        }
      });
    } catch (e) {
      debugPrint("getEventsUsingCityId exception = $e");
    }
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();

    state = state.copyWith(isUserLoggedIn: status);
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

  updateEventIsFav(bool isFav, int? eventId) {
    final list = state.eventList ?? [];
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(eventList: list);
  }

  void setIsFavoriteMunicipality(bool isFavorite, int? municipalityId) {
    for (var municipality in state.municipalitiesList) {
      if (municipality.id == municipalityId) {
        municipality.isFavorite = isFavorite;
        break;
      }
    }
    state = state.copyWith(municipalitiesList: state.municipalitiesList);
  }
}
