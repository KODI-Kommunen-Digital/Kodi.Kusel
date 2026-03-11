import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/poi_coordinates/poi_coordinates_response_model.dart';
import 'package:kusel/screens/location/bottom_sheet_selected_ui_type.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class LocationScreenState {
  final List<Listing> allEventList;
  final Map<int, List<Listing>> categoryEventLists;
  final Map<int, int> categoryPageNumbers;
  final Map<int, bool> categoryHasMore;
  final List<Listing> allEventCategoryWiseList;
  final int? selectedCategoryId;
  final String? selectedCategoryName;
  final Listing? selectedEvent;
  final BottomSheetSelectedUIType bottomSheetSelectedUIType;
  final PanelController panelController;
  final bool isUserLoggedIn;
  final bool isSlidingUpPanelDragAllowed;
  final int currentPageNo;
  final bool isLoadMoreButtonEnabled;
  final bool isMoreListLoading;
  final bool isSelectedFilterScreenLoading;
  final Map<int, bool> fetchedCategoryMap;
  final List<PoiCoordinateItem> poiCoordinatesItemList;

  LocationScreenState({
    required this.allEventList,
    required this.categoryEventLists,
    this.categoryPageNumbers = const {},
    this.categoryHasMore = const {},
    required this.allEventCategoryWiseList,
    this.selectedCategoryId,
    this.selectedCategoryName,
    this.selectedEvent,
    required this.bottomSheetSelectedUIType,
    required this.panelController,
    required this.isUserLoggedIn,
    required this.isSlidingUpPanelDragAllowed,
    required this.currentPageNo,
    required this.isLoadMoreButtonEnabled,
    required this.isMoreListLoading,
    required this.isSelectedFilterScreenLoading,
    required this.fetchedCategoryMap,
    required this.poiCoordinatesItemList,
  });

  factory LocationScreenState.empty() {
    return LocationScreenState(
      allEventList: [],
      categoryEventLists: {},
      categoryPageNumbers: {},
      categoryHasMore: {},
      allEventCategoryWiseList: [],
      selectedCategoryId: null,
      selectedCategoryName: null,
      selectedEvent: null,
      bottomSheetSelectedUIType: BottomSheetSelectedUIType.allEvent,
      panelController: PanelController(),
      isUserLoggedIn: false,
      isSlidingUpPanelDragAllowed: true,
      currentPageNo: 1,
      isLoadMoreButtonEnabled: false,
      isMoreListLoading: false,
      isSelectedFilterScreenLoading: false,
      fetchedCategoryMap: {},
      poiCoordinatesItemList: [],
    );
  }

  LocationScreenState copyWith({
    List<Listing>? allEventList,
    Map<int, List<Listing>>? categoryEventLists,
    Map<int, int>? categoryPageNumbers,
    Map<int, bool>? categoryHasMore,
    List<Listing>? allEventCategoryWiseList,
    int? selectedCategoryId,
    String? selectedCategoryName,
    Listing? selectedEvent,
    BottomSheetSelectedUIType? bottomSheetSelectedUIType,
    PanelController? panelController,
    bool? isUserLoggedIn,
    bool? isSlidingUpPanelDragAllowed,
    int? currentPageNo,
    bool? isLoadMoreButtonEnabled,
    bool? isMoreListLoading,
    bool? isSelectedFilterScreenLoading,
    Map<int, bool>? fetchedCategoryMap,
    List<PoiCoordinateItem>? poiCoordinatesItemList,
  }) {
    return LocationScreenState(
      allEventList: allEventList ?? this.allEventList,
      categoryEventLists: categoryEventLists ?? this.categoryEventLists,
      categoryPageNumbers: categoryPageNumbers ?? this.categoryPageNumbers,
      categoryHasMore: categoryHasMore ?? this.categoryHasMore,
      allEventCategoryWiseList:
          allEventCategoryWiseList ?? this.allEventCategoryWiseList,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedCategoryName: selectedCategoryName ?? this.selectedCategoryName,
      selectedEvent: selectedEvent ?? this.selectedEvent,
      bottomSheetSelectedUIType:
          bottomSheetSelectedUIType ?? this.bottomSheetSelectedUIType,
      panelController: panelController ?? this.panelController,
      isUserLoggedIn: isUserLoggedIn ?? this.isUserLoggedIn,
      isSlidingUpPanelDragAllowed:
          isSlidingUpPanelDragAllowed ?? this.isSlidingUpPanelDragAllowed,
      currentPageNo: currentPageNo ?? this.currentPageNo,
      isLoadMoreButtonEnabled:
          isLoadMoreButtonEnabled ?? this.isLoadMoreButtonEnabled,
      isMoreListLoading: isMoreListLoading ?? this.isMoreListLoading,
      isSelectedFilterScreenLoading:
          isSelectedFilterScreenLoading ?? this.isSelectedFilterScreenLoading,
      fetchedCategoryMap: fetchedCategoryMap ?? this.fetchedCategoryMap,
      poiCoordinatesItemList:
          poiCoordinatesItemList ?? this.poiCoordinatesItemList,
    );
  }
}
