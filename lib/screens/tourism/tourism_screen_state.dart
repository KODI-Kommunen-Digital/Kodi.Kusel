import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class TourismScreenState {
  List<Listing> allEventList;
  List<Listing> nearByList;
  List<Listing> recommendationList;
  double lat;
  double long;
  bool isRecommendationLoading;
  bool isUserLoggedIn;
  int highlightCount;


  TourismScreenState(
      this.allEventList,
      this.nearByList,
      this.recommendationList,
      this.lat,
      this.long,
      this.isRecommendationLoading,
      this.isUserLoggedIn,
      this.highlightCount
      );

  factory TourismScreenState.empty() {
    return TourismScreenState([], [], [], 0, 0, true, false,0);
  }

  TourismScreenState copyWith(
      {List<Listing>? allEventList,
      List<Listing>? nearByList,
      List<Listing>? recommendationList,
      double? lat,
      double? long,
      bool?  isRecommendationLoading,
      bool? isUserLoggedIn,
      int? highlightCount
      }) {
    return TourismScreenState(
        allEventList ?? this.allEventList,
        nearByList ?? this.nearByList,
        recommendationList ?? this.recommendationList,
        lat ?? this.lat,
        long ?? this.long,
        isRecommendationLoading ?? this.isRecommendationLoading,
        isUserLoggedIn ?? this.isUserLoggedIn,
      highlightCount ?? this.highlightCount
    );
  }
}
