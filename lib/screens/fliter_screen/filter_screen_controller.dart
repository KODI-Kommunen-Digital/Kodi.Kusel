import 'package:domain/model/request_model/city_details/get_city_details_request_model.dart';
import 'package:domain/model/response_model/city_details/get_city_details_response_model.dart';
import 'package:domain/usecase/city_details/get_city_details_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kusel/screens/fliter_screen/fliter_screen_state.dart';


final filterScreenProvider =
    StateNotifierProvider<FilterScreenProvider, FilterScreenState>(
        (ref) => FilterScreenProvider(
            getCityDetailsUseCase: ref.read(getCityDetailsUseCaseProvider)));

class FilterScreenProvider extends StateNotifier<FilterScreenState> {
  FilterScreenProvider({required this.getCityDetailsUseCase})
      : super(FilterScreenState.empty());

  GetCityDetailsUseCase getCityDetailsUseCase;

  void updateSlider(double value) {
    state = state.copyWith(sliderValue: value);
  }

  void onDropdownItemSelected(String newValue, DropdownType dropdownType, Map<dynamic, String>? mapData, Function() callback) {
    switch (dropdownType) {
      case DropdownType.period:
        {
          if(mapData!=null){
            IntervalType type = mapData.entries
                .firstWhere((entry) => entry.value == newValue).key;
            state = state.copyWith(periodValue: newValue, currentIntervalType: type);
            setDateInterval(type : type, callBack: (){
              callback();
            });
          }
        }
        break;
      case DropdownType.targetGroup:
        state = state.copyWith(targetGroupValue: newValue);
        break;
      case DropdownType.ort:
        state = state.copyWith(ortItemValue: newValue);
        Map<int, String> cityDetailsMap = state.cityDetailsMap;
        int cityId = cityDetailsMap.entries
            .firstWhere((entry) => entry.value == newValue)
            .key;
        state = state.copyWith(cityId: cityId);
        break;
    }
  }

  void setDateInterval({
    required IntervalType type,
    required Function() callBack,
    DateTime? startDate,
    DateTime? endDate,
  })
  {
    final now = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');

    String? startAfterDate;
    String? endBeforeDate;

    switch (type) {
      case IntervalType.today:
        startAfterDate = dateFormat.format(DateTime(now.year, now.month, now.day));
        endBeforeDate = startAfterDate;
        break;

      case IntervalType.weekend:
        final daysUntilSaturday = DateTime.saturday - now.weekday;
        final saturday = now.add(Duration(days: daysUntilSaturday >= 0 ? daysUntilSaturday : 7 + daysUntilSaturday));
        final sunday = saturday.add(Duration(days: 1));
        startAfterDate = dateFormat.format(DateTime(saturday.year, saturday.month, saturday.day));
        endBeforeDate = dateFormat.format(DateTime(sunday.year, sunday.month, sunday.day));
        break;

      case IntervalType.next7Days:
        final start = now.add(Duration(days: 1));
        final end = now.add(Duration(days: 7));
        startAfterDate = dateFormat.format(start);
        endBeforeDate = dateFormat.format(end);
        break;

      case IntervalType.next30Days:
        final start = now.add(Duration(days: 1));
        final end = now.add(Duration(days: 30));
        startAfterDate = dateFormat.format(start);
        endBeforeDate = dateFormat.format(end);
        break;

      case IntervalType.definePeriod:
        if(startDate!=null && endDate!=null){
          startAfterDate = dateFormat.format(startDate);
          endBeforeDate = dateFormat.format(endDate);
          // state = state.copyWith(periodValue: "$startAfterDate to $endBeforeDate");
        }
        callBack();
        break;
    }

    state = state.copyWith(startAfterDate: startAfterDate, endBeforeDate: endBeforeDate);
  }

  void onSortByButtonTap(String buttonType) {
    bool isActualityEnabled = state.isActualityEnabled;
    bool isDistanceEnabled = state.isDistanceEnabled;

    if (buttonType == "Actuality") {
      state = state.copyWith(
        isActualityEnabled: !isActualityEnabled,
        isDistanceEnabled: false,
      );
    } else if (buttonType == "Distance") {
      state = state.copyWith(
        isDistanceEnabled: !isDistanceEnabled,
        isActualityEnabled: false,
      );
    }
  }

  Future<void> pickDate(DateTime? date, bool isStartDate) async {

    if (date != null) {
        final now = DateTime.now();
        final dateFormat = DateFormat('yyyy-MM-dd');
        String startAfterDate =
        dateFormat.format(DateTime(now.year, now.month, now.day));
      if (isStartDate) {
        state = state.copyWith(
            startAfterDate: startAfterDate,
            formattedStartDate: formattedDate(date));
      } else {
        state = state.copyWith(
            endBeforeDate: startAfterDate,
            formattedEndDate: formattedDate(date));
      }

      // selectedDate = date;
    }
  }

  String formattedDate(DateTime? selectedDate) {
    if (selectedDate == null) return "Start Date";
    final weekday = DateFormat('E').format(selectedDate);
    final date = DateFormat('dd.MM.yyyy').format(selectedDate);
    return "$weekday, $date";
  }

  Future<void> fetchCities() async {
    try {
      GetCityDetailsRequestModel requestModel =
          GetCityDetailsRequestModel(hasForum: false);
      GetCityDetailsResponseModel responseModel = GetCityDetailsResponseModel();
      final result =
          await getCityDetailsUseCase.call(requestModel, responseModel);

      result.fold((l) {
        debugPrint('get city details fold exception : $l');
      }, (r) async {
        final response = r as GetCityDetailsResponseModel;

        final cityDetailsMap = <int, String>{};

        if (response.data != null) {
          for (var city in response.data!) {
            if (city.id != null && city.name != null) {
              cityDetailsMap[city.id!] = city.name!;
            }
          }
        }
        state = state.copyWith(
          cityListItems: cityDetailsMap.values.toList(),
          cityDetailsMap: cityDetailsMap
        );
      });
    } catch (error) {
      debugPrint('get city details exception : $error');
    }
  }

  int appliedFilterCount() {
    int count = 0;
    if (state.periodValue != null) {
      count++;
    }
    if (state.targetGroupValue != null) {
      count++;
    }
    if (state.ortItemValue != null) {
      count++;
    }
    if (state.isActualityEnabled || state.isDistanceEnabled) {
      count++;
    }
    if (state.sliderValue > 0) {
      count++;
    }
    final toggleFilterCount =
        state.toggleFiltersMap.values.where((value) => value).length;
    count += toggleFilterCount;

    state = state.copyWith(filterCount: count);
    return count;
  }

  void resetDates() {
    state = state.copyWith(
        formattedStartDate: "Enter Start Date",
        formattedEndDate: "Enter End Date");
  }

  void onToggleUpdate(bool value, String type) {
    final updatedMap = Map<String, bool>.from(state.toggleFiltersMap);
    updatedMap[type] = value;
    state = state.copyWith(toggleFiltersMap: updatedMap);
  }

  void onApplyChanges() {}

  void onCancel() {}

  void onReset() {
    if(mounted){
      state = FilterScreenState.empty().copyWith(
        cityListItems: state.cityListItems,
      );    }
  }
}

enum DropdownType { period, targetGroup, ort }

enum IntervalType { today, weekend, next7Days, next30Days, definePeriod }
