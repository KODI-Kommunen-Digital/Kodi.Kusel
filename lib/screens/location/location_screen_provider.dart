import 'package:core/sign_in_status/sign_in_status_controller.dart';
import 'package:domain/model/request_model/listings/get_all_listings_request_model.dart';
import 'package:domain/model/request_model/listings/search_request_model.dart';
import 'package:domain/model/request_model/poi_coordinate/poi_coordinates_request_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/listings_model/search_listings_response_model.dart';
import 'package:domain/model/response_model/poi_coordinates/poi_coordinates_response_model.dart';
import 'package:domain/usecase/listings/listings_usecase.dart';
import 'package:domain/usecase/poi_coordinates/poi_coordinates_usecase.dart';
import 'package:domain/usecase/search/search_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kusel/locale/localization_manager.dart';
import 'package:kusel/screens/location/bottom_sheet_selected_ui_type.dart';

import 'location_screen_state.dart';

final locationScreenProvider = StateNotifierProvider.autoDispose<
        LocationScreenProvider, LocationScreenState>(
    (ref) => LocationScreenProvider(
          listingsUseCase: ref.read(listingsUseCaseProvider),
          searchUseCase: ref.read(searchUseCaseProvider),
          signInStatusController: ref.read(signInStatusProvider.notifier),
          localeManagerController: ref.read(localeManagerProvider.notifier),
          poiCoordinatesUseCase: ref.read(poiCoordinatesUseCaseProvider),
        ));

class LocationScreenProvider extends StateNotifier<LocationScreenState> {
  ListingsUseCase listingsUseCase;
  SearchUseCase searchUseCase;
  SignInStatusController signInStatusController;
  LocaleManagerController localeManagerController;
  PoiCoordinatesUseCase poiCoordinatesUseCase;

  LocationScreenProvider(
      {required this.listingsUseCase,
      required this.searchUseCase,
      required this.signInStatusController,
      required this.localeManagerController,
      required this.poiCoordinatesUseCase})
      : super(LocationScreenState.empty());

