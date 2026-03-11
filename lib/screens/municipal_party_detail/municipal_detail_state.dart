import 'package:domain/model/response_model/explore_details/explore_details_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class MunicipalDetailState {
  List<Listing> eventList;
  List<Listing> newsList;
  bool showEventLoading;
  bool showNewsLoading;
  bool isLoading;
  List<City> cityList;
  MunicipalPartyDetailDataModel? municipalPartyDetailDataModel;
  bool isUserLoggedIn;

  MunicipalDetailState(
      this.eventList,
      this.newsList,
      this.showEventLoading,
      this.showNewsLoading,
      this.isLoading,
      this.cityList,
      this.municipalPartyDetailDataModel,
      this.isUserLoggedIn);

  factory MunicipalDetailState.empty() {
    return MunicipalDetailState([], [], false, false, false, [], null, false);
  }

  MunicipalDetailState copyWith(
      {List<Listing>? eventList,
      List<Listing>? newsList,
      bool? showEventLoading,
      bool? showNewsLoading,
      bool? isLoading,
      List<City>? cityList,
      MunicipalPartyDetailDataModel? municipalPartyDetailDataModel,
      bool? isUserLoggedIn}) {
    return MunicipalDetailState(
        eventList ?? this.eventList,
        newsList ?? this.newsList,
        showEventLoading ?? this.showEventLoading,
        showNewsLoading ?? this.showNewsLoading,
        isLoading ?? this.isLoading,
        cityList ?? this.cityList,
        municipalPartyDetailDataModel ?? this.municipalPartyDetailDataModel,
        isUserLoggedIn ?? this.isUserLoggedIn);
  }
}
