import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/weather/weather_response_model.dart';

class HomeScreenState {
  int highlightCount;
  bool loading;
  String error;
  final List<Listing> highlightsList;
  final List<Listing> eventsList;
  final List<Listing> newsList;
  String userName;
  final List<Listing> nearbyEventsList;
  bool isSignInButtonVisible;
  double? latitude;
  double? longitude;
  WeatherResponseModel? weatherResponseModel;

  HomeScreenState(
    this.highlightCount,
    this.loading,
    this.error,
    this.highlightsList,
    this.eventsList,
    this.newsList,
    this.userName,
    this.nearbyEventsList,
    this.isSignInButtonVisible,
    this.latitude,
    this.longitude,
    this.weatherResponseModel,
  );

  factory HomeScreenState.empty() {
    return HomeScreenState(
      0,
      true,
      '',
      [],
      [],
      [],
      "",
      [],
      true,
      null,
      null,
      null,
    );
  }

  HomeScreenState copyWith({
    int? highlightCount,
    bool? loading,
    String? error,
    List<Listing>? highlightsList,
    List<Listing>? eventsList,
    List<Listing>? newsList,
    String? userName,
    List<Listing>? nearbyEventsList,
    bool? isSignInButtonVisible,
    double? latitude,
    double? longitude,
    WeatherResponseModel? weatherResponseModel,
  }) {
    return HomeScreenState(
      highlightCount ?? this.highlightCount,
      loading ?? this.loading,
      error ?? this.error,
      highlightsList ?? this.highlightsList,
      eventsList ?? this.eventsList,
      newsList ?? this.newsList,
      userName ?? this.userName,
      nearbyEventsList ?? this.nearbyEventsList,
      isSignInButtonVisible ?? this.isSignInButtonVisible,
      latitude ?? this.latitude,
      longitude ?? this.longitude,
      weatherResponseModel ?? this.weatherResponseModel,
    );
  }
}
