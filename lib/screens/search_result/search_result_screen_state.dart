import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class SearchResultScreenState {
  String address;
  String error;
  bool loading;
  List<Listing> eventsList;
  Map<int, List<Listing>> groupedEvents;
  bool isUserLoggedIn;

  SearchResultScreenState(this.address, this.error, this.loading,
      this.eventsList, this.groupedEvents, this.isUserLoggedIn);

  factory SearchResultScreenState.empty() {
    return SearchResultScreenState('', '', false, [], {}, false);
  }

  SearchResultScreenState copyWith(
      {String? address,
      String? error,
      bool? loading,
      List<Listing>? eventsList,
      Map<int, List<Listing>>? groupedEvents,
      bool? isUserLoggedIn}) {
    return SearchResultScreenState(
        address ?? this.address,
        error ?? this.error,
        loading ?? this.loading,
        eventsList ?? this.eventsList,
        groupedEvents ?? this.groupedEvents,
        isUserLoggedIn ?? this.isUserLoggedIn);
  }
}
