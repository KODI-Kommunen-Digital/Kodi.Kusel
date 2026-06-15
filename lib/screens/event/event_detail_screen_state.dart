import 'package:domain/model/response_model/event_details/event_details_response_model.dart';
import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class EventDetailScreenState {
  String error;
  bool loading;
  Listing eventDetails;
  List<Listing> recommendList;
  bool isFavourite;

  EventDetailScreenState( this.error, this.loading,
      this.eventDetails, this.recommendList, this.isFavourite);

  factory EventDetailScreenState.empty() {
    return EventDetailScreenState( '', false, Listing(), [], false);
  }

  EventDetailScreenState copyWith(
      {
      String? error,
      bool? loading,
      Listing? eventDetails,
      List<Listing>? recommendList,
      bool? isFavourite
      }) {
    return EventDetailScreenState(
        error ?? this.error,
        loading ?? this.loading,
        eventDetails ?? this.eventDetails,
        recommendList ?? this.recommendList,
        isFavourite ?? this.isFavourite
    );
  }
}
