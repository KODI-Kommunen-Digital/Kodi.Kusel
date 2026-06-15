import 'package:kusel/screens/fliter_screen/filter_screen_controller.dart';

class FilterScreenState {
  List<String> periodItems;
  List<String> targetGroupItems;
  List<String> cityListItems;
  String? periodValue;
  String? targetGroupValue;
  String? ortItemValue;
  double sliderValue;
  bool isActualityEnabled;
  bool isDistanceEnabled;
  Map<String, bool> toggleFiltersMap;
  String? startAfterDate;
  String? endBeforeDate;
  String? formattedStartDate;
  String? formattedEndDate;
  int? cityId;
  Map<int, String> cityDetailsMap;
  IntervalType? currentIntervalType;
  int? filterCount;

  FilterScreenState(
      this.periodItems,
      this.targetGroupItems,
      this.cityListItems,
      this.periodValue,
      this.targetGroupValue,
      this.ortItemValue,
      this.sliderValue,
      this.isActualityEnabled,
      this.isDistanceEnabled,
      this.toggleFiltersMap,
      this.startAfterDate,
      this.endBeforeDate,
      this.formattedStartDate,
      this.formattedEndDate,
      this.cityId,
      this.cityDetailsMap,
      this.currentIntervalType,
      this.filterCount);

  factory FilterScreenState.empty() {
    return FilterScreenState(
        [],
        ['Option 1', 'Option 2', 'Option 3', 'Option 4'],
        [],
        null,
        null,
        null,
        0,
        false,
        false,
        {
          'Dogs allowed': false,
          'Accessible': false,
          'Reachable by public transport': false,
          'Free of charge': false,
          'Bookable online': false,
          'Open air': false,
          'Card payment possible': false,
        },
        null,
        null,
        "Enter Start Date",
        "Enter End Date",
        null,
        {},
        null,
        null);
  }

  FilterScreenState copyWith(
      {List<String>? periodItems,
      List<String>? targetGroupItems,
      List<String>? cityListItems,
      String? periodValue,
      String? targetGroupValue,
      String? ortItemValue,
      double? sliderValue,
      bool? isActualityEnabled,
      bool? isDistanceEnabled,
      Map<String, bool>? toggleFiltersMap,
      String? formattedStartDate,
      String? formattedEndDate,
      String? startAfterDate,
      String? endBeforeDate,
      int? cityId,
      Map<int, String>? cityDetailsMap,
      IntervalType? currentIntervalType,
      int? filterCount}) {
    return FilterScreenState(
        periodItems ?? this.periodItems,
        targetGroupItems ?? this.targetGroupItems,
        cityListItems ?? this.cityListItems,
        periodValue ?? this.periodValue,
        targetGroupValue ?? this.targetGroupValue,
        ortItemValue ?? this.ortItemValue,
        sliderValue ?? this.sliderValue,
        isActualityEnabled ?? this.isActualityEnabled,
        isDistanceEnabled ?? this.isDistanceEnabled,
        toggleFiltersMap ?? this.toggleFiltersMap,
        startAfterDate ?? this.startAfterDate,
        endBeforeDate ?? this.endBeforeDate,
        formattedStartDate ?? this.formattedStartDate,
        formattedEndDate ?? this.formattedEndDate,
        cityId ?? this.cityId,
        cityDetailsMap ?? this.cityDetailsMap,
        currentIntervalType ?? this.currentIntervalType,
        filterCount ?? this.filterCount);
  }
}
