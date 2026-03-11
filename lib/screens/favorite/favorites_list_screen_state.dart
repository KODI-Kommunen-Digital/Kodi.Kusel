import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_state.dart';

class FavoritesListScreenState {
  String address;
  String error;
  bool loading;
  List<Listing> eventsList;

  List<String> selectedCategoryNameList;
  int selectedCityId;
  String selectedCityName;
  double radius;
  DateTime startDate;
  DateTime endDate;
  List<int> selectedCategoryIdList;
  int numberOfFiltersApplied;
  bool isPaginationLoading;
  int pageNumber;

  FavoritesListScreenState(
      this.address,
      this.error,
      this.loading,
      this.eventsList,
      this.selectedCategoryNameList,
      this.selectedCityId,
      this.selectedCityName,
      this.radius,
      this.startDate,
      this.endDate,
      this.selectedCategoryIdList,
      this.numberOfFiltersApplied,
      this.isPaginationLoading,
      this.pageNumber);

  factory FavoritesListScreenState.empty() {
    return FavoritesListScreenState('', '', false, [], [], 0, '', 0,
        defaultDate, defaultDate, [], 0, false, 1);
  }

  FavoritesListScreenState copyWith(
      {String? address,
      String? error,
      bool? loading,
      List<Listing>? list,
      List<String>? selectedCategoryNameList,
      int? selectedCityId,
      String? selectedCityName,
      double? radius,
      DateTime? startDate,
      DateTime? endDate,
      List<int>? selectedCategoryIdList,
      int? numberOfFiltersApplied,
      bool? isPaginationLoading,
      int? pageNumber}) {
    return FavoritesListScreenState(
        address ?? this.address,
        error ?? this.error,
        loading ?? this.loading,
        list ?? this.eventsList,
        selectedCategoryNameList ?? this.selectedCategoryNameList,
        selectedCityId ?? this.selectedCityId,
        selectedCityName ?? this.selectedCityName,
        radius ?? this.radius,
        startDate ?? this.startDate,
        endDate ?? this.endDate,
        selectedCategoryIdList ?? this.selectedCategoryIdList,
        numberOfFiltersApplied ?? this.numberOfFiltersApplied,
        isPaginationLoading ?? this.isPaginationLoading,
        pageNumber ?? this.pageNumber);
  }
}
