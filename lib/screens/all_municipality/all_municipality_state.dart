import 'package:domain/model/response_model/explore_details/explore_details_response_model.dart';

class AllMunicipalityScreenState {
  List<City> cityList;
  bool isLoading;

  AllMunicipalityScreenState(this.cityList, this.isLoading);

  factory AllMunicipalityScreenState.empty() {
    return AllMunicipalityScreenState([], false);
  }

  AllMunicipalityScreenState copyWith(
      {List<City>? cityList, bool? isLoading}) {
    return AllMunicipalityScreenState(
        cityList ?? this.cityList, isLoading ?? this.isLoading);
  }
}