  Future<void> getAllEventList() async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel(
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");
      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();

      state = state.copyWith(allEventList: []);
      final result = await listingsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint("Get all event list fold exception = $l");
      }, (r) {
        final response = r as GetAllListingsResponseModel;

        if (response.data != null) {
          state = state.copyWith(allEventList: response.data);
        }
      });
    } catch (error) {
      debugPrint("Get all event list  exception = $error");
    }
  }

  Future<void> getAllEventListUsingCategoryId(
      String categoryId, int pageNumber) async {
    final catId = int.tryParse(categoryId);
    if (catId == null) return;
    if (state.categoryEventLists.containsKey(catId) && pageNumber == 1) {
      final cachedList = state.categoryEventLists[catId]!;
      final cachedPageNo = state.categoryPageNumbers[catId] ?? 1;
      final hasMore = state.categoryHasMore[catId] ?? false;

      state = state.copyWith(
        allEventCategoryWiseList: cachedList,
        isSelectedFilterScreenLoading: false,
        currentPageNo: cachedPageNo,
        isLoadMoreButtonEnabled: hasMore,
      );
      return;
    }

    if (pageNumber > 1) {
      state = state.copyWith(isMoreListLoading: true);
    } else {
      state = state.copyWith(
        allEventCategoryWiseList: [],
        isSelectedFilterScreenLoading: true,
        currentPageNo: 1,
      );
    }

    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();
      if (pageNumber == 0) pageNumber = 1;

      GetAllListingsRequestModel requestModel = GetAllListingsRequestModel(
        pageNo: pageNumber,
        categoryId: categoryId,
        translate: "${currentLocale.languageCode}-${currentLocale.countryCode}",
      );

      GetAllListingsResponseModel responseModel = GetAllListingsResponseModel();
      final result = await listingsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        state = state.copyWith(isSelectedFilterScreenLoading: false);
      }, (r) {
        final response = r as GetAllListingsResponseModel;
        List<Listing> newEventList = response.data ?? [];

        final currentList = state.categoryEventLists[catId] ?? [];
        final updatedList = [...currentList, ...newEventList];

        final updatedMap = {...state.categoryEventLists};
        updatedMap[catId] = updatedList;

        final updatedPageNumbers = {...state.categoryPageNumbers};
        updatedPageNumbers[catId] = pageNumber;

        final updatedHasMore = {...state.categoryHasMore};
        updatedHasMore[catId] = newEventList.isNotEmpty;


        state = state.copyWith(
          categoryEventLists: updatedMap,
          allEventCategoryWiseList: updatedList,
          categoryPageNumbers: updatedPageNumbers,
          categoryHasMore: updatedHasMore,
          isMoreListLoading: false,
          isSelectedFilterScreenLoading: false,
          isLoadMoreButtonEnabled: newEventList.isNotEmpty,
          currentPageNo: pageNumber,
        );
      });
    } catch (error) {
      state = state.copyWith(isSelectedFilterScreenLoading: false);
      debugPrint("Get all event list  exception = $error");
    }
  }

  updateBottomSheetSelectedUIType(BottomSheetSelectedUIType type) {
    state = state.copyWith(bottomSheetSelectedUIType: type);
    setSliderHeight(type);
  }

  updateSelectedCategory(int? selectedCategory, String? categoryName) {
    state = state.copyWith(
        selectedCategoryId: selectedCategory,
        selectedCategoryName: categoryName);
  }

  void setIsFavorite(bool isFavorite, int? id) {
    for (var listing in state.allEventList) {
      if (listing.id == id) {
        listing.isFavorite = isFavorite;
      }
    }
    state = state.copyWith(allEventList: state.allEventList);
  }

  void setEventItem(Listing event) {
    List<Listing> list = [];
    for (var item in state.allEventList) {
      if (item.id == event.id) list.add(item);
    }

    state = state.copyWith(selectedEvent: event, allEventList: list);
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
          debugPrint('Exception = $l');
          error(l.toString());
          return <Listing>[];
        },
        (r) {
          final listings = (r as SearchListingsResponseModel).data;
          debugPrint('>>>> returned = ${listings?.length}');
          success();
          return listings ?? <Listing>[];
        },
      );
    } catch (e) {
      debugPrint('>>>> Exception = $e');
      error(e.toString());
      return <Listing>[];
    }
  }

  void setHeight(double desiredHeight) {
    final maxHeight = 600.h;
    final position = desiredHeight.h / maxHeight;

    state.panelController.animatePanelToPosition(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void setSliderHeight(BottomSheetSelectedUIType type) {
    if (type == BottomSheetSelectedUIType.allEvent) {
      setHeight(100.h);
    } else if (type == BottomSheetSelectedUIType.eventList) {
      setHeight(500);
    } else {
      setHeight(400);
    }
  }

  updateCategoryId(int? categoryId, String? categoryName) {
    if (categoryId != null && categoryName != null) {
      state = state.copyWith(
          selectedCategoryId: categoryId, selectedCategoryName: categoryName);
    }
  }

  isUserLoggedIn() async {
    final status = await signInStatusController.isUserLoggedIn();

    state = state.copyWith(isUserLoggedIn: status);
  }

  updateIsFav(bool isFav, int? eventId) {
    final list = state.categoryEventLists[state.selectedCategoryId];
    for (var listing in list!) {
      if (listing.id == eventId) {
        listing.isFavorite = isFav;
      }
    }

    final map = state.categoryEventLists ;

    map[state.selectedCategoryId!] =list;

    state = state.copyWith(categoryEventLists: map);
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

  updateSlidingUpPanelIsDragStatus(bool value) {
    state = state.copyWith(isSlidingUpPanelDragAllowed: value);
  }

  void onLoadMoreList(String categoryId) async {
    final catId = int.tryParse(categoryId);
    if (catId == null) return;

    int currPageNo = state.categoryPageNumbers[catId] ?? state.currentPageNo;
    currPageNo = currPageNo + 1;

    await getAllEventListUsingCategoryId(categoryId, currPageNo);
  }

  void resetCategoryPagination(int categoryId) {
    final updatedPageNumbers = {...state.categoryPageNumbers};
    updatedPageNumbers.remove(categoryId);

    final updatedHasMore = {...state.categoryHasMore};
    updatedHasMore.remove(categoryId);

    state = state.copyWith(
      categoryPageNumbers: updatedPageNumbers,
      categoryHasMore: updatedHasMore,
      currentPageNo: 1,
    );
  }

  void markCategoryAsFetched(int categoryId) {
    final updatedMap = {...state.fetchedCategoryMap};
    updatedMap[categoryId] = true;

    state = state.copyWith(fetchedCategoryMap: updatedMap);
  }

  getPoiCoordinates() async {
    try {
      Locale currentLocale = localeManagerController.getSelectedLocale();
      PoiCoordinatesRequestModel requestModel = PoiCoordinatesRequestModel(
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      PoiCoordinatesResponseModel responseModel = PoiCoordinatesResponseModel();

      final res = await poiCoordinatesUseCase.call(requestModel, responseModel);

      res.fold((l) {
        debugPrint('fold exception poi coordinates : $l');
      }, (r) {
        final result = r as PoiCoordinatesResponseModel;

        if (result.data != null) {
          state = state.copyWith(poiCoordinatesItemList: result.data);
        }
      });
    } catch (error) {
      debugPrint('get poi coordinates exception : $error');
    }
  }
}
