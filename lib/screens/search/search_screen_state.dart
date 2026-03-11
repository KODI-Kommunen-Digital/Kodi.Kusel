import 'package:domain/model/response_model/listings_model/get_all_listings_response_model.dart';

class SearchScreenState {

  List<Listing> searchedList;
  SearchScreenState(this.searchedList);

  factory SearchScreenState.empty() {
    return SearchScreenState([]);
  }

  SearchScreenState copyWith({List<Listing>? searchedList}) {
    return SearchScreenState(
      searchedList ?? this.searchedList
    );
  }
}
