import 'package:domain/model/response_model/filter/get_filter_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_state.dart';

class AllEventScreenState {
  List<Listing> listingList;
  bool isLoading;
  int? filterCount;
  bool isUserLoggedIn;
  int currentPageNo;
  bool isMoreListLoading;
  bool isLoadMoreButtonEnabled;
  List<String> selectedCategoryNameList;
  int selectedCityId;
  String selectedCityName;
  double radius;
  DateTime startDate;
  DateTime endDate;
  List<int> selectedCategoryIdList;
  int numberOfFiltersApplied;
  List<Listing> recommendationList;
  int highlightCount;

  AllEventScreenState(
      this.listingList,
      this.isLoading,
      this.filterCount,
      this.isUserLoggedIn,
      this.currentPageNo,
      this.isMoreListLoading,
      this.isLoadMoreButtonEnabled,
      this.selectedCategoryNameList,
      this.selectedCityId,
      this.selectedCityName,
      this.radius,
      this.startDate,
      this.endDate,
      this.selectedCategoryIdList,
      this.numberOfFiltersApplied,
      this.recommendationList,
      this.highlightCount);

  factory AllEventScreenState.empty() {
    return AllEventScreenState([], false, null, false, 1, false, true, [], 0,
        "", 0, defaultDate, defaultDate, [], 0, [], 0);
  }

  AllEventScreenState copyWith(
      {List<Listing>? listingList,
      bool? isLoading,
      int? filterCount,
      bool? isUserLoggedIn,
      int? currentPageNo,
      bool? isMoreListLoading,
      bool? isLoadMoreButtonEnabled,
      List<String>? selectedCategoryNameList,
      int? selectedCityId,
      String? selectedCityName,
      double? radius,
      DateTime? startDate,
      DateTime? endDate,
      List<int>? selectedCategoryIdList,
      int? numberOfFiltersApplied,
      List<Listing>? recommendationList,
      int? highlightCount}) {
    return AllEventScreenState(
        listingList ?? this.listingList,
        isLoading ?? this.isLoading,
        filterCount ?? this.filterCount,
        isUserLoggedIn ?? this.isUserLoggedIn,
        currentPageNo ?? this.currentPageNo,
        isMoreListLoading ?? this.isMoreListLoading,
        isLoadMoreButtonEnabled ?? this.isLoadMoreButtonEnabled,
        selectedCategoryNameList ?? this.selectedCategoryNameList,
        selectedCityId ?? this.selectedCityId,
        selectedCityName ?? this.selectedCityName,
        radius ?? this.radius,
        startDate ?? this.startDate,
        endDate ?? this.endDate,
        selectedCategoryIdList ?? this.selectedCategoryIdList,
        numberOfFiltersApplied ?? this.numberOfFiltersApplied,
        recommendationList ?? this.recommendationList,
        highlightCount ?? this.highlightCount);
  }
}
