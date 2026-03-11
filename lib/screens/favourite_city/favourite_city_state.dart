import 'package:domain/model/response_model/favourite_city/favourite_city_response_model.dart';

class FavouriteCityScreenState {
  List<CityModel> cityList;
  bool isLoading;
  int pageNumber;
  bool isNextPageLoading;

  FavouriteCityScreenState(
      this.cityList, this.isLoading, this.pageNumber, this.isNextPageLoading);

  factory FavouriteCityScreenState.empty() {
    return FavouriteCityScreenState([], true, 1, false);
  }

  FavouriteCityScreenState copyWith(
      {List<CityModel>? cityList,
      bool? isLoading,
      int? pageNumber,
      bool? isNextPageLoading}) {
    return FavouriteCityScreenState(
        cityList ?? this.cityList,
        isLoading ?? this.isLoading,
        pageNumber ?? this.pageNumber,
        isNextPageLoading ?? this.isNextPageLoading);
  }
}
