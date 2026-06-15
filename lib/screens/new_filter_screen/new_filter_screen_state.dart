import 'package:domain/model/response_model/explore_details/explore_details_response_model.dart';
import 'package:domain/model/response_model/filter/get_filter_response_model.dart';

final defaultDate = DateTime(1990);

class NewFilterScreenState {
  List<FilterItem> cityList;
  int selectedCityId;
  String selectedCityName;
  double sliderValue;
  bool isLoading;
  List<FilterItem> categoryList;
  List<String> selectedCategoryName;
  DateTime startDate;
  DateTime endDate;
  List<int> selectedCategoryId;

  //temp values
  List<int> tempCategoryIdList;
  List<String> tempCategoryNameList;
  int tempSelectedCityId;
  String tempSelectedCityName;
  double tempSliderValue;

  NewFilterScreenState(
      this.cityList,
      this.selectedCityId,
      this.sliderValue,
      this.selectedCityName,
      this.isLoading,
      this.categoryList,
      this.selectedCategoryName,
      this.startDate,
      this.endDate,
      this.selectedCategoryId,
      this.tempCategoryIdList,
      this.tempCategoryNameList,
      this.tempSelectedCityId,
      this.tempSelectedCityName,
      this.tempSliderValue);

  factory NewFilterScreenState.empty() {
    return NewFilterScreenState([], 0, 0, "", false, [], [], defaultDate,
        defaultDate, [], [], [], 0, '', 0);
  }

  NewFilterScreenState copyWith(
      {List<FilterItem>? cityList,
      int? selectedCityId,
      double? sliderValue,
      String? selectedCityName,
      bool? isLoading,
      List<FilterItem>? categoryList,
      List<String>? selectedCategoryName,
      DateTime? startDate,
      DateTime? endDate,
      List<int>? selectedCategoryId,
      List<int>? tempCategoryIdList,
      List<String>? tempCategoryNameList,
      int? tempSelectedCityId,
      String? tempSelectedCityName,
      double? tempSliderValue}) {
    return NewFilterScreenState(
        cityList ?? this.cityList,
        selectedCityId ?? this.selectedCityId,
        sliderValue ?? this.sliderValue,
        selectedCityName ?? this.selectedCityName,
        isLoading ?? this.isLoading,
        categoryList ?? this.categoryList,
        selectedCategoryName ?? this.selectedCategoryName,
        startDate ?? this.startDate,
        endDate ?? this.endDate,
        selectedCategoryId ?? this.selectedCategoryId,
        tempCategoryIdList ?? this.tempCategoryIdList,
        tempCategoryNameList ?? this.tempCategoryNameList,
        tempSelectedCityId ?? this.tempSelectedCityId,
        tempSelectedCityName ?? this.tempSelectedCityName,
        tempSliderValue ?? this.tempSliderValue);
  }
}
