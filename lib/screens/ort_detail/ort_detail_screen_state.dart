import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';
import 'package:domain/model/response_model/ort_detail/ort_detail_response_model.dart';

class OrtDetailScreenState {
  OrtDetailDataModel? ortDetailDataModel;
  bool isLoading;
  bool isUserLoggedIn;
  String error;
  List<Listing> highlightsList;
  List<Listing> eventsList;
  List<Listing> newsList;
  int highlightCount;

  double? latitude;
  double? longitude;

  OrtDetailScreenState(
      this.ortDetailDataModel,
      this.isLoading,
      this.isUserLoggedIn,
      this.error,
      this.highlightsList,
      this.eventsList,
      this.newsList,
      this.highlightCount,
      this.latitude,
      this.longitude);

  factory OrtDetailScreenState.copyWith() {
    return OrtDetailScreenState(
        null, false, false, '', [], [], [], 0, null, null);
  }

  OrtDetailScreenState copyWith({
    OrtDetailDataModel? ortDetailDataModel,
    bool? isLoading,
    bool? isUserLoggedIn,
    String? error,
    List<Listing>? highlightsList,
    List<Listing>? eventsList,
    List<Listing>? newsList,
    int? highlightCount,
    double? latitude,
    double? longitude,
  }) {
    return OrtDetailScreenState(
        ortDetailDataModel ?? this.ortDetailDataModel,
        isLoading ?? this.isLoading,
        isUserLoggedIn ?? this.isUserLoggedIn,
        error ?? this.error,
        highlightsList ?? this.highlightsList,
        eventsList ?? this.eventsList,
        newsList ?? this.newsList,
        highlightCount ?? this.highlightCount,
        latitude ?? this.latitude,
        longitude ?? this.longitude);
  }
}
