import 'package:domain/model/request_model/city_details/get_city_details_request_model.dart';
import 'package:domain/model/request_model/filter/get_filter_request_model.dart';
import 'package:domain/model/response_model/city_details/get_city_details_response_model.dart';
import 'package:domain/model/response_model/explore_details/explore_details_response_model.dart';
import 'package:domain/model/response_model/filter/get_filter_response_model.dart';
import 'package:domain/usecase/city_details/get_city_details_usecase.dart';
import 'package:domain/usecase/filter/get_filter_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kusel/screens/new_filter_screen/new_filter_screen_state.dart';

import '../../locale/localization_manager.dart';

final newFilterScreenControllerProvider = StateNotifierProvider.autoDispose<
        NewFilterScreenController, NewFilterScreenState>(
    (ref) => NewFilterScreenController(
        getFilterUseCase: ref.read(getFilterUseCaseProvider),
        localeManagerController: ref.read(localeManagerProvider.notifier)));

class NewFilterScreenController extends StateNotifier<NewFilterScreenState> {
  GetFilterUseCase getFilterUseCase;
  LocaleManagerController localeManagerController;

  NewFilterScreenController(
      {required this.getFilterUseCase, required this.localeManagerController})
      : super(NewFilterScreenState.empty());

  updateSelectedCity(int cityId, String cityName) {
    if (cityId == state.tempSelectedCityId) {
      state = state.copyWith(
          tempSelectedCityId: 0, tempSliderValue: 0, tempSelectedCityName: "");
    } else {
      state = state.copyWith(
          tempSelectedCityId: cityId,
          tempSliderValue: state.sliderValue,
          tempSelectedCityName: cityName);
    }
  }

  updateLocationAndDistanceAllValue() {
    state = state.copyWith(
        tempSelectedCityId: 0, tempSliderValue: 0, tempSelectedCityName: "");
  }

  updateSliderValue(double value) {
    state = state.copyWith(tempSliderValue: value);
  }

  updateSelectedCategoryList(FilterItem filterItem) {
    final nameList = state.tempCategoryNameList;
    final idList = state.tempCategoryIdList;

    if (nameList.contains(filterItem.name)) {
      nameList.remove(filterItem.name);
      idList.remove(filterItem.id);
    } else {
      nameList.add(filterItem.name!);
      idList.add(filterItem.id!);
    }

    state = state.copyWith(
        tempCategoryNameList: nameList, tempCategoryIdList: idList);
  }

  updateCategoryAllValue() {
    state = state.copyWith(tempCategoryNameList: [], tempCategoryIdList: []);
  }

  updateStartEndDate(DateTime startDate, DateTime endDate) {
    state = state.copyWith(startDate: startDate, endDate: endDate);
  }

  fetchFilterList(
      {required List<String> categoryNameList,
      required List<int> categoryIdList,
      required String selectedCityName,
      required int selectedCityId,
      required double radius,
      required DateTime endDate,
      required DateTime startDate}) async {
    try {
      state = state.copyWith(isLoading: true);
      Locale currentLocale = localeManagerController.getSelectedLocale();

      GetFilterRequestModel requestModel = GetFilterRequestModel(
          translate:
              "${currentLocale.languageCode}-${currentLocale.countryCode}");

      GetFilterResponseModel responseModel = GetFilterResponseModel();

      final response = await getFilterUseCase.call(requestModel, responseModel);

      response.fold((l) {
        debugPrint('fetch filter list exception: $l');
        state = state.copyWith(isLoading: false);
      }, (r) {
        final res = r as GetFilterResponseModel;

        if (res.data != null) {
          state = state.copyWith(
              cityList: res.data?.cities?.data,
              categoryList: res.data?.categories?.data,
              selectedCityId: selectedCityId,
              selectedCityName: selectedCityName,
              sliderValue: radius,
              selectedCategoryId: categoryIdList,
              selectedCategoryName: categoryNameList,
              startDate: startDate,
              endDate: endDate);
        }

        state = state.copyWith(isLoading: false);
      });
    } catch (error) {
      debugPrint('fetch filter list exception: $error');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> assignCategoryValues() async {
    final tempCategoryIdList = state.tempCategoryIdList;
    final tempCategoryNameList = state.tempCategoryNameList;

    state = state.copyWith(
        selectedCategoryId: List.from(tempCategoryIdList),
        selectedCategoryName: List.from(tempCategoryNameList));
  }

  Future<void> assignCategoryTemporaryValues(
      List<int> categoryIdList, List<String> categoryNameList) async {
    state = state.copyWith(
        tempCategoryIdList: categoryIdList,
        tempCategoryNameList: categoryNameList);
  }

  Future<void> assignLocationAndDistanceValues() async {
    final sliderRadius = state.tempSliderValue;
    final selectedCityId = state.tempSelectedCityId;
    final selectedCityName = state.tempSelectedCityName;

    state = state.copyWith(
        sliderValue: sliderRadius,
        selectedCityId: selectedCityId,
        selectedCityName: selectedCityName);
  }

  Future<void> assignLocationAndDistanceTemporaryValues() async {
    final sliderRadius = state.sliderValue;
    final selectedCityId = state.selectedCityId;
    final selectedCityName = state.selectedCityName;

    state = state.copyWith(
        tempSliderValue: sliderRadius,
        tempSelectedCityId: selectedCityId,
        tempSelectedCityName: selectedCityName);
  }

  void reset() {
    state = state.copyWith(
        selectedCategoryName: [],
        selectedCategoryId: [],
        selectedCityName: "",
        selectedCityId: 0,
        startDate: defaultDate,
        endDate: defaultDate,
        sliderValue: 0,
        tempCategoryIdList: [],
        tempCategoryNameList: [],
        tempSelectedCityId: 0,
        tempSelectedCityName: "",
        tempSliderValue: 0);
  }
}
