import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/listings/recommendations_request_model.dart';
import 'package:domain/model/response_model/filter/get_filter_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/listings/recommendations_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_state.dart';
import 'package:kusel/utility/kusel_date_utils.dart';

import 'all_event_screen_state.dart';

final allEventScreenProvider = StateNotifierProvider.autoDispose<
        AllEventScreenController, AllEventScreenState>(
    (ref) => AllEventScreenController(
        listingsUseCase: ref.read(listingsUseCaseProvider),
        signInStatusController: ref.read(signInStatusProvider.notifier),
        recommendationsUseCase: ref.read(recommendationUseCaseProvider),
        localeManagerController: ref.read(localeManagerProvider.notifier)));

class AllEventScreenController extends StateNotifier<AllEventScreenState> {
  ListingsUseCase listingsUseCase;
  SignInStatusController signInStatusController;
  LocaleManagerController localeManagerController;
  RecommendationsUseCase recommendationsUseCase;

  AllEventScreenController({
    required this.listingsUseCase,
    required this.signInStatusController,
    required this.localeManagerController,
    required this.recommendationsUseCase,
  }) : super(AllEventScreenState.empty());

  Future<void> getListing(
    int pageNumber,
  ) async {
    try {
      if (pageNumber > 1) {
        state = state.copyWith(isMoreListLoading: true);
      } else {
        state = state.copyWith(isLoading: true, listingList: []);
      }
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

      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
              startAfterDate: startDate,
              endBeforeDate: endDate,
              categoryId: categoryId.isEmpty
                  ? null
                  : categoryId.substring(0, categoryId.length - 1),
              cityId: state.selectedCityId == 0
                  ? null
                  : state.selectedCityId.toString(),
              sortByStartDate: true,
              radius: state.radius == 0 ? null : state.radius.toInt(),
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}",
              pageNo: pageNumber);
      GetAllListingsResponseModel getAllListResponseModel =
          GetAllListingsResponseModel();

      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListResponseModel);
      result.fold(
        (l) {
          debugPrint("get all event fold exception : $l");
          state = state.copyWith(isLoading: false);
        },
        (r) {
          var eventsList = (r as GetAllListingsResponseModel).data;
          bool isLoadMoreButtonEnabled;
          List<Listing> existingEventList = state.listingList;

          if (eventsList != null && eventsList.isNotEmpty) {
            existingEventList.addAll(eventsList);
            isLoadMoreButtonEnabled = true;
          } else {
            pageNumber--;
            isLoadMoreButtonEnabled = false;
          }

          state = state.copyWith(
              listingList: existingEventList,
              isLoading: false,
              isMoreListLoading: false,
              currentPageNo: pageNumber,
              isLoadMoreButtonEnabled: isLoadMoreButtonEnabled);

          numberOfFiltersApplied();
        },
      );
    } catch (error) {
      debugPrint("get all event  exception : $error");
      state = state.copyWith(isLoading: false);
    }
  }

  void setIsFavorite(bool isFavorite, int? id) {
    for (var listing in state.listingList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
        break;
      }
    }
    state = state.copyWith(listingList: state.listingList);
  }

  Future<void> applyFilter(
      {String? startAfterDate,
      String? endBeforeDate,
      int? cityId,
      int? pageNumber,
      int? categoryId,
      int? filterCount}) async {
    try {
      state = state.copyWith(isLoading: true);

      Locale currentLocale = localeManagerController.getSelectedLocale();
      GetAllListingsRequestModel getAllListingsRequestModel =
          GetAllListingsRequestModel(
              sortByStartDate: true,
              translate:
                  "${currentLocale.languageCode}-${currentLocale.countryCode}");
      if (startAfterDate != null) {
        getAllListingsRequestModel.startAfterDate = startAfterDate;
      }
      if (endBeforeDate != null) {
        getAllListingsRequestModel.endBeforeDate = endBeforeDate;
      }
      if (cityId != null) getAllListingsRequestModel.cityId = cityId.toString();
      if (pageNumber != null) getAllListingsRequestModel.pageNo = pageNumber;
      if (categoryId != null) {
        getAllListingsRequestModel.categoryId = categoryId.toString();
      }
      GetAllListingsResponseModel getAllListResponseModel =
          GetAllListingsResponseModel();

      final result = await listingsUseCase.call(
          getAllListingsRequestModel, getAllListResponseModel);
      result.fold(
        (l) {
          debugPrint("get filter event fold exception : $l");
          state = state.copyWith(isLoading: false);
        },
        (r) {
          var eventsList = (r as GetAllListingsResponseModel).data;
          state = state.copyWith(
              listingList: eventsList,
              isLoading: false,
              filterCount: filterCount);
        },
      );
    } catch (error) {
      debugPrint("get filter event  exception : $error");
      state = state.copyWith(isLoading: false);
    }
  }

  void onResetFilter() {
    state = state.copyWith(filterCount: null);
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();
    state = state.copyWith(isUserLoggedIn: status);
  }

  updateIsFav(bool isFav, int? eventId) {
    final list = state.listingList;
    for (var listing in list) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }
    state = state.copyWith(listingList: list);
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

  void onLoadMoreList(int currPageNo) async {
    int currPageNo = state.currentPageNo;
    currPageNo = currPageNo + 1;
    await getListing(currPageNo);
  }

  updateCardIndex(int index) {
    state = state.copyWith(highlightCount: index);
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

  getRecommendationListing() async {
    try {
      state = state.copyWith(isLoading: true);

      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();
      RecommendationsRequestModel requestModel = RecommendationsRequestModel(
          categoryId: "3",
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      final response =
          await recommendationsUseCase.call(requestModel, responseModel);

      response.fold((left) {
        state = state.copyWith(isLoading: false);
        debugPrint(
            " getRecommendationListing fold exception : ${left.toString()}");
      }, (right) {
        final r = right as GetAllListingsResponseModel;

        state = state.copyWith(recommendationList: r.data, isLoading: false);
      });
    } catch (error) {
      state = state.copyWith(isLoading: false);
      debugPrint(" getRecommendationListing exception:$error");
    }
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
