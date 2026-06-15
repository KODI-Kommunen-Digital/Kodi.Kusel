import 'package:domain/model/response_model/explore_details/explore_details_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class VirtualTownHallState {
  final int highlightCount;
  final List<Listing>? eventList;
  final List<Listing>? newsList;
  final String? cityName;
  final String? cityId;
  final String? imageUrl;
  final String? description;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? phoneNumber;
  final String? email;
  final String? openUntil;
  final String? websiteUrl;
  final List<OnlineService>? onlineServiceList;
  final List<Municipality> municipalitiesList;
  final bool loading;
  final bool isUserLoggedIn;

  VirtualTownHallState(
      this.highlightCount,
      this.eventList,
      this.newsList,
      this.loading,
      this.cityName,
      this.cityId,
      this.imageUrl,
      this.description,
      this.address,
      this.latitude,
      this.longitude,
      this.phoneNumber,
      this.email,
      this.websiteUrl,
      this.openUntil,
      this.onlineServiceList,
      this.municipalitiesList,
      this.isUserLoggedIn);

  factory VirtualTownHallState.empty() {
    return VirtualTownHallState(0, null, null, false, null, null, null, null,
        null, null, null, null, null, null, null, null, [], false);
  }

  VirtualTownHallState copyWith(
      {int? highlightCount,
      List<Listing>? eventList,
      List<Listing>? newsList,
      String? cityName,
      String? cityId,
      String? imageUrl,
      String? description,
      String? address,
      double? latitude,
      double? longitude,
      String? phoneNumber,
      String? email,
      String? openUntil,
      String? websiteUrl,
      List<OnlineService>? onlineServiceList,
      List<Municipality>? municipalitiesList,
      bool? loading,
      bool? isUserLoggedIn}) {
    return VirtualTownHallState(
        highlightCount ?? this.highlightCount,
        eventList ?? this.eventList,
        newsList ?? this.newsList,
        loading ?? this.loading,
        cityName ?? this.cityName,
        cityId ?? this.cityId,
        imageUrl ?? this.imageUrl,
        description ?? this.description,
        address ?? this.address,
        latitude ?? this.latitude,
        longitude ?? this.longitude,
        phoneNumber ?? this.phoneNumber,
        email ?? this.email,
        websiteUrl ?? this.websiteUrl,
        openUntil ?? this.openUntil,
        onlineServiceList ?? this.onlineServiceList,
        municipalitiesList ?? this.municipalitiesList,
        isUserLoggedIn ?? this.isUserLoggedIn);
  }
}
