import 'dart:ui';

import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/common_widgets/listing_id_enum.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_parameter.dart';
import 'package:kusel/screens/events_listing/selected_event_list_screen_state.dart';

final selectedEventListScreenProvider = StateNotifierProvider.autoDispose<
        SelectedEventListScreenController, SelectedEventListScreenState>(
    (ref) => SelectedEventListScreenController(
        listingsUseCase: ref.read(listingsUseCaseProvider),
        signInStatusController: ref.read(signInStatusProvider.notifier),
        localeManagerController: ref.read(localeManagerProvider.notifier)));

class SelectedEventListScreenController
    extends StateNotifier<SelectedEventListScreenState> {
  ListingsUseCase listingsUseCase;
  SignInStatusController signInStatusController;
  LocaleManagerController localeManagerController;

  SelectedEventListScreenController(
      {required this.listingsUseCase,
      required this.signInStatusController,
      required this.localeManagerController})
      : super(SelectedEventListScreenState.empty());

  Future<void> getEventsList(
      SelectedEventListScreenParameter? eventListScreenParameter, int pageNumber) async {
    try {
      if(pageNumber>1){
        state = state.copyWith(isMoreListLoading: true, error: "");
      } else {
        state = state.copyWith(loading: true, error: "");
      }
      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
            pageNo: pageNumber,
              sortByStartDate: true,
              translate: "${currentLocale.languageCode}-${currentLocale.countryCode}"
          );
      if (eventListScreenParameter?.categoryId != null) {
        getAllListingsRequestModel.categoryId =
            eventListScreenParameter?.categoryId.toString();
      }

      if (eventListScreenParameter?.cityId != null) {
        getAllListingsRequestModel.cityId =
            eventListScreenParameter!.cityId!.toString();
      }

      if (eventListScreenParameter?.centerLatitude != null) {
        getAllListingsRequestModel.centerLatitude =
            eventListScreenParameter!.centerLatitude;
      }

      if (eventListScreenParameter?.centerLongitude != null) {
        getAllListingsRequestModel.centerLongitude =
            eventListScreenParameter!.centerLongitude;

        getAllListingsRequestModel.radius = SearchRadius.radius.value;
      }

      GetAllListingsResponseModel getAllListResponseModel =
          GetAllListingsResponseModel();

      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListResponseModel);
      result.fold(
        (l) {
          state = state.copyWith(loading: false, error: l.toString());
        },
        (r) {
          var eventsList = (r as GetAllListingsResponseModel).data;
          List<Listing> existingEventList = state.eventsList;
          bool isLoadMoreButtonEnabled;
          if(eventsList!=null && eventsList.isNotEmpty){
            existingEventList.addAll(eventsList);
            isLoadMoreButtonEnabled = true;
          } else {
            pageNumber--;
            isLoadMoreButtonEnabled = false;
          }
          state = state.copyWith(
              list: existingEventList,
              loading: false,
              isMoreListLoading: false,
              heading: eventListScreenParameter?.listHeading,
              currentPageNo: pageNumber,
              isLoadMoreButtonEnabled : isLoadMoreButtonEnabled
          );
        },
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  void setIsFavorite(bool isFavorite, int? id) {
    for (var listing in state.eventsList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(list: state.eventsList);
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    state = state.copyWith(isUserLoggedIn: status);
  }

  updateIsFav(bool isFav, int? eventId) {
    final list = state.eventsList;
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(list: list);
  }

  void onLoadMoreList(SelectedEventListScreenParameter? eventListScreenParameter) async {
    int currPageNo = state.currentPageNo;
    currPageNo = currPageNo+1;
    await getEventsList(eventListScreenParameter, currPageNo);
  }
}
